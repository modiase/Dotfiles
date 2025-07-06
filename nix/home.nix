{ config, pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./fish.nix
    ./git.nix
    ./neovim.nix
    ./tmux.nix
    ./zsh.nix
  ];


  home.username = "moye";
  

  home.packages = with pkgs; (
    (import ./common.nix { inherit pkgs; }) ++ (if stdenv.isDarwin then (import ./darwin.nix { inherit pkgs; }) else [])
  );

  home.file.".config/nvim" = {
    source = ../nvim;
    recursive = true;
  };

  home.activation.create-pass-git-helper-config = ''
    if [ ! -f "$HOME/.config/pass-git-helper/git-pass-mapping.ini" ]; then
      mkdir -p "$HOME/.config/pass-git-helper"
      touch "$HOME/.config/pass-git-helper/git-pass-mapping.ini"
    fi
  '';

  home.stateVersion = "24.05";
}
