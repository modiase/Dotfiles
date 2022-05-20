" Move to previous/next
nnoremap <silent>    ≤ :BufferPrevious<CR>
nnoremap <silent>    ≥ :BufferNext<CR>
" Re-order to previous/next

nnoremap <silent>    ¯ :BufferMovePrevious<CR>
nnoremap <silent>    ˘ :BufferMoveNext<CR>
" Goto buffer in position...
nnoremap <silent>    ¡ :BufferGoto 1<CR>
nnoremap <silent>    ™ :BufferGoto 2<CR>
nnoremap <silent>    £ :BufferGoto 3<CR>
nnoremap <silent>    € :BufferGoto 4<CR>
nnoremap <silent>    ∞ :BufferGoto 5<CR>
nnoremap <silent>    § :BufferGoto 6<CR>
nnoremap <silent>    ¶ :BufferGoto 7<CR>
nnoremap <silent>    • :BufferGoto 8<CR>
nnoremap <silent>    ª :BufferLast<CR>
" Pin/unpin buffer
nnoremap <silent>    π :BufferPin<CR>
" Close buffer
nnoremap <silent>    ç :BufferClose<CR>

nnoremap <silent> ø :BufferOrderByBufferNumber<CR>
