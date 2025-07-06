{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    profileExtra = if !pkgs.stdenv.isDarwin then ''
      if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fi
    '' else "";
    initExtra = if !pkgs.stdenv.isDarwin then ''
      if [[ $- == *i* ]] && [ -f "$HOME/.nix-profile/bin/fish" ]; then
        exec "$HOME/.nix-profile/bin/fish"
      fi
    '' else "";
  };
}