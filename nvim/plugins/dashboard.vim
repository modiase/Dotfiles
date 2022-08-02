
nmap <Leader>ss :<C-u>SessionSave<CR>
nmap <Leader>sl :<C-u>SessionLoad<CR>
nnoremap <silent> <Leader>fh <cmd>Telescope help_tags<CR>
nnoremap <silent> <Leader>ff <cmd>Telescope find_files<CR>
nnoremap <silent> <Leader>tc <cmd>Telescope colorscheme<CR>
nnoremap <silent> <Leader>cn :DashboardNewFile<CR>


:autocmd VimLeave * <silent> :SessionSave<CR>

