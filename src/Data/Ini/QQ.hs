{-# LANGUAGE TemplateHaskell #-}

-- | Quasiquoter for ini configuration
module Data.Ini.QQ
  ( ini
  ) where

import Data.Data
import Data.Ini
import qualified Data.Text as T
import Language.Haskell.TH
import Language.Haskell.TH.Quote
import Language.Haskell.TH.Syntax

-- See http://stackoverflow.com/questions/38143464/cant-find-inerface-file-declaration-for-variable
liftText :: T.Text -> Q Exp
liftText txt = AppE (VarE 'T.pack) <$> lift (T.unpack txt)

liftDataWithText :: Data a => a -> ExpQ
liftDataWithText = dataToExpQ (\a -> liftText <$> cast a)

ini :: QuasiQuoter
ini = QuasiQuoter {
  quoteExp = iniExp,
  quotePat = \s -> error "No quotePat defined for ini",
  quoteType = \s -> error "No quoteType defined for ini",
  quoteDec = \s -> error "No quoteDec defined for ini"
}

iniExp :: String -> ExpQ
iniExp txt =
  case parseIni (T.pack txt) of
    Left err -> error ("Error in iniExp: " ++ show err)
    Right val -> toExpQ val

-- Requires GHC 8 due to https://phabricator.haskell.org/D1313
toExpQ :: Ini -> ExpQ
toExpQ (Ini m) = do
  e <- liftDataWithText m
  return $ AppE (ConE $ mkName "Data.Ini.Ini") e

