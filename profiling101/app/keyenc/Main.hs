{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import           System.Process     (rawSystem)


import           Data.Bits          (xor)
import qualified Data.ByteString    as B
import           System.Environment (getArgs)

encrypt :: B.ByteString -> B.ByteString -> B.ByteString
encrypt key plain = go key plain
  where
    keyLength = B.length key
    go k0 b
      | B.null b = B.empty
      | otherwise =
          let (b0, bn) = B.splitAt keyLength b
              r0 = B.pack $ B.zipWith xor k0 b0
          in r0 `B.append` go b0 bn

decrypt :: B.ByteString -> B.ByteString -> B.ByteString
decrypt key plain = go key plain
  where
    keyLength = B.length key
    go k0 b
      | B.null b = B.empty
      | otherwise =
        let (b0, bn) = B.splitAt keyLength b
            r0 = B.pack $ B.zipWith xor k0 b0
        in r0 `B.append` go r0 bn

prepTestData :: IO ()
prepTestData = do
  _ <- rawSystem "dd" ["if=/dev/urandom", "of=/var/tmp/key.bin", "bs=1024x1024", "count=1"]
  _ <- rawSystem "dd" ["if=/dev/urandom", "of=/var/tmp/plain.bin", "bs=1024x1024", "count=24"]
  return ()

main :: IO ()
main = do
  prepTestData
  key <- B.readFile "/var/tmp/key.bin"
  input <- B.readFile "/var/tmp/plain.bin"
  let blob = encrypt key input
      input' = decrypt key blob
  B.writeFile "/var/tmp/out.bin" input'
