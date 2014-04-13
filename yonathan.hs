{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

import Yesod
import Data.Text
import qualified System.FilePath.Posix as Posix

data Yonathan = Yonathan

mkYesod "Yonathan" $(parseRoutesFile "config/routes")

instance Yesod Yonathan

pathJoin :: [Text] -> String
pathJoin texts = Posix.joinPath $ Prelude.map unpack texts

getHomeR :: Handler Html
getHomeR = defaultLayout $(whamletFile "templates/home.html")

getPathR :: [Text] -> Handler Html
getPathR path = defaultLayout $(whamletFile "templates/path.html")

main :: IO()
main =
    warp 3000 Yonathan
