function on_exit --on-event fish_exit
	if [ $status != 0 ]
		printf "install failed\n" >&2
	else
		printf "install complete\n" >&2
	end
end

set SCRIPT_DIR (cd (dirname (status -f)); and pwd) 
set ROOT_DIR (cd (dirname $SCRIPT_DIR); and pwd) 
source "$SCRIPT_DIR/lib.fish"

function install_nix_packages
	set -f QUIET_FLAG "--quiet"
	if [ $DEBUG -gt 0 ]
		set -f QUIET_FLAG "--verbose"
	end
	nix-env "$QUIET_FLAG" -if "$ROOT_DIR/nix/common.nix"
	if [ $(uname) = "Darwin" ]
		nix-env -i "$QUIET_FLAG" -f "$ROOT_DIR/nix/mac-only.nix"
	end

end

# Fisher is a plugin manager for fish shell
function install_fisher
	if type fisher &>/dev/null
		debug "fisher already installed"
	else
		debug "installing fisher"
		curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher &>/dev/null
	end
end

function install_fish_plugins
	fisher list | grep \^patrickf1/fzf.fish\$ &>/dev/null; and debug "fzf fish already installed"; or fisher install patrickf1/fzf.fish &>/dev/null
	fisher list | grep \^bass\$ &>/dev/null; and debug "bass already installed"; or fisher install edc/bass &>/dev/null
end

function install_vim_plug
	test -f "$HOME/.local/share/nvim/site/autoload/plug.vim"; \
		and debug "vim plug already installed"; \
		or sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
end

install_nix_packages

install_fisher

install_fish_plugins

install_vim_plug
