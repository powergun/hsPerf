# Profiling with criterion

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

## how to run profiler

`stack bench`
