{ config, pkgs, ... }:

let
  moye-pkgs = import ../pkgs { inherit pkgs; };
in
{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "moye-fish-plugins";
        src = moye-pkgs.moye-fish-plugins;
      }
    ];
    shellAbbrs = {
      csv2json = "python -c 'import csv, json, sys; print(json.dumps([dict(r) for r in csv.DictReader(sys.stdin)]))'";
    };
    shellInit = ''
      set -gx DOTFILES "$HOME/Dotfiles"
      set -gx MANPAGER "nvim +Man!"
    '';
    interactiveShellInit = ''
      fish_user_key_bindings
      bind \cs change_directory
      set -gx fish_greeting ""
    '';
  };
}
