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

  home.file.".config/pass-git-helper/git-pass-mapping.ini" = {
    text = ''
      [github.com*]
      target=git/github.com
    '';
  };

  home.stateVersion = "24.05";
}
