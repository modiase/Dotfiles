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
  home.homeDirectory = "/Users/moye";
  

  home.packages = with pkgs; (
    (import ./common.nix { inherit pkgs; }) ++ (import ./mac.nix { inherit pkgs; })
  );

  home.file.".config/nvim" = {
    source = ../nvim;
    recursive = true;
  };

  home.stateVersion = "24.05";
}
