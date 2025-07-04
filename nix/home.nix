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
    (import ./common.nix) ++ (import ./mac.nix)
  );

  home.stateVersion = "24.05";
}
