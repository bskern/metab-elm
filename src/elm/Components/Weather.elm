module Components.Weather exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model.Weather exposing (Weather)


weatherView : Weather -> Html a
weatherView model =
    div [ class "navbar navbar-inverse" ]
        [ div [ class "container-fluid" ]
            [ div [ class "navbar-header" ]
                [ span [ class "navbar-brand" ] [ text ("Minneapolis " ++ model.currentTemp ++ " " ++ model.desc) ]
                ]
            , ul [ class "nav navbar-nav navbar-right" ]
                [ li [] [ a [] [ text ("High: " ++ model.high) ] ]
                , li [] [ a [] [ text ("Low: " ++ model.low) ] ]
                ]
            ]
        ]
