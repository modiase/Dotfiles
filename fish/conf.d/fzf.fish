set -a FZF_DEFAULT_OPTS "--height 40% --layout=reverse --extended $FZF_THEME"
set -a FZF_DEFAULT_COMMAND "fd --type file --hidden --follow --exclude .git"
set -a FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -a FZF_ALT_C_COMMAND "fd --type directory --hidden"
