function touch2 -d "Creates a file and any necessary parent directories"
    if test (count $argv) -lt 1
        echo "usage: touch2 <filepath>"
        return 1
    end
    set -l file $argv[1]
    set -l dir (dirname $file)
    set -l base (basename $file)
    mkdir -p $dir
    touch "$dir/$base"
end
