{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Handler.Path where

import Yesod
import Yesod.Static
import Data.Text (Text, pack, unpack)
import qualified System.FilePath.Posix as Posix
import System.Posix.Files
import System.Directory
import qualified Settings as Settings

import Foundation

pathJoin :: [Text] -> FilePath
pathJoin texts = Posix.joinPath $ map unpack texts

realPath :: [Text] -> FilePath
realPath path = Posix.joinPath ["media", pathJoin path]

removeDot :: [FilePath] -> IO [FilePath]
removeDot files = return $ filter (\x -> x /= ".") files

removeDotDot :: Bool -> [FilePath] -> IO [FilePath]
removeDotDot False files = return $ files
removeDotDot True files = return $ filter (\x -> x /= "..") files

getPathR :: [Text] -> Handler Html
getPathR path = do
    file <- lift $ getFileStatus $ realPath path
    if isDirectory file then
        defaultLayout $ do
            content <- lift $ (getDirectoryContents $ realPath path) >>= removeDot >>= removeDotDot ((length path) == 0)
            $(whamletFile "templates/path.html")
    else defaultLayout $(whamletFile "templates/file.html")
