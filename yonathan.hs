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
import Text.Hamlet
import Yesod.Static

staticFiles "static"

data Yonathan = Yonathan
    { getStatic :: Static }

mkYesod "Yonathan" $(parseRoutesFile "config/routes")

instance Yesod Yonathan where
    defaultLayout contents = do
        PageContent title headTags bodyTags <- widgetToPageContent contents
        mmsg <- getMessage
        giveUrlRenderer $(hamletFile "templates/layout.html")

pathJoin :: [Text] -> FilePath
pathJoin texts = Posix.joinPath $ Prelude.map unpack texts

realPath :: [Text] -> FilePath
realPath path = Posix.joinPath ["media", pathJoin path]

getHomeR :: Handler Html
getHomeR = defaultLayout $(whamletFile "templates/home.html")

getPathR :: [Text] -> Handler Html
getPathR path = do
    file <- lift $ getFileStatus $ realPath path
    if isDirectory file then
        defaultLayout $ do
            content <- lift $ getDirectoryContents $ realPath path
            $(whamletFile "templates/path.html")
    else defaultLayout $ do
            $(whamletFile "templates/file.html")

main :: IO()
main = do
    static <- static "static"
    warp 3000 $ Yonathan static
