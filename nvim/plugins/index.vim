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

call plug#end()

source ~/Dotfiles/nvim/plugins/airline.vim
source ~/Dotfiles/nvim/plugins/bufferline.lua
source ~/Dotfiles/nvim/plugins/blamer.vim
source ~/Dotfiles/nvim/plugins/coc.vim
source ~/Dotfiles/nvim/plugins/comment.lua
source ~/Dotfiles/nvim/plugins/dashboard.lua
source ~/Dotfiles/nvim/plugins/git-conflict.lua
source ~/Dotfiles/nvim/plugins/nvim-tmux-navigation.vim
source ~/Dotfiles/nvim/plugins/telescope.vim
source ~/Dotfiles/nvim/plugins/vim-bbye.vim
source ~/Dotfiles/nvim/plugins/vim-rooter.vim
source ~/Dotfiles/nvim/plugins/which-key.vim
