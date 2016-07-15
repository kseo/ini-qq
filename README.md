ini-qq [![Build Status](https://travis-ci.org/kseo/ini-qq.svg?branch=master)](https://travis-ci.org/kseo/ini-qq)
======

Quasiquote for INI.

## Usage

```haskell
{-# LANGUAGE QuasiQuotes #-}

import Data.Ini
import Data.Ini.QQ

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
# Some comment.
[SERVER]
port=6667
hostname=localhost
[AUTH]
user=hello
pass=world
# Salt can be an empty string.
salt=|]
```
