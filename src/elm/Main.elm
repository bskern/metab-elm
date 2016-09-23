module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Http
import Task
import Html.CssHelpers
import Style.MyCss as MyCss
import Model.WeatherAPI exposing (..)
import Model.Weather exposing (Weather)
import Components.Weather exposing (weatherView)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "myweather"
getWeatherFromWeatherResponse : WeatherResponse -> Weather
getWeatherFromWeatherResponse wr =
    let
        item =
            wr.query.results.channel.item

        ct =
            item.condition.temp

        fResp =
            getForecastResponse (List.head item.forecast)
    in
        { currentTemp = ct
        , desc = fResp.desc
        , high = fResp.high
        , low = fResp.low
        }


type alias ForecastResponse =
    { desc : String
    , high : String
    , low : String
    }


emptyForecastResp : ForecastResponse
emptyForecastResp =
    { desc = initModel.desc
    , high = initModel.high
    , low = initModel.low
    }


getForecastResponse : Maybe Forecast -> ForecastResponse
getForecastResponse f =
    case f of
        Nothing ->
            emptyForecastResp

        Just f ->
            { desc = f.text
            , high = f.high
            , low = f.low
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


type alias Model =
    Weather


initModel : Model
initModel =
    { currentTemp = "na"
    , desc = "fetching"
    , high = "99"
    , low = "99"
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, getWeather )



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


view : Model -> Html Msg
view model =
    div [ class [ MyCss.App ] ] [ weatherView model ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
