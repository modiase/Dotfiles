if exists("g:loaded_commit_highlight")
    finish
endif
let g:loaded_commit_highlight = 1

function! HighlightCommitAdditions()
    if &filetype == 'gitcommit'
        syntax region commitChanges start=/^# Everything below it will be ignored.$/ end=/\%$/

        syntax match commitAddition /^+.*/ contained containedin=commitChanges
        highlight commitAddition guifg=#a3be8c
    endif
endfunction

function! HighlightCommitRemovals()
    if &filetype == 'gitcommit'
        syntax region commitChanges start=/^# Everything below it will be ignored.$/ end=/\%$/

        syntax match commitRemoval /^-.*/ contained containedin=commitChanges
        highlight commitRemoval guifg=#bf616a
    endif
endfunction

augroup CommitHighlight
    autocmd!
    autocmd BufRead,BufNewFile,WinScrolled COMMIT_EDITMSG call HighlightCommitAdditions()
    autocmd BufRead,BufNewFile,WinScrolled COMMIT_EDITMSG call HighlightCommitRemovals()
augroup END
