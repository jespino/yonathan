{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

import Yesod
import Data.Text
import qualified System.FilePath.Posix as Posix
import System.Posix.Files
import System.Directory

data Yonathan = Yonathan

mkYesod "Yonathan" $(parseRoutesFile "config/routes")

instance Yesod Yonathan

pathJoin :: [Text] -> FilePath
pathJoin texts = Posix.joinPath $ Prelude.map unpack texts

realPath :: [Text] -> FilePath
realPath path = Posix.joinPath ["media", pathJoin path]

getHomeR :: Handler Html
getHomeR = defaultLayout $(whamletFile "templates/home.html")

getPathR :: [Text] -> Handler Html
getPathR path = do
    file <- lift $ getFileStatus $ realPath path
    case isDirectory file of
        True -> defaultLayout $ do
            content <- lift $ getDirectoryContents $ realPath path
            $(whamletFile "templates/path.html")
        False -> defaultLayout $ do
            $(whamletFile "templates/file.html")

main :: IO()
main =
    warp 3000 Yonathan
