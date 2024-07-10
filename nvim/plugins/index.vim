call plug#begin()


Plug 'FelipeCRamos/nord-vim-darker'
Plug 'Shatur/neovim-session-manager'
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
Plug 'akinsho/git-conflict.nvim'
Plug 'aserowy/tmux.nvim'
Plug 'dhruvasagar/vim-buffer-history'
Plug 'f-person/git-blame.nvim'
Plug 'folke/flash.nvim'
Plug 'folke/which-key.nvim'
Plug 'frazrepo/vim-rainbow'
Plug 'glepnir/dashboard-nvim'
Plug 'jreybert/vimagit'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'mhanberg/output-panel.nvim'
Plug 'moll/vim-bbye'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'numToStr/Comment.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-live-grep-args.nvim'
Plug 'nvim-telescope/telescope-project.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'petobens/poet-v'
Plug 'psliwka/vim-smoothie'
Plug 'sheerun/vim-polyglot'
Plug 'simeji/winresizer'
Plug 'smithbm2316/centerpad.nvim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

let plugin_config_paths = globpath('~/Dotfiles/nvim/plugins', '*.vim', 'index.vim',1) + globpath('~/Dotfiles/nvim/plugins', '*.lua', 1,1)
for path in plugin_config_paths	
	if match(path, 'index.vim') == -1
		exec "source " . path	
	endif
endfor

