module Strategies.ParTraversable (demo) where

import           Control.Parallel.Strategies
import           System.Environment          (getArgs)

minmax :: [Int] -> (Int, Int)
minmax xs = (minimum xs, maximum xs)

computeSequential =
  let matrix = [ [1..1000001], [2..2000002], [3..2000003]
               , [4..2000004], [5..2000005], [6..2000006]
               , [7..2000007] ]
  in map minmax matrix

computeParallel =
  let matrix = [ [1..1000001], [2..2000002], [3..2000003]
               , [4..2000004], [5..2000005], [6..2000006]
               , [7..2000007] ]
      compute = map minmax matrix
  in (compute `using` parTraversable rdeepseq)

demo :: IO ()
demo = do
  args <- getArgs
  case args of
    []    -> print computeSequential
    ["1"] -> print computeParallel
    _     -> error "usage: no arg or 1"
