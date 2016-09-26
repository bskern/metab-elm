module Components.Header exposing (..)

import Html exposing (..)
import Html.Attributes
import Style.MyCss as MyCss
import Html.CssHelpers


{ id, class, classList } =
    Html.CssHelpers.withNamespace "metab"
header : Bool -> String -> Html a
header isReddit name =
    div [ Html.Attributes.class "row" ]
        [ div [ Html.Attributes.class "col-md-12" ]
            [ div
                [ classList
                    [ ( MyCss.HN, not isReddit )
                    , ( MyCss.Reddit, isReddit )
                    ]
                ]
                [ text name ]
            ]
        ]
