module Strategies.ParTraversable (demo) where

import           Control.Parallel.Strategies
import           System.Environment          (getArgs)

minmax :: [Int] -> (Int, Int)
minmax xs = (minimum xs, maximum xs)

demo :: IO ()
demo = do
  args <- getArgs
  case args of
    [] -> print "default"
    _  -> print "advanced"
