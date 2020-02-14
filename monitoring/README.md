# Performance Monitoring

## Discover Monitoring, High Perf Haskell P/129

### Use haskell runtime system to continuously monitor heap

P/129

> Because very basic heap profiling `(-hT)` is possible without having
> compiled with profiling support, it is possible to produce running
> heap profiles with a very small overhead.

```shell
# package namespace is no need here...
stack run monitoring:runtime -- +RTS -hT

stack exec -- hp2ps -c -e8in runtime.hp
open runtime.ps
```

> Increasing the sample interval `-i` to something relatively big,
> such as a couple of seconds, it is very feasible to extract heap
> profiles from long-running programs even in production environments.

### Monitor garbage collector usage

P/129

> `-S` Runtime System option. This option prints garbage collector
> statistics every time a cleanup takes place, in realtime.

```shell
stack run runtime -- +RTS -S -G2
```

### Use ekg monitor server

see: `app/ekg/Main.hs`; run with `stack run ekg -- +RTS -T`

> When compiling, we should enable the `-T` Runtime System option to
> enable ekg to collect GC statistics. It is also a good idea to enable
> at least `-O`. On multithreaded systems, we may likely also want a
> threaded runtime, so that the program doesn't need to share the same
> system core with the monitoring subsystem.

see `app/ekg-counter/Main.hs` for monitor server that provides its
custom counter (how to increment it in the production code path)
