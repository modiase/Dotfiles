set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --extended $FZF_THEME"
set -gx FZF_DEFAULT_COMMAND "rg --files --follow --no-ignore-vcs --hidden -g \"!{**/node_modules/*,**/.git/*}\" 2>/dev/null"
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND "fd --type directory --hidden"
