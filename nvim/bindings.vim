let g:mapleader="\<Space>"

" Managing buffers
" Switch active buffer to next buffer
nnoremap <silent> . :bnext<CR>
" Switch active buffer to previous buffer
nnoremap <silent> , :bprev<CR>
" Go back to the last buffer which was active before the current one
nnoremap <silent> <leader>gp :b#<CR>

" Managing files
" Copy full filepath into register
nmap <silent> cp :let @" = expand("%:p")<CR>
