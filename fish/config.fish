
if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_user_key_bindings

set -gx DOTFILES "$HOME/Dotfiles"
set -U fish_greeting ""


test -f "$HOME/.nix-profile/etc/profile.d/nix.sh";\
    and bass "source $HOME/.nix-profile/etc/profile.d/nix.sh";

bass $HOME/Dotfiles/git/aliases
test -f $HOME/Dotfiles/fish/config.local.fish; and source $HOME/Dotfiles/fish/config.local.fish

