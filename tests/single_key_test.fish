source functions/loadenv.fish

loadenv tests/single_key.env

@test LOREM $LOREM = IPSUM
