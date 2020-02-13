# Benchmarking with criterion

## project setup

### 24 days of haskell

only borrow the import statements and random data payload generator
techniques

NOT using its SUT

<https://mmhaskell.com/testing-2>

(also duplicated here)

<https://mmhaskell.com/blog/2017/6/19/profiling-in-haskell>

### hpack document

<https://github.com/sol/hpack#benchmark-fields>

see `package.yaml` for example

also see how to setup the directory structure

### criterion document

<http://hackage.haskell.org/package/criterion-1.5.6.1/docs/Criterion-Main.html>

explains where `whnf` comes from;

see also: First Principle P/1133 (Basic Libraries Chapter)

## how to run benchmark suite

`stack bench`

## Discover Criterion, High Perf Haskell

### how to generate HTML output

mentioned on High Performance Haskell, P/126

```shell
stack bench --ba '--output o.html'
open o.html
```

(`--ba` is to pass benchmarking arguments to criterion)

### understanding whnf, High Perf Haskell P/127

> The rule of thumb is that, when the result of the benchmarkable
> function depends on the environment (the second argument to `whnf`),
> then the time taken to evaluate the result will resemble the real cost.

### understanding nf

P/127

> `NFData` stands for Normal Form Data, which is a stronger notion
> than `Weak Head Normal Form`. In normal form, the structure is fully
> evaluated, meaning there are no unevaluated thunks, even deep down
> the structure.

NF is not always the "real world situation"

P/127

> With normal form, we can benchmark the total evaluation of big algebraic
> data structures such as trees. However, it should be kept in mind that,
> in real scenarios, it is rarely the case that a big lazy structure needs
> to be evaluated fully.

What is the criterion iteration about?

> Criterion works so that it executes a benchmark for a few different numbers
> of iterations. For a wellbehaving, predictable benchmarkable function or
> action, execution times increase linearly when the number of iterations
> increases. Criterion uses linear regression to measure this
