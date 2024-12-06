function change_directory
    if test -d .git
        set -f _is_git_repo true
    else
        begin
          set -l info (command git rev-parse --git-dir --is-bare-repository 2>/dev/null)
          if set -q info[2]; and test $info[2] = false
              set -f _is_git_repo true
          else
              set -f _is_git_repo false
          end
        end
    end
    if test $_is_git_repo = true
      set -f root (git rev-parse --show-toplevel)
    else
      set -f root (pwd)
    end
    cd (cat (echo $root | psub) (fd . --type d $root | psub) | fzf; or echo '.')
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_user_key_bindings
    bind --mode default \cs change_directory
    set -gx fish_greeting ""
    source $HOME/Dotfiles/git/aliases
end


set -gx DOTFILES "$HOME/Dotfiles"
set -gx MANPAGER "nvim +Man!"

test -f "$HOME/.nix-profile/etc/profile.d/nix.sh";\
    and bass "source $HOME/.nix-profile/etc/profile.d/nix.sh";

if test -f "$HOME/.nix-profile/etc/profile.d/nix.sh"
    bass "source $HOME/.nix-profile/etc/profile.d/nix.sh"
else if test -f '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    bass 'source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
end

alias csv2json 'python -c \'import csv, json, sys; print(json.dumps([dict(r) for r in csv.DictReader(sys.stdin)]))\''

# Ensure last line
test -f $HOME/.config/fish/config.local.fish; and source $HOME/.config/fish/config.local.fish
