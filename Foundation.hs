{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Foundation where

import Yesod
import Yesod.Static
import Text.Hamlet
import qualified Settings as Settings

staticFiles "static"

data Yonathan = Yonathan
    { getStatic :: Static }

mkYesodData "Yonathan" $(parseRoutesFile "config/routes")

instance Yesod Yonathan where
    defaultLayout contents = do
        PageContent title headTags bodyTags <- widgetToPageContent contents
        mmsg <- getMessage
        giveUrlRenderer $(hamletFile "templates/layout.html")
