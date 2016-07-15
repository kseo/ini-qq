{-# LANGUAGE QuasiQuotes, StandaloneDeriving #-}

import Data.Data
import Data.Ini
import Data.Ini.QQ
import qualified Data.Text as T
import System.Exit
import Text.RawString.QQ
import Test.HUnit

deriving instance Eq Ini

testIni :: Ini
testIni = [ini|
# Some comment.
[SERVER]
port=6667
hostname=localhost
; another comment here
[AUTH]
user: hello
pass: world
salt:|]

expectedIni :: Ini
expectedIni =
  case parsed of
    Left err -> error $ "Error in parsing ini: " ++ show err
    Right val -> val
  where parsed = parseIni (T.pack [r|
# Some comment.
[SERVER]
port=6667
hostname=localhost
; another comment here
[AUTH]
user: hello
pass: world
salt:|])

main :: IO ()
main = defaultMain $ test [
  "Quasiquote for ini" ~: (expectedIni ~=? testIni)
  ]

defaultMain :: Test -> IO ()
defaultMain t = do
  cnts <- runTestTT t
  case failures cnts + errors cnts of
    0 -> exitWith $ ExitSuccess
    n -> exitWith $ ExitFailure n
