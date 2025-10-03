function loadenv
    builtin argparse h/help print printb U/unload -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: loadenv [OPTIONS] [FILE]"
        echo ""
        echo "Export keys and values from a dotenv file."
        echo ""
        echo "Options:"
        echo "  --help, -h      Show this help message"
        echo "  --print         Print env keys (export preview)"
        echo "  --printb        Print keys with surrounding brackets"
        echo "  --unload, -U    Unexport all keys defined in the dotenv file"
        echo ""
        echo "Arguments:"
        echo "  FILE            Path to dotenv file (default: .env)"
        return 0
    end

    if test (builtin count $argv) -gt 1
        echo "Too many arguments. Only one argument is allowed. Use --help for more information."
        return 1
    end

    set -l dotenv_file ".env"
    if test (builtin count $argv) -eq 1
        set dotenv_file $argv[1]
    end

    if not test -f $dotenv_file
        echo "Error: File '$dotenv_file' not found in the current directory."
        return 1
    end

    set -l mode load
    if set -q _flag_print
        set mode print
    else if set -q _flag_printb
        set mode printb
    else if set -q _flag_unload
        set mode unload
    end

    set lineNumber 0

    for line in (command cat $dotenv_file)
        set lineNumber (math $lineNumber + 1)

        # Skip empty lines and comment lines
        if string match -qr '^\s*$|^\s*#' $line
            continue
        end

        if not string match -qr '^[A-Za-z_][A-Za-z0-9_]*=' $line
            echo "Error: invalid declaration (line $lineNumber): $line"
            return 1
        end

        # Parse key and value
        set -l key (string split -m 1 '=' $line)[1]
        set -l after_equals_sign (string split -m 1 '=' $line)[2]

        set -l value
        set -l double_quoted_value_regex '^"(.*)"\s*(?:#.*)*$'
        set -l single_quoted_value_regex '^\'(.*)\'\s*(?:#.*)*$'
        set -l plain_value_regex '^([^\'"\s]*)\s*(?:#.*)*$'
        if string match -qgr $double_quoted_value_regex $after_equals_sign
            set value (string match -gr $double_quoted_value_regex $after_equals_sign)
        else if string match -qgr $single_quoted_value_regex $after_equals_sign
            set value (string match -gr $single_quoted_value_regex $after_equals_sign)
        else if string match -qgr $plain_value_regex $after_equals_sign
            set value (string match -gr $plain_value_regex $after_equals_sign)
        else
            echo "Error: invalid value (line $lineNumber): $line"
            return 1
        end

        switch $mode
            case print
                echo "$key=$value"
            case printb
                echo "[$key=$value]"
            case load
                set -gx $key $value
            case unload
                set -e $key
        end
    end

end
