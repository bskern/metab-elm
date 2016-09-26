module Style.MyCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (body)
import Css.Namespace exposing (namespace)


type CssClasses
    = App
    | Content
    | Title
    | Reddit
    | HN


css : Stylesheet
css =
    (stylesheet << namespace "metab")
        [ body
            [ margin zero
            , padding zero
            , fontSize (px 14)
            , fontFamilies [ "Helvetica Neue", "Helvetica", "Arial", "sans-serif" ]
            ]
        , (.) App
            [ textAlign center ]
        , (.) Content
            [ backgroundColor (hex "f6f6ef")
            , textAlign left
            , paddingLeft (px 5)
            ]
        , (.) Title
            [ fontFamilies [ "Verdana, Geneva, sans-serif" ]
            , fontSize (pt 10)
            , color (hex "828282")
            ]
        , (.) Reddit
            [ backgroundColor (hex "cee3f8")
            , borderBottomColor (hex "5f99cf")
            , borderBottomWidth (px 1)
            , borderBottomStyle solid
            , fontWeight bold
            , fontFamilies [ "Verdana, Geneva, sans-serif" ]
            , fontSize (pt 10)
            ]
        , (.) HN
            [ backgroundColor (hex "ff6600")
            , fontWeight bold
            , fontSize (pt 10)
            , fontFamilies [ "Verdana, Geneva, sans-serif" ]
            ]
        ]
