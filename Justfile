set shell := ["fish", "-c"]

# List available recipes
default:
    @just --list --justfile {{justfile()}}

# Run tests
test:
    fishtape tests/*.fish
