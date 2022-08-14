
if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_user_key_bindings
    bind ! bind_bang
    bind '$' bind_dollar
end



set -gx TERM "alacritty"
set -gx DOTFILES "$HOME/Dotfiles"

test -f $HOME/Dotfiles/fish/config.local.fish && source $HOME/Dotfiles/fish/config.local.fish

