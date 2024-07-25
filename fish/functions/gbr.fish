function gbr
    if test -z "$argv" 
        set target (git branch | fzf | sed -e 's/^ *[\*\+]* *//')
        if test -n "$target"; and [ "$target" != "$(git branch --show)" ]
            git checkout $target
        end
    else
        git branch $argv
    end
end
