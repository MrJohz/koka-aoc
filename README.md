# Advent of Code — Koka

Advent of Code 2023, but written in Koka in order to learn the language.

- Koka: https://github.com/koka-lang/koka
- Advent of Code: https://adventofcode.com/2023

## Running the Code

To run a given day, use the Koka compiler (see the Koka documentation for installation instructions):

```bash
$ koka -e day1.kk # compiles and runs debug version
$ koka -eO3 day1.kk # compiles and runs optimised version

```

## Thoughts for future Jonathans

- I'd like to know what the performance of these solutions looks like in comparison to other languages e.g. Rust — is there a way of benchmarking these things?
- I think it's possible to write tests, but there's no documentation for this.
