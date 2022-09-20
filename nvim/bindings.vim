let g:mapleader="\<Space>"

" Buffer management
nnoremap <silent> . :bnext<CR>
nnoremap <silent> , :bprev<CR>
nnoremap <silent> <leader>gp :b#<CR>

vmap <Tab> >gv
vmap <S-Tab> <gv
nmap <silent> cp :let @" = expand("%:p")<CR>


