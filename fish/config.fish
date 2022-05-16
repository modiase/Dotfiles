
if status is-interactive
    # Commands to run in interactive sessions can go here
end

source $HOME/Dotfiles/fish/modules/cargo.fish

test -f $HOME/Dotfiles/fish/config.local.fish && source $HOME/Dotfiles/fish/config.local.fish
