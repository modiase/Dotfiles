
if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_user_key_bindings
    bind ! bind_bang
    bind '$' bind_dollar
end

source $HOME/Dotfiles/fish/modules/cargo.fish

test -f $HOME/Dotfiles/fish/config.local.fish && source $HOME/Dotfiles/fish/config.local.fish

set -gx FZF_DEFAULT_COMMAND 'rg --files --follow --no-ignore-vcs --hidden -g "!{**/node_modules/*,**/.git/*}"'
set -gx TERM "alacritty"

# pnpm
set -gx PNPM_HOME "/Users/moye/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end