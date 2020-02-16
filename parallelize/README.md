# Parallelize for Performance

## Discover Parallization, High Perf Haskell P/174

> Turns out, one of Haskell's strongest aspects, referential transparency,
> is very valuable for parallelization. Automatically knowing that some distinct expressions won't interact with each other means they are safe to execute
> simultaneously.

parallelization v.s. concurrency P/174

> Note that parallelism is very different from concurrency, which usually
> refers to interacting processes (they aren't necessarily executed in
> parallel).

P175

> In Haskell, parallel execution (of pure values) boils down to
> evaluating thunks into WHNF simultaneously.

### Spark

P/177

see: `app/fib/multi-thread`

> The technique used in the parallel runtime to distribute work
> between processors works via units of work called sparks.

```text
stack run fib-mt -- +RTS -s
...
  SPARKS: 3(3 converted, 0 overflowed, 0 dud, 0 GC'd, 0 fizzled)
...
```

avoid over subscription, see `app/fib/spark`

> But if we limit sparking to larger recursive calls where n > 25,
> we get a finer work distribution

```text
stack run fib-spark -- +RTS -s
...
  SPARKS: 7235(106 converted, 0 overflowed, 0 dud, 98 GC'd, 7031 fizzled)
...
```

### Parallel Abstraction and Strategies, High Perf Haskell P/179

> The principle is to use `using` or `runEval` to evaluate a lazy data
> structure in parallel, using some strategy.
> Essentially we have separated the algorithm (a lazy data structure)
> from the parallel evaluation (a strategy).

see: `app/eval/par-traversable.hs`,

```text
stack run par-trav -- 1 +RTS -s
[(1,1000001),(2,2000002),(3,2000003),(4,2000004),(5,2000005),(6,2000006),(7,2000007)]
...
  SPARKS: 7(6 converted, 0 overflowed, 0 dud, 0 GC'd, 1 fizzled)
...
```

### Use ThreadScope, High Perf haskell P/189

see: `par-trav-ts` target; build with `stack build`; run with
`stack run par-trav-ts -- 1 +RTS -l`, then `threadscope <name>.eventlog`

(**DON'T** forget to enable parallelism in this demo)

threadscope is installed using the prebuilt binary (for Ubuntu 64 trusty);
