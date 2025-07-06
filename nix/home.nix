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

  programs.bash.initExtra = ''
    if [[ -z "$FISH_VERSION" && -n "$PS1" && -n "$BASH_VERSION" && -f "${pkgs.fish}/bin/fish" ]]; then
      exec ${pkgs.fish}/bin/fish
    fi
  '';

  programs.zsh.initExtra = ''
    if [[ -z "$FISH_VERSION" && -n "$PS1" && -f "${pkgs.fish}/bin/fish" ]]; then
      exec ${pkgs.fish}/bin/fish
    fi
  '';
}
