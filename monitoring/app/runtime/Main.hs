module Main (main) where

fib_mem :: Int -> Integer
fib_mem = (fmap fib [0..] !!)
  where
    fib 0 = 1
    fib 1 = 1
    fib n = fib_mem (n - 1) + fib_mem (n - 2)

main :: IO ()
main = do
  print $ fib_mem 25000
