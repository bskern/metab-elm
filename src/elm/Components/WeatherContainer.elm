module Components.WeatherContainer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Task
import Html.CssHelpers
import Style.MyCss as MyCss
import Model.WeatherAPI exposing (..)
import Model.Weather exposing (Weather)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "metab"
type alias Model =
    Weather


initModel : Model
initModel =
    { currentTemp = ""
    , desc = "fetching"
    , high = ""
    , low = ""
    }


getWeather : Cmd Msg
getWeather =
    let
        url =
            "https://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast where u='f' AND woeid in (select woeid from geo.places(1) where text=\" minneapolis \")&format=json"

        task =
            Http.get weatherResponseDecoder url

        cmd =
            Task.perform Fail Forecast task
    in
        cmd



--update


type Msg
    = Forecast WeatherResponse
    | Fail Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Forecast resp ->
            ( getWeatherFromWeatherResponse resp, Cmd.none )

        Fail error ->
            ( initModel, Cmd.none )


weatherView : Weather -> Html a
weatherView model =
    div [ Html.Attributes.class "navbar navbar-inverse" ]
        [ div [ Html.Attributes.class "container-fluid" ]
            [ div [ Html.Attributes.class "navbar-header" ]
                [ span [ Html.Attributes.class "navbar-brand" ] [ text ("Minneapolis " ++ model.currentTemp ++ " " ++ model.desc) ]
                ]
            , ul [ Html.Attributes.class "nav navbar-nav navbar-right" ]
                [ li [] [ a [] [ text ("High: " ++ model.high) ] ]
                , li [] [ a [] [ text ("Low: " ++ model.low) ] ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class [ MyCss.App ] ] [ weatherView model ]
