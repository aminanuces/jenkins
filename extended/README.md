# Extended parser (experimental)

This folder contains an extended, more permissive parser that accepts common Jenkins/Groovy idioms which are outside the strict BNF used by the core parser.

Purpose

- Use this workspace to experiment with additional language features (agent label forms, named-arg calls, `post`/`environment` blocks, `for` loops, `def`, `!=`, `<`, `++`, etc.) without changing the strict core grammar.

Files

- `extended.y` — extended Bison grammar for the permissive parser.
- `extended.l` — extended Flex lexer (includes `extended.tab.h`).
- `Makefile` — build rules and `test` target for the extended parser.
- `tests/` — example complex Jenkinsfile inputs used to validate the extended grammar (the main test runner looks in `../tests`).

Build & run

Requires `bison`, `flex`, and `gcc` on your PATH.

Build and run all tests:

```sh
make -C extended test
```

Build only:

```sh
make -C extended
```

Run a single file (after building):

```sh
cd extended
./extended_parser ../tests/experimental/complex_pass1.jenkinsfile
```

Inspecting bison conflicts

The extended grammar is intentionally permissive and may produce bison conflict warnings (shift/reduce, reduce/reduce). To get a detailed report:

```sh
cd extended
bison -v -d extended.y
# this writes `extended.output` with detailed state/conflict information
less extended.output
```

Notes

- The extended parser is for experimentation and prototyping; it is more permissive but therefore may be ambiguous in places.
- If you want the extended parser to be more deterministic, run `bison -v` and I can help analyze the most frequent conflict states and propose grammar refactors.
