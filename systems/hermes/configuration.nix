{
  config,
  pkgs,
  modulesPath,
  authorizedKeyLists,
  commonNixSettings,
  ...
}:

let
  rootDomain = "modiase.dev";
in
{
  imports = [
    ./hardware-configuration.nix
    ./services/ntfy.nix
    ./services/n8n.nix
    ./services/nginx.nix
    ./services/backups.nix
    (modulesPath + "/virtualisation/google-compute-image.nix")
    commonNixSettings
  ];

  _module.args.rootDomain = rootDomain;

  networking.hostName = "hermes";
  time.timeZone = "Europe/London";

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "n8n"
    ];

  environment.systemPackages = with pkgs; [
    curl
    git
    google-cloud-sdk
    htop
    rclone
    rsync
    vim
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  users.users.moye = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.bashInteractive;
    openssh.authorizedKeys.keys = authorizedKeyLists.moye;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
    extraRules = [
      {
        users = [ "moye" ];
        commands = [
          {
            command = "ALL";
            options = [
              "NOPASSWD"
              "SETENV"
            ];
          }
        ];
      }
    ];
  };

  systemd.services.clone-dotfiles = {
    description = "Clone Dotfiles repo for moye";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "moye";
      WorkingDirectory = "/home/moye";
    };
    script = ''
      if [ ! -d Dotfiles ]; then
        GIT_TERMINAL_PROMPT=0 ${pkgs.git}/bin/git clone --depth 1 https://github.com/moye/Dotfiles Dotfiles
      fi
    '';
  };

  systemd.services.fetch-ssl-key = {
    description = "Fetch SSL private key from Secret Manager";
    wantedBy = [ "nginx.service" ];
    before = [ "nginx.service" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
            mkdir -p /etc/ssl/private /etc/ssl/certs
            ${pkgs.google-cloud-sdk}/bin/gcloud secrets versions access latest --secret="hermes-cert-private-key" --project="modiase-infra" > /etc/ssl/private/cloudflare-origin.key
            chown nginx:nginx /etc/ssl/private/cloudflare-origin.key
            chmod 600 /etc/ssl/private/cloudflare-origin.key

            cat > /etc/ssl/certs/cloudflare-origin.pem << 'EOF'
      -----BEGIN CERTIFICATE-----
      MIIDIjCCAsigAwIBAgIUaRJibPQ8H+nI+WhP2xXmqX/8ItowCgYIKoZIzj0EAwIw
      gY8xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1T
      YW4gRnJhbmNpc2NvMRkwFwYDVQQKExBDbG91ZEZsYXJlLCBJbmMuMTgwNgYDVQQL
      Ey9DbG91ZEZsYXJlIE9yaWdpbiBTU0wgRUNDIENlcnRpZmljYXRlIEF1dGhvcml0
      eTAeFw0yNTEwMDMxNjE3MDBaFw00MDA5MjkxNjE3MDBaMGIxGTAXBgNVBAoTEENs
      b3VkRmxhcmUsIEluYy4xHTAbBgNVBAsTFENsb3VkRmxhcmUgT3JpZ2luIENBMSYw
      JAYDVQQDEx1DbG91ZEZsYXJlIE9yaWdpbiBDZXJ0aWZpY2F0ZTBZMBMGByqGSM49
      AgEGCCqGSM49AwEHA0IABAywgQC2rla3SrEETWY1UUneSCCOdf5AD492mQxKpNKS
      5toDuCs2m4U9skn2We/ZRX8ExvOwc+GKk/MEed2+2nijggEsMIIBKDAOBgNVHQ8B
      Af8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMBMAwGA1UdEwEB
      /wQCMAAwHQYDVR0OBBYEFLstKfAXdv8eFyt3FLynR6ko7Z6CMB8GA1UdIwQYMBaA
      FIUwXTsqcNTt1ZJnB/3rObQaDjinMEQGCCsGAQUFBwEBBDgwNjA0BggrBgEFBQcw
      AYYoaHR0cDovL29jc3AuY2xvdWRmbGFyZS5jb20vb3JpZ2luX2VjY19jYTAlBgNV
      HREEHjAcgg0qLm1vZGlhc2UuZGV2ggttb2RpYXNlLmRldjA8BgNVHR8ENTAzMDGg
      L6AthitodHRwOi8vY3JsLmNsb3VkZmxhcmUuY29tL29yaWdpbl9lY2NfY2EuY3Js
      MAoGCCqGSM49BAMCA0gAMEUCIEqBftkhc9xhcY1yEikbt5xN/Ik7vxGy1+Kd2XOC
      ObOUAiEA6G4E9w57RXUGEyhFAz+mrKMS0S9gcicUV8aDwwJkogU=
      -----END CERTIFICATE-----
      EOF
            chmod 644 /etc/ssl/certs/cloudflare-origin.pem
    '';
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      80
      443
    ];
  };

  environment.variables = {
    HERMES_GCS_BUCKET = "modiase-infra-hermes";
    HERMES_PROJECT_ID = "modiase-infra";
  };

  system.stateVersion = "24.05";
}
