module Components.Article exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Style.MyCss as MyCss
import Html.CssHelpers


{ id, class, classList } =
    Html.CssHelpers.withNamespace "metab"
article : String -> String -> Html a
article url title =
    div [ Html.Attributes.class "row" ]
        [ div [ Html.Attributes.class "col-md-12" ]
            [ div [ class [ MyCss.Content ] ]
                [ a [ class [ MyCss.Title ], target "_blank", href url ]
                    [ text title ]
                ]
            ]
        ]
