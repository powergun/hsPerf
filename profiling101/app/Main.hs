module Main where

sma :: [Double] -> [Double]
sma (x0:x1:xs) = (x0 + x1) / 2 : sma (x1:xs)
sma xs = xs

main = let a = {-# SCC "list-" #-} [1..1000]
           b = {-# SCC "sma-" #-} sma a
           c = {-# SCC "sum-" #-} sum b
       in print b
