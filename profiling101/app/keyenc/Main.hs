module Main (main) where

import           System.Process (rawSystem)

main = do
  rawSystem "ls" []
