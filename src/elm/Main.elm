module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.CssHelpers
import Html.Attributes exposing (..)
import Style.MyCss as MyCss
import Components.SubredditContainer as SRContainer
import Components.WeatherContainer as WContainer
import Components.HnContainer as HNContainer
import Time exposing (Time, now)
import Task exposing (perform)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "metab"
type alias AppModel =
    { weatherModel : WContainer.Model
    , srModel : SRContainer.Model
    , hnModel : HNContainer.Model
    }


initialModel : AppModel
initialModel =
    { weatherModel = WContainer.initModel
    , srModel = SRContainer.initModel
    , hnModel = HNContainer.initModel
    }


init : ( AppModel, Cmd Msg )
init =
    ( initialModel, perform (always None) Get now )


init2 : Float -> ( AppModel, Cmd Msg )
init2 time =
    ( initialModel
    , Cmd.batch
        [ Cmd.map WeatherMsg WContainer.getWeather
        , Cmd.map SubRedditMsg (SRContainer.getSubReddit SRContainer.Scala)
        , Cmd.map SubRedditMsg (SRContainer.getSubReddit SRContainer.Elm)
        , Cmd.map SubRedditMsg (SRContainer.getSubReddit SRContainer.React)
        , Cmd.map HackerNewsMsg (HNContainer.getHN HNContainer.Top time)
        , Cmd.map HackerNewsMsg (HNContainer.getHN HNContainer.Ask time)
        ]
    )


type Msg
    = WeatherMsg WContainer.Msg
    | SubRedditMsg SRContainer.Msg
    | HackerNewsMsg HNContainer.Msg
    | Get Time
    | None


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    case msg of
        WeatherMsg subMsg ->
            let
                ( updatedWeatherModel, weatherCmd ) =
                    WContainer.update subMsg model.weatherModel
            in
                ( { model | weatherModel = updatedWeatherModel }, Cmd.map WeatherMsg weatherCmd )

        SubRedditMsg subMsg ->
            let
                ( updatedSRModel, subredditCmd ) =
                    SRContainer.update subMsg model.srModel
            in
                ( { model | srModel = updatedSRModel }, Cmd.map SubRedditMsg subredditCmd )

        HackerNewsMsg subMsg ->
            let
                ( updatedHNModel, hnCmd ) =
                    HNContainer.update subMsg model.hnModel
            in
                ( { model | hnModel = updatedHNModel }, Cmd.map HackerNewsMsg hnCmd )

        Get time ->
            init2 time

        None ->
            ( model, Cmd.none )


view : AppModel -> Html Msg
view model =
    div [ class [ MyCss.App ] ]
        [ div [ Html.Attributes.class "container-fluid" ]
            [ App.map WeatherMsg (WContainer.view model.weatherModel)
            , App.map SubRedditMsg (SRContainer.view model.srModel)
            , App.map HackerNewsMsg (HNContainer.view model.hnModel)
            ]
        ]


subscriptions : AppModel -> Sub Msg
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
