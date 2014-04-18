{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

import Yesod
import Yesod.Static
import Data.Text (Text, pack, unpack)
import qualified System.FilePath.Posix as Posix
import System.Posix.Files
import System.Directory
import Foundation
import Handler.Home
import Handler.Path

mkYesodDispatch "Yonathan" []

main :: IO()
main = do
    static <- static "static"
    warp 3000 $ Yonathan static
