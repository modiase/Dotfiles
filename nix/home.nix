{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./tmux.nix
    ./alacritty.nix
    ./fish.nix
    ./neovim.nix
  ];


  home.username = "moye";
  

  home.packages = with pkgs; (
    (import ./common.nix { inherit pkgs; }) ++ (if stdenv.isDarwin then (import ./darwin.nix { inherit pkgs; }) else [])
  );

  home.file.".config/nvim" = {
    source = ../nvim;
    recursive = true;
  };

  home.stateVersion = "24.05";

  systemd.user.services.vault = {
    Unit = {
      Description = "HashiCorp Vault Agent";
      After = [ "network.target" ];
    };

    Service = {
      ExecStart = "${pkgs.vault}/bin/vault server -dev";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
