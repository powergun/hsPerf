module Main (main) where

import           Control.Parallel

fib :: Int -> Int
fib n
  | n <= 1 = 1
  | otherwise = let a = fib (n - 1)
                    b = fib (n - 2)
                in a + b

main = do
  print $ let x = fib 37
              y = fib 38
              z = fib 39
              w = fib 40
          in x `par` y `par` z `par` w `pseq` (x, y, z, w)
