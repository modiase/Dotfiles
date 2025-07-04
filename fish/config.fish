

if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_user_key_bindings
    bind --mode default \cs change_directory
    set -gx fish_greeting ""
    
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
