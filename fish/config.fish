
if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_user_key_bindings

set -gx TERM "alacritty"
set -gx DOTFILES "$HOME/Dotfiles"

test -f $HOME/Dotfiles/fish/config.local.fish && source $HOME/Dotfiles/fish/config.local.fish

# pnpm
set -gx PNPM_HOME "/Users/moye/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end
