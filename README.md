# Write Performant Code in Haskell

## Build Haskell Program With Profiling Instrumentation

source: <https://stackoverflow.com/questions/57924638/stack-run-with-profiling-in-haskell>

```shell
cd profiling101
stack --profile run --rts-options -p
# or stack --profile run <name of app> --rts-options -p
cat profiling101-exe.prof
```

make sure `*.prof` is added to `.gitignore` file.

## Benchmark, Criterion

see `benchmarkss`

an end-to-end set up of criterion with purely stack package.yaml
(no touching of cabel file)

## Streaming Performance Comparison (v.s. Rust, C, C++)

source: <https://www.fpcomplete.com/blog/2017/07/iterators-streams-rust-haskell>

## Benchmarks to compare Haskell streaming library performance

source: <https://github.com/composewell/streaming-benchmarks>
