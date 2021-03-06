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

NOTE: **refer to Profile Heap section below for the suggested method**

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

## Profile Heap (snapshot), High Perf Haskell P/105

see: `app/memory/Main.hs`; this requires `--executable-profiling` and
runtime system flags `+RTS -hc`; the plotting part is done by `hp2ps`

Note that I can either use the automatic cost center (named after
FilenameLineno) or use an annoation

```shell
./clean
stack run profile-heap --executable-profiling -- +RTS -hc
# also experiment with -hd (all closure descriptions)

stack exec -- hp2ps -e8in -c profile-heap.hp
open profile-heap.ps
```

## Profile Heap: Taylor Polynomial and Optimization, High Perf Haskell P/113

see: `app/taylor-polynomial` and `app/taylor-polynomial-opt`

P/113

> The `-i0.05` flag sets the interval we want to sample the heap.
> By default, this is 0.1 seconds. We halve it for our program to extract
> enough details.

NOTE: recall Linux Profiling book: the interval should NOT be a multiple
of 10 or 1/10 - it should be slightly off to capture a more accurate
snapshot. (0.03 etc.)

running the un-optimized taylor polynomial (I have to increase the workload -
precision: 1600, step: 0.05)

```shell
./clean
stack run taylor --executable-profiling -- +RTS -hc -i0.007
stack exec -- hp2ps -c -e8in taylor.hp
open taylor.ps
```

NOTE: **GHC (8.6.5) is able to apply the optimization to the un-optimized
taylor polynomial example** therefore the resulting plot looks different
to the one in the book (confirming that both versions look the same in
the plot)

## Objects outside the Heap, High Perf Haskell P/117

see `app/keyenc`; profile with

```shell
./clean
stack run keyenc --executable-profiling -- +RTS -h -i0.003
stack exec -- hp2ps -c -e8in keyenc.hp
open keyenc.ps
```

NOTE: **append is a copy operation**

P/122

> It is a good idea to always check the Runtime System memory
> statistics with `+RTS -s`, as that will always give exact memory
> usage.
