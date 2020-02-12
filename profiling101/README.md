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

I can also profile an executable target like so (inspired by High Perf
haskell P/104)

```shell
stack run <executable-target> -- +RTS -s
```

(this requires the build args to include `-rtsopts`)

make sure `*.prof` is added to `.gitignore` file.

### Profiling Memory (Heap) Usage

inspired by: High Perf Haskell P/48, but note that, like the old method
below it still uses GHC directly; I should use stack's `package.yaml`

a test target should already have the `-rtsopts` argument

```yaml
tests:
  memoizations-test:
    main: Spec.hs
    source-dirs: test
    ghc-options:
      - -threaded
      - -rtsopts
      - -with-rtsopts=-N
    dependencies:
      - memoizations
      - hspec
```

run `stack test`, make sure the tests pass; then find the test target
executable such as this `.stack-work/dist/x86_64-osx/Cabal-2.4.0.1/build/memoizations-test/memoizations-test`

run `<binary> +RTS -s`, which display the heap usage.

### (old) Profiling Memory (Heap) Usage

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

## How to enable time + mem profiling in GHCi

mentioned in: High Perf Haskell P/50

enable flag `:set +s`, you can get time and space statistics of
every evaluation

> Keep in mind though that no optimizations can be enabled for interpreted
> code, so compiled code can have very different performance characteristics.
> To test with optimizations, you should compile the module with optimizations
> and then import it into GHCi.

```haskell
hs> :set +s
hs> a = 1
(0.01 secs, 0 bytes)
hs> a = foldr (+) 0 [1..1000]
(0.05 secs, 0 bytes)
hs> a = foldr (+) 0 [1..1000]
hs> a = foldl (+) 0 [1..1000]
(0.01 secs, 0 bytes)
hs> a = foldr (++) "" (fmap show [1..1000])
(0.02 secs, 0 bytes)
hs> a
.......
(0.05 secs, 2,808,488 bytes)
```

## Cost Center, High Perf Haskell P/105

see `app/Main.hs`; run the target like so (NOTE: **this may trigger
a large scale recompilation of all the dependency!!!**)

```shell
stack clean
stack run --executable-profiling simple -- +RTS -s -p -RTS
cat simple.prof
```

also mentioned on P/109

> Stack conveniently re-builds all necessary packages that didn't
> previously have profiling enabled

### Debugging crashes with profiler

P/110

> The Runtime System features the `-xc` flag, which shows the current
> cost centre stack when an exception is raised.
> GHC 8 is the earliest release where actual callstack information is available

```shell
stack clean
stack run crash --executable-profiling -- +RTS -p -xc
```
