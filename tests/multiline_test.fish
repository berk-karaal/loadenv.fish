source functions/loadenv.fish

loadenv tests/multiline.env

# Helper function to build multi-line strings
function build_multiline
    set -l lines $argv
    set -l result $lines[1]
    for i in (seq 2 (count $lines))
        # Use string collect with --no-trim-newlines to preserve all newlines
        set result (printf '%s\n%s' $result $lines[$i] | string collect --no-trim-newlines)
    end
    printf '%s' $result
end

# Test basic multi-line with triple double quotes
set -l expected_pem (build_multiline '-----BEGIN RSA PRIVATE KEY-----' 'MIIEpAIBAAKCAQEA0Z6h' 'line2' 'line3' '-----END RSA PRIVATE KEY-----' | string collect)
@test "PEM_KEY multi-line" "$PEM_KEY" = "$expected_pem"

# Test basic multi-line with triple single quotes
set -l expected_ssh (build_multiline '-----BEGIN OPENSSH PRIVATE KEY-----' 'b3BlbnNzaC1rZXk' 'another line' 'last line' '-----END OPENSSH PRIVATE KEY-----' | string collect)
@test "SSH_KEY multi-line" "$SSH_KEY" = "$expected_ssh"

# Test single-line triple double quotes
@test "SINGLE_TRIPLE_DOUBLE" "$SINGLE_TRIPLE_DOUBLE" = "single line value"

# Test single-line triple single quotes
@test "SINGLE_TRIPLE_SINGLE" "$SINGLE_TRIPLE_SINGLE" = "single line value"

# Test multi-line with inline comment (should be part of value)
set -l expected_comment (build_multiline 'line1' 'line2 # this is not a comment' 'line3' | string collect)
@test "WITH_COMMENT" "$WITH_COMMENT" = "$expected_comment"

# Test multi-line with hashtags
set -l expected_hashtag (build_multiline '#header' 'content' '#footer' | string collect)
@test "WITH_HASHTAG" "$WITH_HASHTAG" = "$expected_hashtag"

# Test multi-line with single quotes inside triple double quotes
set -l expected_quotes_double (build_multiline "line with 'single quotes'" "another 'quoted' line" | string collect)
@test "QUOTES_INSIDE_DOUBLE" "$QUOTES_INSIDE_DOUBLE" = "$expected_quotes_double"

# Test multi-line with double quotes inside triple single quotes
set -l expected_quotes_single (build_multiline 'line with "double quotes"' 'another "quoted" line' | string collect)
@test "QUOTES_INSIDE_SINGLE" "$QUOTES_INSIDE_SINGLE" = "$expected_quotes_single"

# Test empty multi-line values
@test "EMPTY_MULTILINE_DOUBLE" "$EMPTY_MULTILINE_DOUBLE" = ""
@test "EMPTY_MULTILINE_SINGLE" "$EMPTY_MULTILINE_SINGLE" = ""

# Test regular single-line variable mixed in
@test "REGULAR_VAR" "$REGULAR_VAR" = "regular_value"

# Test multi-line with leading/trailing content on delimiter lines
set -l expected_with_content (build_multiline 'start content' 'middle' 'end content' | string collect)
@test "WITH_CONTENT" "$WITH_CONTENT" = "$expected_with_content"

# Test multi-line with empty lines inside
# For empty lines, we need to handle them specially
set -l expected_empty_lines (printf '%s\n\n%s' 'line1' 'line3' | string collect)
@test "WITH_EMPTY_LINES" "$WITH_EMPTY_LINES" = "$expected_empty_lines"
