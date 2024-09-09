function gbr
    argparse 'd/delete' -- $argv
    echo $_flag_D
    if test -z "$argv"
        set target (git branch | fzf | sed -e 's/^ *[\*\+]* *//')
        if test -n "$target"; and [ "$target" != "$(git branch --show)" ]
            if test -n "$_flag_d"
                read -l -P "Delete branch '$target' [y/N]: " confirm
                if [ "$confirm" = 'y' ]
                    git branch -d "$target"
                end
            else
                git checkout $target
            end
        end
    else
        git branch $argv
    end
end

complete -c gbr -w 'git branch'
