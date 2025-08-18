{
  description = "llama.cpp with state-of-the-art 1B model for macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-darwin" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        modelInfo = {
          name = "google_gemma-3-1b-it";
          repo = "bartowski/google_gemma-3-1b-it-GGUF";
          file = "google_gemma-3-1b-it-Q4_K_M.gguf";
          size = "806MB";
        };

        modelDownloader = pkgs.writeShellScript "download-model" ''
          #!/bin/bash
          set -euo pipefail

          MODEL_DIR="$1"
          MODEL_NAME="${modelInfo.name}"
          MODEL_FILE="${modelInfo.file}"
          HF_REPO="${modelInfo.repo}"

          echo "=== llama.cpp Model Downloader ==="
          echo "Target: $MODEL_DIR/$MODEL_FILE"

          mkdir -p "$MODEL_DIR"
          cd "$MODEL_DIR"

          if [[ -f "$MODEL_FILE" ]]; then
            echo "Model exists. Verifying integrity..."
            if ${pkgs.file}/bin/file "$MODEL_FILE" | grep -q "data"; then
              echo "Model verification passed. Using existing model."
              exit 0
            else
              echo "Model corrupted. Re-downloading..."
              rm -f "$MODEL_FILE"
            fi
          fi

          download_with_retry() {
            local url="$1"
            local output="$2"
            local max_attempts=3
            local delay=5

            for attempt in $(seq 1 $max_attempts); do
              echo "Download attempt $attempt/$max_attempts..."

              if timeout 1800 ${pkgs.curl}/bin/curl \
                -L \
                -C - \
                --retry 3 \
                --retry-delay 10 \
                -H "User-Agent: llama.cpp-nix/1.0" \
                -o "$output.tmp" \
                "$url"; then

                if [[ -f "$output.tmp" ]] && [[ $(stat -c%s "$output.tmp" 2>/dev/null || stat -f%z "$output.tmp") -gt 1000000 ]]; then
                  mv "$output.tmp" "$output"
                  echo "Download successful: $output"
                  return 0
                fi
              fi

              echo "Attempt $attempt failed. Retrying in $delay seconds..."
              rm -f "$output.tmp"
              sleep $delay
              delay=$((delay * 2))
            done

            echo "All download attempts failed"
            return 1
          }

          HF_URL="https://huggingface.co/$HF_REPO/resolve/main/$MODEL_FILE"

          echo "Downloading $MODEL_NAME from Hugging Face..."
          echo "URL: $HF_URL"
          echo "Size: ${modelInfo.size}"

          if download_with_retry "$HF_URL" "$MODEL_FILE"; then
            echo "Model download completed successfully!"

            if ${pkgs.file}/bin/file "$MODEL_FILE" | grep -q "data"; then
              echo "Model integrity verified."
              echo "Model ready: $MODEL_DIR/$MODEL_FILE"
            else
              echo "ERROR: Downloaded model failed verification"
              rm -f "$MODEL_FILE"
              exit 1
            fi
          else
            echo "ERROR: Failed to download model after all attempts"
            exit 1
          fi
        '';

        llamaCpp = pkgs.stdenv.mkDerivation rec {
          pname = "llama-cpp-metal";
          version = "b6060";

          src = pkgs.fetchFromGitHub {
            owner = "ggml-org";
            repo = "llama.cpp";
            rev = "618575c5825d7d4f170e686e772178d2aae148ae";
            hash = "sha256-uPg3P8pRR1B3/b/ddDvdSOTRm4zUBKU0XhwVFO6K2XM=";
          };

          nativeBuildInputs = with pkgs; [
            cmake
            pkg-config
            git
          ];

          buildInputs =
            with pkgs;
            [
              curl
              jq
            ]
            ++ lib.optionals pkgs.stdenv.isDarwin [
              apple-sdk_15
            ];

          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
            "-DGGML_METAL=ON"
            "-DGGML_ACCELERATE=ON"
            "-DLLAMA_CURL=ON"
            "-DBUILD_SHARED_LIBS=OFF"
            "-DLLAMA_BUILD_TESTS=OFF"
            "-DLLAMA_BUILD_EXAMPLES=ON"
            "-DLLAMA_BUILD_SERVER=ON"
          ];

          preConfigure = ''
            export MACOSX_DEPLOYMENT_TARGET=12.0

            if [[ "$OSTYPE" == "darwin"* ]]; then
              echo "Configuring for macOS with Metal acceleration..."
              if ! command -v xcrun &> /dev/null; then
                echo "WARNING: Xcode command line tools not found. Metal compilation may fail."
              fi
            fi
          '';

          installPhase = ''
            runHook preInstall

            mkdir -p $out/bin $out/share/doc

            cp bin/llama-cli $out/bin/
            cp bin/llama-server $out/bin/
            cp bin/llama-quantize $out/bin/
            cp bin/llama-embedding $out/bin/ 2>/dev/null || true

            cp ../README.md $out/share/doc/
            cp -r ../examples $out/share/doc/ 2>/dev/null || true

            if strings $out/bin/llama-cli | grep -q "Metal"; then
              echo "✓ Metal acceleration enabled"
            else
              echo "⚠ Warning: Metal acceleration may not be available"
            fi

            runHook postInstall
          '';

          postInstall = pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
            for binary in $out/bin/*; do
              if [[ -f "$binary" ]] && file "$binary" | grep -q "Mach-O"; then
                echo "Processed binary: $(basename $binary)"
              fi
            done
          '';

          meta = with pkgs.lib; {
            description = "llama.cpp with Metal acceleration for Apple Silicon";
            homepage = "https://github.com/ggml-org/llama.cpp";
            license = licenses.mit;
            platforms = [
              "aarch64-darwin"
              "x86_64-darwin"
            ];
            maintainers = [ "nix-ml-enthusiast" ];
          };
        };

        runtimeWrapper = pkgs.writeShellScript "llama-cpp-runner" ''
          #!/bin/bash
          set -euo pipefail

          APP_NAME="llama-cpp"
          CONFIG_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/$APP_NAME"
          DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/$APP_NAME"
          MODEL_DIR="$DATA_DIR/models"
          MODEL_FILE="${modelInfo.file}"
          DEFAULT_MODEL="$MODEL_DIR/$MODEL_FILE"

          mkdir -p "$CONFIG_DIR" "$MODEL_DIR"

          log() {
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
          }

          detect_system() {
            if [[ "$OSTYPE" == "darwin"* ]]; then
              if [[ $(uname -m) == "arm64" ]]; then
                export DEVICE="mps"
                export PYTORCH_ENABLE_MPS_FALLBACK=1

                CHIP_INFO=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Apple Silicon")
                log "Detected: $CHIP_INFO"

                if echo "$CHIP_INFO" | grep -q "M1"; then
                  export THREADS=4
                elif echo "$CHIP_INFO" | grep -q "M2"; then
                  export THREADS=4
                elif echo "$CHIP_INFO" | grep -q "M3"; then
                  export THREADS=4
                else
                  export THREADS=4
                fi
              else
                export DEVICE="cpu"
                export THREADS=$(sysctl -n hw.ncpu)
              fi
            else
              export DEVICE="cpu"
              export THREADS=$(nproc)
            fi

            log "Configuration: device=$DEVICE, threads=$THREADS"
          }

          ensure_model() {
            if [[ ! -f "$DEFAULT_MODEL" ]]; then
              log "Model not found. Downloading ${modelInfo.name}..."
              log "This may take a while (${modelInfo.size})..."

              if ${modelDownloader} "$MODEL_DIR"; then
                log "Model downloaded successfully!"
              else
                log "ERROR: Model download failed"
                exit 1
              fi
            else
              log "Using cached model: $DEFAULT_MODEL"
            fi
          }

          health_check() {
            log "Running system health check..."

            if ! command -v ${llamaCpp}/bin/llama-cli &> /dev/null; then
              log "ERROR: llama-cli not found"
              return 1
            fi

            if [[ ! -f "$DEFAULT_MODEL" ]]; then
              log "WARNING: Model file not found at $DEFAULT_MODEL"
              return 1
            fi

            if ! ${pkgs.file}/bin/file "$DEFAULT_MODEL" | grep -q "data"; then
              log "ERROR: Model file appears corrupted"
              return 1
            fi

            log "Health check passed ✓"
            return 0
          }

          show_performance_tips() {
            cat << EOF

          === Performance Tips for Apple Silicon ===

          • Model uses GPU acceleration automatically via Metal
          • Optimal performance on M2/M3 with 16GB+ unified memory
          • Use fewer threads for better single-user performance
          • Enable memory locking with --mlock for better performance
          • Monitor system temperature during extended use

          System Info:
          • Device: $DEVICE
          • Threads: $THREADS
          • Model: ${modelInfo.name} (${modelInfo.size})

          EOF
          }

          show_usage() {
            cat << EOF
          llama.cpp Nix Runner - Optimized for macOS/Apple Silicon

          Usage:
            $0 [command] [options]

          Commands:
            run [args]     - Run inference (default)
            download       - Download/update model only
            health         - Run system health check
            info          - Show performance information
            server [args] - Start llama.cpp server
            help          - Show this help

          Common Options:
            -p, --prompt TEXT    Prompt text for generation
            -n, --n-predict NUM  Number of tokens to predict (default: 128)
            -t, --threads NUM    Number of threads (default: auto-detected)
            -c, --ctx-size NUM   Context size (default: 2048)
            --mlock             Lock model in memory
            --verbose           Enable verbose output

          Examples:
            $0 run -p "Explain quantum computing" -n 200
            $0 server --port 8080
            $0 health

          Model: ${modelInfo.name} (${modelInfo.size})
          Config: $CONFIG_DIR
          Cache: $CACHE_DIR
          EOF
          }

          main() {
            local command="''${1:-run}"

            case "$command" in
              help|--help|-h)
                show_usage
                exit 0
                ;;
              download)
                log "Downloading model..."
                ${modelDownloader} "$MODEL_DIR"
                log "Download complete!"
                ;;
              health)
                detect_system
                health_check && log "System ready for inference!"
                ;;
              info)
                detect_system
                show_performance_tips
                ;;
              server)
                shift
                log "Starting llama.cpp server..."
                detect_system
                ensure_model
                health_check

                exec ${llamaCpp}/bin/llama-server \
                  --model "$DEFAULT_MODEL" \
                  --threads "$THREADS" \
                  --ctx-size 4096 \
                  --host 127.0.0.1 \
                  --port 43477 \
                  "$@"
                ;;
              run|*)
                if [[ "$command" != "run" ]]; then
                  set -- "$command" "$@"
                else
                  shift
                fi

                log "Initializing llama.cpp inference..."
                detect_system
                ensure_model
                health_check

                local args=(
                  "--model" "$DEFAULT_MODEL"
                  "--threads" "$THREADS"
                  "--ctx-size" "2048"
                  "--temp" "0.7"
                  "--top-p" "0.9"
                  "--repeat-penalty" "1.1"
                )

                if [[ "$DEVICE" == "mps" ]]; then
                  args+=("--n-gpu-layers" "99")
                fi

                while [[ $# -gt 0 ]]; do
                  case $1 in
                    -p|--prompt)
                      args+=("--prompt" "$2")
                      shift 2
                      ;;
                    -n|--n-predict)
                      args+=("--n-predict" "$2")
                      shift 2
                      ;;
                    -t|--threads)
                      args+=("--threads" "$2")
                      shift 2
                      ;;
                    -c|--ctx-size)
                      args+=("--ctx-size" "$2")
                      shift 2
                      ;;
                    --mlock)
                      args+=("--mlock")
                      shift
                      ;;
                    --verbose)
                      args+=("--verbose")
                      shift
                      ;;
                    *)
                      args+=("$1")
                      shift
                      ;;
                  esac
                done

                log "Executing: llama-cli ''${args[*]}"
                exec ${llamaCpp}/bin/llama-cli "''${args[@]}"
                ;;
            esac
          }

          main "$@"
        '';

        serviceLauncher = pkgs.writeShellScript "llama-server-launcher" ''
          #!/bin/bash
          set -euo pipefail

          DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/llama-cpp"
          MODEL_DIR="$DATA_DIR/models"
          LOG_DIR="$DATA_DIR/logs"
          MODEL_FILE="${modelInfo.file}"
          DEFAULT_MODEL="$MODEL_DIR/$MODEL_FILE"

          mkdir -p "$MODEL_DIR" "$LOG_DIR"

          if [[ ! -f "$DEFAULT_MODEL" ]]; then
            echo "Model not found at $DEFAULT_MODEL, downloading..."
            ${modelDownloader} "$MODEL_DIR"
          fi

          exec ${llamaCpp}/bin/llama-server \
            --model "$DEFAULT_MODEL" \
            --threads 4 \
            --ctx-size 4096 \
            --host 127.0.0.1 \
            --port 43477 \
            --n-gpu-layers 99
        '';

        launchdPlist = pkgs.writeText "com.llamacpp.server.plist" ''
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
          <plist version="1.0">
          <dict>
            <key>Label</key>
            <string>com.llamacpp.server</string>

            <key>ProgramArguments</key>
            <array>
              <string>${serviceLauncher}</string>
            </array>

            <key>EnvironmentVariables</key>
            <dict>
              <key>NIX_CONFIG</key>
              <string>experimental-features = nix-command flakes</string>
            </dict>

            <key>RunAtLoad</key>
            <true/>

            <key>KeepAlive</key>
            <dict>
              <key>SuccessfulExit</key>
              <false/>
            </dict>

            <key>ProcessType</key>
            <string>Background</string>

            <key>Nice</key>
            <integer>10</integer>

            <key>SoftResourceLimits</key>
            <dict>
              <key>NumberOfFiles</key>
              <integer>1024</integer>
              <key>ResidentSetSize</key>
              <integer>4294967296</integer>
            </dict>

            <key>StandardOutPath</key>
            <string>/tmp/llama-cpp-server.out</string>

            <key>StandardErrorPath</key>
            <string>/tmp/llama-cpp-server.err</string>

            <key>WorkingDirectory</key>
            <string>/tmp</string>

            <key>ThrottleInterval</key>
            <integer>10</integer>
          </dict>
          </plist>
        '';

        serviceInstaller = pkgs.writeShellScript "install-service" ''
          #!/bin/bash
          set -euo pipefail

          export NIX_CONFIG="experimental-features = nix-command flakes"

          SERVICE_NAME="com.llamacpp.server"
          PLIST_PATH="$HOME/Library/LaunchAgents/$SERVICE_NAME.plist"

          echo "=== llama.cpp Service Installer ==="

          if [[ -f "$PLIST_PATH" ]] && launchctl list "$SERVICE_NAME" >/dev/null 2>&1; then
            if curl -s --connect-timeout 2 http://127.0.0.1:43477/health >/dev/null 2>&1; then
              echo "✓ Service is already installed and running!"
              echo "✓ Server responding on http://127.0.0.1:43477"
              echo ""
              echo "Management commands:"
              echo "  nix run .#service-status"
              echo "  nix run .#service-reinstall"
              echo "  nix run .#service-uninstall"
              exit 0
            fi
          fi

          mkdir -p "$HOME/Library/LaunchAgents"

          if launchctl list | grep -q "$SERVICE_NAME"; then
            echo "Stopping existing service..."
            launchctl unload "$PLIST_PATH" 2>/dev/null || true
          fi

          echo "Installing service configuration..."
          rm -f "$PLIST_PATH" 2>/dev/null || true
          cp "${launchdPlist}" "$PLIST_PATH"

          echo "Loading service..."
          if launchctl load "$PLIST_PATH" 2>&1; then
            echo "✓ Service loaded successfully"
          else
            echo "⚠ Load command completed (may show harmless errors)"
          fi

          echo "Waiting for service to start..."
          sleep 5

          if launchctl list "$SERVICE_NAME" >/dev/null 2>&1; then
            echo "✓ Service is running!"

            for i in {1..10}; do
              if curl -s --connect-timeout 1 http://127.0.0.1:43477/health >/dev/null 2>&1; then
                echo "✓ Server is responding on port 43477"
                break
              fi
              sleep 1
            done

            if curl -s --connect-timeout 2 http://127.0.0.1:43477/health >/dev/null 2>&1; then
              echo "✓ Installation successful!"
            else
              echo "⚠ Service loaded but server not responding yet"
              echo "  Check logs: tail -f /tmp/llama-cpp-server.err"
            fi

            echo ""
            echo "Server URL: http://127.0.0.1:43477"
            echo ""
            echo "Management commands:"
            echo "  nix run .#service-status"
            echo "  nix run .#service-uninstall"
          else
            echo "❌ Service failed to load"
            exit 1
          fi
        '';

        serviceUninstaller = pkgs.writeShellScript "uninstall-service" ''
          #!/bin/bash
          set -euo pipefail

          export NIX_CONFIG="experimental-features = nix-command flakes"

          SERVICE_NAME="com.llamacpp.server"
          PLIST_PATH="$HOME/Library/LaunchAgents/$SERVICE_NAME.plist"

          echo "=== llama.cpp Service Uninstaller ==="

          SERVICE_EXISTS=false
          PLIST_EXISTS=false

          if launchctl list "$SERVICE_NAME" >/dev/null 2>&1; then
            SERVICE_EXISTS=true
            echo "Stopping service..."
            launchctl unload "$PLIST_PATH" 2>/dev/null || true
            echo "✓ Service unloaded from launchd"
          else
            echo "Service is not loaded in launchd"
          fi

          if pkill -f llama-server 2>/dev/null; then
            echo "✓ llama-server processes terminated"
          else
            echo "No llama-server processes found"
          fi

          if [[ -f "$PLIST_PATH" ]]; then
            PLIST_EXISTS=true
            echo "Removing service configuration..."
            rm -f "$PLIST_PATH"
            echo "✓ Service configuration removed"
          else
            echo "Service configuration not found"
          fi

          if [[ "$SERVICE_EXISTS" = true || "$PLIST_EXISTS" = true ]]; then
            echo "✓ Service uninstalled successfully"
          else
            echo "ℹ No service installation found to remove"
          fi

          LOG_FILES="/tmp/llama-cpp-server.out /tmp/llama-cpp-server.err"
          if rm -f $LOG_FILES 2>/dev/null; then
            echo "✓ Log files cleaned up"
          else
            echo "No log files to clean up"
          fi

          sleep 1
          if curl -s --connect-timeout 1 http://127.0.0.1:43477/health >/dev/null 2>&1; then
            echo "⚠ Warning: Server still responding - may need manual termination"
          else
            echo "✓ Server confirmed stopped"
          fi
        '';

        serviceStatus = pkgs.writeShellScript "service-status" ''
          #!/bin/bash
          set -euo pipefail

          SERVICE_NAME="com.llamacpp.server"
          PLIST_PATH="$HOME/Library/LaunchAgents/$SERVICE_NAME.plist"

          echo "=== llama.cpp Service Status ==="
          echo ""

          if [[ -f "$PLIST_PATH" ]]; then
            echo "✓ Service configuration exists"
          else
            echo "❌ Service configuration not found"
            echo "Run: nix run .#service-install"
            exit 1
          fi

          if launchctl list "$SERVICE_NAME" >/dev/null 2>&1; then
            echo "✓ Service is loaded"

            # Test server endpoint
            if curl -s --connect-timeout 2 http://127.0.0.1:43477/health >/dev/null 2>&1; then
              echo "✓ Server is responding on port 43477"
            else
              echo "⚠ Service loaded but server not responding"
            fi

            # Show recent logs
            echo ""
            echo "Recent stdout (last 5 lines):"
            tail -n 5 /tmp/llama-cpp-server.out 2>/dev/null || echo "No stdout logs"

            echo ""
            echo "Recent stderr (last 5 lines):"
            tail -n 5 /tmp/llama-cpp-server.err 2>/dev/null || echo "No stderr logs"

          else
            echo "❌ Service is not loaded"
            echo "Run: nix run .#service-install"
          fi

          echo ""
          echo "Log files:"
          echo "  stdout: /tmp/llama-cpp-server.out"
          echo "  stderr: /tmp/llama-cpp-server.err"
        '';

        serviceReinstaller = pkgs.writeShellScript "reinstall-service" ''
          #!/bin/bash
          set -euo pipefail

          export NIX_CONFIG="experimental-features = nix-command flakes"

          echo "=== llama.cpp Service Reinstaller ==="
          echo "This will uninstall and reinstall the service with updated configuration."
          echo ""

          echo "Step 1: Uninstalling existing service..."
          ${serviceUninstaller}

          echo ""
          echo "Step 2: Installing updated service..."
          ${serviceInstaller}

          echo ""
          echo "✓ Service reinstalled successfully!"
        '';

        promptClient = pkgs.writeShellScript "prompt-client" ''
          #!/bin/bash
          set -euo pipefail

          PROMPT="$1"
          SERVER_URL="http://127.0.0.1:43477"

          if [[ -z "$PROMPT" ]]; then
            echo "Usage: $0 \"Your prompt here\""
            echo "Example: $0 \"Explain quantum computing in simple terms\""
            exit 1
          fi

          if ! curl -s --connect-timeout 2 "$SERVER_URL/health" >/dev/null 2>&1; then
            echo "❌ Server is not responding at $SERVER_URL"
            echo "Make sure the service is running: nix run .#service-status"
            exit 1
          fi

          ${pkgs.curl}/bin/curl -s -X POST "$SERVER_URL/completion" \
            -H "Content-Type: application/json" \
            -d "$(${pkgs.jq}/bin/jq -n --arg prompt "$PROMPT" '{
              prompt: $prompt,
              max_tokens: 256,
              temperature: 0.7,
              top_p: 0.9
            }')" | ${pkgs.jq}/bin/jq -r '.content'
        '';

      in
      {
        packages = {
          default = self.packages.${system}.llama-cpp-complete;

          llama-cpp = llamaCpp;

          llama-cpp-complete = pkgs.symlinkJoin {
            name = "llama-cpp-complete";
            paths = [ llamaCpp ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              makeWrapper ${runtimeWrapper} $out/bin/llama-nix \
                --prefix PATH : ${
                  pkgs.lib.makeBinPath [
                    pkgs.curl
                    pkgs.file
                  ]
                }

              ln -sf llama-nix $out/bin/llama-run
              ln -sf llama-nix $out/bin/llama

              for binary in llama-cli llama-server llama-quantize; do
                if [[ -f ${llamaCpp}/bin/$binary ]]; then
                  ln -sf ${llamaCpp}/bin/$binary $out/bin/metal-$binary
                fi
              done
            '';

            meta = with pkgs.lib; {
              description = "Complete llama.cpp solution with 1B model for macOS";
              platforms = [
                "aarch64-darwin"
                "x86_64-darwin"
              ];
            };
          };
        };

        apps = {
          default = self.apps.${system}.llama;

          llama = {
            type = "app";
            program = "${self.packages.${system}.llama-cpp-complete}/bin/llama-nix";
          };

          server = {
            type = "app";
            program = "${self.packages.${system}.llama-cpp-complete}/bin/llama-nix";
          };

          download = {
            type = "app";
            program = "${self.packages.${system}.llama-cpp-complete}/bin/llama-nix";
          };

          service-install = {
            type = "app";
            program = "${serviceInstaller}";
          };

          service-uninstall = {
            type = "app";
            program = "${serviceUninstaller}";
          };

          service-status = {
            type = "app";
            program = "${serviceStatus}";
          };

          service-reinstall = {
            type = "app";
            program = "${serviceReinstaller}";
          };

          prompt = {
            type = "app";
            program = "${promptClient}";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cmake
            pkg-config
            git
            curl
            file
            apple-sdk_15
            self.packages.${system}.llama-cpp-complete
          ];
        };
      }
    );
}
