complete -c pandla -e
complete -c pandla -r -F

function pandla

    function on_exit --on-signal SIGINT --on-signal SIGTERM --on-event IMDONE
        printf "Cleanup\n"
        printf "Killing children of %d: %s\n" \
            $fish_pid \
            (pgrep -P $fish_pid | string join ', ')
        pkill -P $fish_pid
        if test -n "$TEMPF"
            rm -rf -- "$TEMPF" && printf "Removed auxdir (%s)\n" $TEMPF
        end
    end

    set -l TEMPF (mktemp -d)

    if test (count $argv) -lt 1
        echo "Usage: pandla yourfile.latex [latexmk flags]"
        return 1
    end

    set -l lxfile $argv[1]
    set -e argv[1]  # remove the input file from remaining args
    set -l outdir (dirname -- "$lxfile")

    # Compile to PDF: PDF in same directory as source, aux in temp
    latexmk -pvc -ps -pdf "$lxfile" -auxdir="$TEMPF" -outdir="$outdir" $argv

    emit IMDONE

end
