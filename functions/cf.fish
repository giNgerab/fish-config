function cf
    if not test -e $argv[1]
        echo "Error: File does not exist."
        return 1
    end
    set file_path (readlink -e $argv[1])
    set file_uri (string replace -r ' ' '%20' "file://$file_path")
    echo -n $file_uri | wl-copy -t text/uri-list
end
complete -c cf -e
complete -c cf -F
