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

    set -l all_lines (command cat $dotenv_file)
    set -l totalLines (builtin count $all_lines)
    set lineNumber 0

    while test $lineNumber -lt $totalLines
        set lineNumber (math $lineNumber + 1)
        set -l line $all_lines[$lineNumber]

        # Skip empty lines and comment lines
        if string match -qr '^\s*$|^\s*#' $line
            continue
        end

        if not string match -qr '^[A-Za-z_][A-Za-z0-9_]*=' $line
            echo "Error: invalid declaration (line $lineNumber): $line"
            return 1
        end

        set -l key (string split -m 1 '=' $line)[1]
        set -l after_equals_sign (string split -m 1 '=' $line)[2]

        set -l value

        # Check for triple-quoted multi-line strings (both """ and ''')
        set -l closing_pattern ""
        if string match -qr '^"""' $after_equals_sign
            set closing_pattern '"""$'
        else if string match -qr "^'''" $after_equals_sign
            set closing_pattern "'''\$"
        end

        if test -n "$closing_pattern"
            # Handle triple-quoted strings

            set -l start_line $lineNumber
            set -l content (string sub -s 4 $after_equals_sign)

            if string match -qr -- $closing_pattern $content
                # Single-line triple-quoted
                set value (string sub -e -3 -- $content)
            else
                # Multi-line
                set -l value_lines
                set -a value_lines $content

                # Read subsequent lines until we find closing triple quotes
                set -l found_closing 0
                while test $lineNumber -lt $totalLines
                    set lineNumber (math $lineNumber + 1)
                    set -l next_line $all_lines[$lineNumber]

                    if string match -qr -- $closing_pattern $next_line
                        set found_closing 1
                        set -a value_lines (string sub -e -3 -- $next_line)
                        break
                    else
                        set -a value_lines $next_line
                    end
                end

                if test $found_closing -eq 0
                    echo "Error: unclosed triple-quoted string starting at line $start_line"
                    return 1
                end

                set -l result $value_lines[1]
                for i in (seq 2 (builtin count $value_lines))
                    set result (printf '%s\n%s' $result $value_lines[$i] | string collect --no-trim-newlines)
                end
                set value $result
            end
        else
            # Handle single line values

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
