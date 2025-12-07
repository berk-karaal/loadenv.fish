# loadenv.fish

[![Tests workflow](https://github.com/berk-karaal/loadenv.fish/actions/workflows/tests.yaml/badge.svg)](https://github.com/berk-karaal/loadenv.fish/actions/workflows/tests.yaml)

`loadenv` is a Fish shell function for managing environment variables from dotenv files.

```
Usage: loadenv [OPTIONS] [FILE]

Export keys and values from a dotenv file.

Options:
  --help, -h      Show this help message
  --print         Print env keys (export preview)
  --printb        Print keys with surrounding brackets
  --unload, -U    Unexport all keys defined in the dotenv file

Arguments:
  FILE            Path to dotenv file (default: .env)
```

Check [`tests/happy.env`](https://github.com/berk-karaal/loadenv.fish/blob/main/tests/happy.env) for a sample dotenv file.

## Installation

Using [Fisher](https://github.com/jorgebucaran/fisher) (Plugin manager for Fish):

```console
$ fisher install berk-karaal/loadenv.fish
```

or manually copy the `functions/loadenv.fish` file to your Fish functions directory (e.g. `~/.config/fish/functions/`).

## Usage

Load `.env` file:

```console
$ loadenv
```

Load custom file:

```console
$ loadenv path/to/dotenv.env
```

Preview variables defined in the dotenv file:

```console
$ loadenv --print
$ # or
$ loadenv --printb
```

Unexport all keys defined in the dotenv file:

```console
$ loadenv --unload
```

### Example dotenv file

```
# Sample dotenv file (.env.example)

# This is a comment
KEY1=value1

QUOTED_KEY="This is a quoted value" # inline comment
SINGLE_QUOTED_KEY='Single quoted value'

# Support for multi-line values
MULTI_LINE_KEY="""This is a multi-line
value that spans several lines.

1
2
3"""
```

```console
$ loadenv .env.example --printb
[KEY1=value1]
[QUOTED_KEY=This is a quoted value]
[SINGLE_QUOTED_KEY=Single quoted value]
[MULTI_LINE_KEY=This is a multi-line
value that spans several lines.

1
2
3]
```
