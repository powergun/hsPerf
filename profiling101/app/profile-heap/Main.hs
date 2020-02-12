module Main (main) where

-- without the annotation, this cost center shows up in the plot
-- as "main3" (3 being the lineno)
fib_mem :: Int -> Integer
fib_mem = {-# SCC "fib_mem-" #-} (fmap fib [0..] !!)
  where
    fib 0 = 1
    fib 1 = 1
    fib n = fib_mem (n - 1) + fib_mem (n - 2)

main = print $ fib_mem 10000
