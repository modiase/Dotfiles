{ pkgs, ... }:

let
  execFish = ''
    in_nix_environment() {
       [[ -n "$NIX_GCROOT" ]] && return 0
       [[ -n "$IN_NIX_SHELL" ]] && return 0
       return 1
    }

    # Only run execFish for actual interactive user shells
    # Skip if any of these conditions are true:
    # - Not an interactive shell
    # - Fish is disabled via NO_FISH
    # - Fish is not available
    # - In a Nix environment
    # - Cursor agent is running
    # - Running in a non-terminal environment (no TTY)
    # - Parent process is not a terminal/shell
    # - Running in background or non-interactive context
    if [[ $- == *i* && -z "$NO_FISH" ]] && \
       type fish > /dev/null 2>&1 && \
       ! in_nix_environment && \
       [[ -z "$CURSOR_AGENT" ]] && \
       [[ -t 0 && -t 1 ]] && \
       [[ "$(ps -o comm= -p $PPID)" =~ (login|sshd|tmux|screen|zsh|bash|alacritty) ]]; then
       exec fish
    fi
  '';

  nixInit = ''
    if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
    if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
      . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
  '';

in
{
  programs = {
    bash = {
      enable = true;
      initExtra =
        nixInit
        + ''
          if [ -f "$HOME/.bashrc.local" ]; then
            source "$HOME/.bashrc.local"
          fi
        ''
        + execFish;
    };

    zsh = {
      enable = true;
      profileExtra = ''
        if [ -n "$ZSH_VERSION" ]; then
          source ~/.zshrc
        fi
      '';
      initContent =
        nixInit
        + ''
          if [ -f "$HOME/.zshrc.local" ]; then
            source "$HOME/.zshrc.local"
          fi
        ''
        + execFish;
    };
  };
}
