module Main (main) where

fib :: Int -> Int
fib n
  | n <= 1 = 1
  | otherwise = let a = fib (n - 1)
                    b = fib (n - 2)
                in a + b

main = do
  let x = fib 37
      y = fib 38
      z = fib 39
      w = fib 40
  print (x,y,z,w)
