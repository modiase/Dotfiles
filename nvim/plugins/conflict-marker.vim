"" disable the default highlight group
let g:conflict_marker_highlight_group = ''

" Include text after begin and end markers
let g:conflict_marker_begin = '^<<<<<<< .*$'
let g:conflict_marker_end   = '^>>>>>>> .*$'

highlight ConflictMarkerBegin cterm=bold guifg=#2F7366
highlight ConflictMarkerOurs guifg=#2E5049
highlight ConflictMarkerTheirs guifg=#344F69
highlight ConflictMarkerEnd guifg=#2F628E
highlight ConflictMarkerCommonAncestorsHunk guifg=#754A81

