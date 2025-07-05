
{
  description = "Moyewa Odiase - Home Directory Config";

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

      packages.${system}.default = self.homeConfigurations."moye".activationPackage;

      apps.${system}.default = {
        type = "app";
        program = "${self.homeConfigurations."moye".activationPackage}/activate";
      };
    };
}
