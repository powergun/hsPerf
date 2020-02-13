module Main where

import           Criterion
import           Criterion.Main (defaultMain)
import           Data.List
import           System.Random

largestRectangle a = a

randomList :: Int -> IO [Int]
randomList n = sequence $ replicate n (randomRIO (1, 10000 :: Int))

main :: IO ()
main = do
  [l1, l2, l3, l4, l5, l6] <- mapM
    randomList [1, 10, 100, 1000, 10000, 100000]
  defaultMain
    [ bgroup "fences tests"
      [ bench "Size 1 Test" $ whnf const l1
      , bench "Size 10 Test" $ whnf const l2
      ]
    ]
