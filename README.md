# loadenv.fish

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

