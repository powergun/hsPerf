import           DataPara.Repa

import           System.Environment             ( getArgs )

main = do
  args <- getArgs
  case args of
    []    -> print demoSequentialD1
    ["1"] -> print demoMapD1
    _     -> error "usage: no arg or 1"
