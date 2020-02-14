{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import           Control.Monad
import           System.Remote.Monitoring

main = do
  forkServer "localhost" 8000
  forever $ do
    input <- getLine
    print $ product [1..read input :: Integer]
