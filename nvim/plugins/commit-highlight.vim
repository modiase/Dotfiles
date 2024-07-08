if exists("g:loaded_commit_highlight")
    finish
endif
let g:loaded_commit_highlight = 1

function! HighlightCommitAdditions()
    if &filetype == 'gitcommit'
        syntax region commitChanges start=/^# Everything below it will be ignored.$/ end=/\%$/

        syntax match commitAddition /^+.*/ contained containedin=commitChanges
        highlight commitAddition ctermfg=green guifg=green
    endif
endfunction

function! HighlightCommitRemovals()
    if &filetype == 'gitcommit'
        syntax region commitChanges start=/^# Everything below it will be ignored.$/ end=/\%$/

        syntax match commitRemoval /^-.*/ contained containedin=commitChanges
        highlight commitRemoval ctermfg=red guifg=red
    endif
endfunction

augroup CommitHighlight
    autocmd!
    autocmd BufRead,BufNewFile COMMIT_EDITMSG call HighlightCommitAdditions()
    autocmd BufRead,BufNewFile COMMIT_EDITMSG call HighlightCommitRemovals()
augroup END
