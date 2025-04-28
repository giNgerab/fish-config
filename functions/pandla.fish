complete -c pandla -e
complete -c pandla -r -F

function pandla
    set mdfile $argv[1]
    set flags $argv[2..-1]
    
    if test (count $argv) -lt 1
        echo "Usage: pandla yourfile.md [pandoc flags]"
        return 1
    end

    # Convert .md to temporary .latex
    pandoc $mdfile -o a.latex $flags

    # Compile to PDF
    latexmk -pdf a.latex -silent -c
    # Clean up
    rm a.latex
end
