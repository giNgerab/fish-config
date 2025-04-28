complete -c pandla -e
complete -c pandla -r -F

function pandla
    if test (count $argv) -lt 1
        echo "Usage: pandla yourfile.md [pandoc flags]"
        return 1
    end

    set mdfile $argv[1]
    set flags $argv[2..-1]
    set basename (string replace -r '\.md$' '' (basename -- $mdfile))

    # Convert .md to .latex
    pandoc $mdfile -o "$basename.latex" $flags
    if test $status -ne 0
        echo "Pandoc failed."
        return 1
    end

    # Compile to PDF
    latexmk -pdf -silent "$basename.latex" && latexmk -c "$basename.latex"
    if test $status -ne 0
        echo "Latexmk failed."
        return 1
    end

    rm "$basename.latex"
end
