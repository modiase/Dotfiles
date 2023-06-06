call plug#begin()

Plug 'kyazdani42/nvim-web-devicons'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'FelipeCRamos/nord-vim-darker'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'jreybert/vimagit'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-rhubarb'
Plug 'alexghergh/nvim-tmux-navigation'
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
Plug 'glepnir/dashboard-nvim'
Plug 'folke/which-key.nvim'
Plug 'airblade/vim-rooter'
Plug 'moll/vim-bbye'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-project.nvim'
Plug 'frazrepo/vim-rainbow'
Plug 'akinsho/git-conflict.nvim'
Plug 'simeji/winresizer'
Plug 'f-person/git-blame.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'psliwka/vim-smoothie'
Plug 'petobens/poet-v'
Plug 'Shatur/neovim-session-manager'
Plug 'mhanberg/output-panel.nvim'
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

let plugin_config_paths = globpath('~/Dotfiles/nvim/plugins', '*.vim', 'index.vim',1) + globpath('~/Dotfiles/nvim/plugins', '*.lua', 1,1)
for path in plugin_config_paths	
	if match(path, 'index.vim') == -1
		exec "source " . path	
	endif
endfor

