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
