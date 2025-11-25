# Jenkins-like DSL parser (Bison + Flex)

This repository contains a small demonstrator parser for a simplified Jenkins pipeline DSL that follows the BNF provided in the project report. The parser uses Bison (Yacc) and Flex (Lex) to recognize pipeline structure and simple script blocks.

Contents

- `jenkins.y` — core Bison grammar implementing the strict BNF and emitting simple parse-time events.
- `jenkins.l` — core Flex lexer tokenizing keywords, identifiers and quoted strings.
- `Makefile` — top-level build and `test` targets for the core parser.
- `tests/` — example `.jenkinsfile` files (valid and invalid) used for readability/writability evaluation.
- `extended/` — a separate workspace containing an extended/experimental grammar, lexer and Makefile for parsing more realistic Jenkins/Groovy idioms. See the `extended/` folder for instructions.

## Build

Requires `bison` and `flex` on your system.

```sh
make
```

## Run

Run the parser on a single file:

```sh
./jenkins_parser tests/valid1.jenkins
```

Run all included tests (core parser):

```sh
make test
```

Extended parser

An extended, more permissive parser is provided in `extended/`. It contains an extended grammar and its own `Makefile` so you can iterate independently from the strict core parser.

# Jenkins-like DSL parser (Bison + Flex)

This repository contains a small demonstrator parser for a simplified Jenkins pipeline DSL that follows a strict BNF. The core parser is implemented with Bison (Yacc) and Flex (Lex) and is intended as a recognizer for readability/writability evaluation.

Contents

- `jenkins.y` — core Bison grammar implementing the strict BNF and emitting simple parse-time events.
- `jenkins.l` — core Flex lexer tokenizing keywords, identifiers and quoted strings.
- `Makefile` — top-level build and `test` targets for the core parser.
- `tests/` — example `.jenkinsfile` files (valid and invalid) used for readability/writability evaluation.

## Build

Requires `bison` and `flex` on your system.

```sh
make
```

## Run

Run the core parser on a single file:

```sh
./jenkins_parser path/to/file.jenkinsfile
```

Run all core tests:

```sh
make test
```

Clean generated artifacts:

```sh
make clean
```

## Notes

- The core parser prints informational messages when it sees `agent`, `stage`, `step`, and script statements.
- The core grammar follows a strict BNF and is intentionally conservative; it prints parse events rather than building a structured AST.
- Script support in the core parser is minimal (assignments, `if`/`else`, simple expressions) to keep the grammar deterministic and suitable for evaluation.
# jenkins
