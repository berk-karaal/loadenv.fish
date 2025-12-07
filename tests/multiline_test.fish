source functions/loadenv.fish

loadenv tests/multiline.env

# Test basic multi-line with triple double quotes
set -l expected_pem (printf '-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEA0Z6h\nline2\nline3\n-----END RSA PRIVATE KEY-----' | string collect --no-trim-newlines)
@test "PEM_KEY multi-line" "$PEM_KEY" = "$expected_pem"

# Test basic multi-line with triple single quotes
set -l expected_ssh (printf '-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaC1rZXk\nanother line\nlast line\n-----END OPENSSH PRIVATE KEY-----' | string collect --no-trim-newlines)
@test "SSH_KEY multi-line" "$SSH_KEY" = "$expected_ssh"

# Test single-line triple double quotes
@test "SINGLE_TRIPLE_DOUBLE" "$SINGLE_TRIPLE_DOUBLE" = "single line value"

# Test single-line triple single quotes
@test "SINGLE_TRIPLE_SINGLE" "$SINGLE_TRIPLE_SINGLE" = "single line value"

# Test multi-line with inline comment (should be part of value)
set -l expected_comment (printf 'line1\nline2 # this is not a comment\nline3' | string collect --no-trim-newlines)
@test "WITH_COMMENT" "$WITH_COMMENT" = "$expected_comment"

# Test multi-line with hashtags
set -l expected_hashtag (printf '#header\ncontent\n#footer' | string collect --no-trim-newlines)
@test "WITH_HASHTAG" "$WITH_HASHTAG" = "$expected_hashtag"

# Test multi-line with single quotes inside triple double quotes
set -l expected_quotes_double (printf "line with 'single quotes'\nanother 'quoted' line" | string collect --no-trim-newlines)
@test "QUOTES_INSIDE_DOUBLE" "$QUOTES_INSIDE_DOUBLE" = "$expected_quotes_double"

# Test multi-line with double quotes inside triple single quotes
set -l expected_quotes_single (printf 'line with "double quotes"\nanother "quoted" line' | string collect --no-trim-newlines)
@test "QUOTES_INSIDE_SINGLE" "$QUOTES_INSIDE_SINGLE" = "$expected_quotes_single"

# Test empty multi-line values
@test "EMPTY_MULTILINE_DOUBLE" "$EMPTY_MULTILINE_DOUBLE" = ""
@test "EMPTY_MULTILINE_SINGLE" "$EMPTY_MULTILINE_SINGLE" = ""

# Test regular single-line variable mixed in
@test "REGULAR_VAR" "$REGULAR_VAR" = "regular_value"

# Test multi-line with leading/trailing content on delimiter lines
set -l expected_with_content (printf 'start content\nmiddle\nend content' | string collect --no-trim-newlines)
@test "WITH_CONTENT" "$WITH_CONTENT" = "$expected_with_content"

# Test multi-line with empty lines inside
set -l expected_empty_lines (printf 'line1\n\nline3' | string collect --no-trim-newlines)
@test "WITH_EMPTY_LINES" "$WITH_EMPTY_LINES" = "$expected_empty_lines"

# Test multi-line with only empty lines
set -l expected_only_empty (printf '\n\n\n' | string collect --no-trim-newlines)
@test "MULTIPLE_EMPTY_LINES" "$MULTIPLE_EMPTY_LINES" = "$expected_only_empty"

# Test multi-line with empty start and end lines
set -l expected_empty_start_end (printf '\n\nline in the middle\n\n\n' | string collect --no-trim-newlines)
@test "MULTIPLINE_EMPTY_START_END" "$MULTIPLINE_EMPTY_START_END" = "$expected_empty_start_end"

# Test multi-line with spaces and tabs
set -l expected_spaces_tabs (printf '   line with spaces\n    line with tabs\nend line   ' | string collect --no-trim-newlines)
@test "WITH_SPACES_TABS" "$WITH_SPACES_TABS" = "$expected_spaces_tabs"
