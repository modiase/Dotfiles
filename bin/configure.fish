
set EXIT_FAILURE 1

function on_exit --on-event fish_exit
	if test $status != 0
		printf "configure failed\n" >&2
	else
		printf "configure complete\n" >&2
	end
end

set SCRIPT_DIR (cd (dirname (status -f)); and pwd) 
set ROOT_DIR (cd (dirname $SCRIPT_DIR); and pwd) 
source "$SCRIPT_DIR/lib.fish"

function configure_fish
	softreplace "$ROOT_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
	for f in (find "$ROOT_DIR/fish/functions" -type f -maxdepth 1 -name "*.fish")
		set -l base (basename "$f")
		softreplace "$f" "$HOME/.config/fish/functions/$base"
	end
end

function configure_alacritty
	mkdir -p "$HOME/.config/alacritty"
	set -f ESCAPED_SHELL (printf $SHELL | sed -e 's/[\/]/\\\\\//g')
	set -f ALACRITTY_YML (mktemp)
	cat "$ROOT_DIR/alacritty/template.alacritty.yml" | sed -e "s/<<SHELL>>/$ESCAPED_SHELL/g" > "$ALACRITTY_YML"
	if test -f "$HOME/.config/alacritty/alacritty.yml"
		if not test (cat "$HOME/.config/alacritty/alacritty.yml" | $SHASUM) = (cat $ALACRITTY_YML | $SHASUM)
			debug "Generating alacritty.yml"
			mkbackup "$HOME/.config/alacritty/alacritty.yml"
			mv "$ALACRITTY_YML" "$HOME/.config/alacritty/alacritty.yml"
		end
	else
		debug "Generating alacritty.yml"
		mv "$ALACRITTY_YML" "$HOME/.config/alacritty/alacritty.yml"
	end
	rm -f "$ALACRITTY_YML"
end

function configure_nvim
	softreplace "$ROOT_DIR/nvim/init.vim" "$HOME/.config/nvim/init.vim"
end

function configure_tmux
	softreplace "$ROOT_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
end

function configure_nix
	softreplace "$ROOT_DIR/nix/nix.conf" "$HOME/.config/nix/nix.conf"
end

function configure_login_shell
	set -f FISH_BIN_PATH "$HOME/.nix-profile/bin/fish"
	set -f SOURCE_NIX "test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
	if test (echo $SHELL | rg "zsh")


		if not test -f "$HOME/.zshrc"; or not test (rg "$SOURCE_NIX" "$HOME/.zshrc")
			set -l TMP (mktemp) && cat ~/.zshrc > $TMP
			cat (echo "$SOURCE_NIX" | psub) $TMP > "$HOME/.zshrc"
		end

		if not test -f "$HOME/.zshrc"; or not test (rg "exec $FISH_BIN_PATH" "$HOME/.zshrc")
			echo "exec $FISH_BIN_PATH" >> "$HOME/.zshrc"
		end

		if not test -f "$HOME/.zprofile"; or not test (rg "source $HOME/.zshrc" "$HOME/.zprofile")
			echo "source $HOME/.zshrc" >> "$HOME/.zprofile"
		end

	else if test (echo $SHELL | rg "bash")

		if not test -f "$HOME/.bashrc"; or not test (rg "$SOURCE_NIX" "$HOME/.bashrc")
			set -l TMP (mktemp) && cat ~/.bashrc > $TMP
			cat (echo "$SOURCE_NIX" | psub) $TMP > "$HOME/.bashrc"
		end
		
		if not test -f "$HOME/.bashrc"; or not test (rg "exec $FISH_BIN_PATH" "$HOME/.bashrc")
			echo "exec $FISH_BIN_PATH" >> "$HOME/.bashrc"
		end

		if not test -f "$HOME/.bash_profile"; or not test (rg "source $HOME/.bashrc" "$HOME/.bash_profile")
			echo "source $HOME/.bashrc" >> "$HOME/.bash_profile"
		end

	else
		echo "Unsupported shell"
		exit $EXIT_FAILURE
	end
end

function configure_vim_plugins
	debug "Installing vim plugins"
	nvim --headless +PlugInstall +q &>/dev/null &
end

configure_fish

configure_alacritty

configure_nvim

configure_nix

configure_tmux

configure_login_shell

configure_vim_plugins
