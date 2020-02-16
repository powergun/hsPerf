module DataPara.Repa
  ( demoMapD1
  , demoSequentialD1
  )
where

import           Data.Array.Repa               as Repa

d1 :: [Int]
d1 = [1 .. 40]
d2 :: [Int]
d2 = [1 .. 65536]

x = fromListUnboxed (ix1 40) d1
y = fromListUnboxed (ix2 256 256) d2

fib :: Int -> Int
fib 0 = 1
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)

demoSequentialD1 :: Int
demoSequentialD1 = length . show $ fmap fib d1

demoMapD1 :: Int
demoMapD1 =
  let workload :: Array D DIM1 Int
      workload = Repa.map fib x
      [o]      = computeP workload :: [Array U DIM1 Int]
  in  length . show $ o

