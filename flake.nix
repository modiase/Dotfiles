
{
  description = "Moye's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      devShells.${system}.default = import ./nix/shell.nix { inherit pkgs; };

      homeConfigurations."moye" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./nix/home.nix ];
      };

      apps.${system}.default = {
        type = "app";
        program = home-manager.lib.homeManagerConfiguration { modules = [ ./nix/home.nix ]; };
      };
    };
}
