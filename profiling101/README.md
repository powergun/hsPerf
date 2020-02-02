# Profiling Basis

## How to Correctly Pass Profiling Parameters to Stack

stack run, stack build, stack test etc. all trigger (re)compilation.
this can cause redundant recompilation or accidental override (of
the previous binary)

source: <https://stackoverflow.com/questions/57924638/stack-run-with-profiling-in-haskell>

### Profiling Time Usage

see also: First Principles P/1120, but note that this book uses cabel;
stack disallows passing individual RTS arguments

```shell
cd profiling101
stack --profile run --rts-options -p
# or stack --profile run <name of app> --rts-options -p
cat profiling101-exe.prof
```

make sure `*.prof` is added to `.gitignore` file.

### Profiling Memory (Heap) Usage

see also: First Principles P/1123 (for reference only, do not copy)

source: <https://tech.fpcomplete.com/haskell/tutorial/profiling>

to display memory usage in shell:

```shell
cd app/memory
stack exec -- ghc Main.hs -rtsopts -fforce-recomp && ./Main +RTS -s
```

to generate the memory graph:

```shell
cd app/memory
stack exec -- ghc Main.hs -rtsopts -fforce-recomp -prof
./Main +RTS -p -hc
stack exec -- hp2ps -e8in -c Main.hp
open Main.ps
```
