{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import           Control.Monad
import           System.Metrics
import qualified System.Metrics.Counter   as Counter
import           System.Remote.Monitoring

main = do
  server <- forkServer "localhost" 8000
  factorials <- createCounter "factorials.count" (serverMetricStore server)
  forever $ do
    input <- getLine
    print $ product [1..read input :: Integer]
    Counter.inc factorials
