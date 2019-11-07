
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE NamedFieldPuns #-}

module PoC where

import           UIO
import           Haze

default (Text, Int, Double)


-- | a type defining a plottable data interface
data DataPack = DataPack {
    x :: ColumnData
    , ySin :: ColumnData
    , yCos :: ColumnData
}

-- | data crunching algorithm, normally crafted in a module file
-- within the project underhood, not in web UI ad-hoc
--
-- normally leveraging plenty 3rd party packages
prepareData :: MonadIO m => m DataPack
prepareData = do
    -- data parameter(s)
    let n = 500
    -- crunch for data
    let x = generateSeries n
            $ \i -> 8.0 * pi * (fromIntegral i) / (fromIntegral $ n - 1)
        ySin = mapSeries sin x
        yCos = mapSeries cos x
    return $ DataPack { x, ySin, yCos }


-- | a plot specification, normally crafted in a module file within
-- the project underhood, not in web UI ad-hoc
--
-- many packages can be composed for this purpose, as long as they
-- all speak 'Haze.DSL'
plotSinCos :: DataPack -> Plot ()
plotSinCos DataPack { x, ySin, yCos } = do
    -- define axes to be synchronized
    sharedX <- defineAxis
    sharedY <- defineAxis
    -- plot in separate windows
    void $ openWindow "Win1" $ do
        -- each window must have its own data source
        ds <- putDataSource [("x", x), ("sin", ySin), ("cos", yCos)]
        -- each window can have one or more figures
        f1 <-
            figure
                    [ ("title"           , bokehExpr "SIN Figure")
                    , ("toolbar_location", bokehExpr "left")
                    , ("sizing_mode"     , bokehExpr "stretch_both")
                    ]
                $ do
                      addGlyph
                          "line"
                          ds
                          [ ("x"     , dataField "x")
                          , ("y"     , dataField "sin")
                          , ("color" , dataValue "#1122cc")
                          , ("alpha" , dataValue 0.7)
                          , ("legend", dataValue "SIN Curve")
                          ]
                      linkFigAxis "x_range" sharedX
                      linkFigAxis "y_range" sharedY

        f2 <-
            figure
                    [ ("title"           , bokehExpr "COS Figure")
                    , ("toolbar_location", bokehExpr "right")
                    , ("sizing_mode"     , bokehExpr "stretch_both")
                    ]
                $ do
                      addGlyph
                          "line"
                          ds
                          [ ("x"     , dataField "x")
                          , ("y"     , dataField "cos")
                          , ("color" , dataValue "#11cc22")
                          , ("alpha" , dataValue 0.7)
                          , ("legend", dataValue "COS Curve")
                          ]
                      setGlyphAttrs
                          "Legend"
                          [ (["location"]             , bokehExpr "top_left")
                          , (["click_policy"]         , bokehExpr "hide")
                          , (["background_fill_alpha"], bokehExpr 0.6)
                          ]
                      linkFigAxis "x_range" sharedX
                      linkFigAxis "y_range" sharedY

        showPlot
            "gridplot"
            [[f1], [f2]]
            [ ("merge_tools", bokehExpr False)
            , ("sizing_mode", bokehExpr "stretch_both")
            ]
            jsNull -- null targets the plot to html body element
    void $ openWindow "Win2" $ do
        -- each window must have its own data source
        ds <- putDataSource [("x", x), ("sin", ySin), ("cos", yCos)]
        -- each window can have one or more figures
        f1 <-
            figure
                    [ ("title"           , bokehExpr "SIN Figure")
                    , ("toolbar_location", bokehExpr "left")
                    , ("sizing_mode"     , bokehExpr "stretch_both")
                    ]
                $ do
                      addGlyph
                          "line"
                          ds
                          [ ("x"     , dataField "x")
                          , ("y"     , dataField "sin")
                          , ("color" , dataValue "#1122cc")
                          , ("alpha" , dataValue 0.7)
                          , ("legend", dataValue "SIN Curve")
                          ]
                      linkFigAxis "x_range" sharedX
                      linkFigAxis "y_range" sharedY

        f2 <-
            figure
                    [ ("title"           , bokehExpr "COS Figure")
                    , ("toolbar_location", bokehExpr "right")
                    , ("sizing_mode"     , bokehExpr "stretch_both")
                    ]
                $ do
                      addGlyph
                          "line"
                          ds
                          [ ("x"     , dataField "x")
                          , ("y"     , dataField "cos")
                          , ("color" , dataValue "#11cc22")
                          , ("alpha" , dataValue 0.7)
                          , ("legend", dataValue "COS Curve")
                          ]
                      setGlyphAttrs
                          "Legend"
                          [ (["location"]             , bokehExpr "top_left")
                          , (["click_policy"]         , bokehExpr "hide")
                          , (["background_fill_alpha"], bokehExpr 0.6)
                          ]
                      linkFigAxis "x_range" sharedX
                      linkFigAxis "y_range" sharedY

        showPlot
            "gridplot"
            [[f1, f2]]
            [ ("merge_tools", bokehExpr False)
            , ("sizing_mode", bokehExpr "stretch_both")
            ]
            jsNull -- null targets the plot to html body element
