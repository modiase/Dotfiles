{
  description = "Moyewa Odiase - Home Directory Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... } @ inputs:
    let
      username = "moye";
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
    in
    {
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = [
            (self: super: {
              git-credential-vault = super.buildGoModule rec {
                pname = "git-credential-vault";
                version = "unstable-2022-01-22";

                src = super.fetchFromGitHub {
                  owner = "Luzifer";
                  repo = "git-credential-vault";
                  rev = "62480b3d90c28aeda07b656e07b8647d10cf16f3";
                  sha256 = "10ikys73mrkl942yr3kdgznff9p3881rjjkvwnj231v55vlzapra";
                };

                vendorHash = "sha256-USV3K4SCWW5PSlk3H0ZkuzwH/TJiZEr1dG1OuvBN29Y=";

                meta = with super.lib; {
                  description = "A git credential helper for HashiCorp Vault";
                  homepage = "https://github.com/Luzifer/git-credential-vault";
                  license = licenses.mit;
                };
              };
            })
          ];
        };
        modules = [
          ./nix/home.nix
          {
            home.homeDirectory = "/home/${username}";
            home.stateVersion = "24.05";
          }
        ];
      };

      homeConfigurations."${username}-darwin" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
          overlays = [
            (self: super: {
              git-credential-vault = super.buildGoModule rec {
                pname = "git-credential-vault";
                version = "unstable-2022-01-22";

                src = super.fetchFromGitHub {
                  owner = "Luzifer";
                  repo = "git-credential-vault";
                  rev = "62480b3d90c28aeda07b656e07b8647d10cf16f3";
                  sha256 = "10ikys73mrkl942yr3kdgznff9p3881rjjkvwnj231v55vlzapra";
                };

                vendorHash = "sha256-USV3K4SCWW5PSlk3H0ZkuzwH/TJiZEr1dG1OuvBN29Y=";

                meta = with super.lib; {
                  description = "A git credential helper for HashiCorp Vault";
                  homepage = "https://github.com/Luzifer/git-credential-vault";
                  license = licenses.mit;
                };
              };
            })
          ];
        };
        modules = [
          ./nix/home.nix
          {
            home.homeDirectory = "/Users/${username}";
            home.stateVersion = "24.05";
          }
        ];
      };
    };
}
