
if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_user_key_bindings

set -gx DOTFILES "$HOME/Dotfiles"
set -U fish_greeting ""


test -f "$HOME/.nix-profile/etc/profile.d/nix.sh";\
    and bass "source $HOME/.nix-profile/etc/profile.d/nix.sh";

if test -f "$HOME/.nix-profile/etc/profile.d/nix.sh"
    bass "source $HOME/.nix-profile/etc/profile.d/nix.sh"
else if test -f '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    bass 'source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
end

source $HOME/Dotfiles/git/aliases
test -f $HOME/.config/fish/config.local.fish; and source $HOME/.config/fish/config.local.fish

