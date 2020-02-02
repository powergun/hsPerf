module Main (main) where

import           Control.Monad (replicateM_)
import           Data.Bool     (bool)
import           System.IO     (IOMode (..), hPutStr, withFile)

blah :: [Integer]
blah = [1..1000]

main :: IO ()
main = do
  let report x = withFile "/dev/null" WriteMode (\h -> hPutStr h $ show x)
      compute = length . tail
      filters = (fmap (+ 1)) . (fmap (* 2))
  replicateM_ 10000 (report . compute . filters $ blah)
  putStrLn ""
