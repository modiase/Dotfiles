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
  home.homeDirectory = "$HOME";

  home.packages = with pkgs; (
    (import ./common.nix { inherit pkgs; }) ++ (import ./mac.nix { inherit pkgs; })
  );

  home.stateVersion = "24.05";
}
