
if status is-interactive
    # Commands to run in interactive sessions can go here
end

function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
    end
end

function bind_dollar
    switch (commandline -t)[-1]
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

function fish_user_key_bindings
    bind ! bind_bang
    bind '$' bind_dollar
end

source $HOME/Dotfiles/fish/modules/cargo.fish

test -f $HOME/Dotfiles/fish/config.local.fish && source $HOME/Dotfiles/fish/config.local.fish
