module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.CssHelpers
import Style.MyCss as MyCss
import Components.SubredditContainer as SRContainer
import Components.WeatherContainer as WContainer


{ id, class, classList } =
    Html.CssHelpers.withNamespace "metab"
type alias AppModel =
    { weatherModel : WContainer.Model
    , srModel : SRContainer.Model
    }


initialModel : AppModel
initialModel =
    { weatherModel = WContainer.initModel
    , srModel = SRContainer.initModel
    }


init : ( AppModel, Cmd Msg )
init =
    ( initialModel
    , Cmd.batch
        [ Cmd.map WeatherMsg WContainer.getWeather
        , Cmd.map SubRedditMsg (SRContainer.getSubReddit SRContainer.Scala)
        , Cmd.map SubRedditMsg (SRContainer.getSubReddit SRContainer.Elm)
        , Cmd.map SubRedditMsg (SRContainer.getSubReddit SRContainer.React)
        ]
    )



-- ( initialModel, [ WContainer.getWeather, SRContainer.getSubReddit SRContainer.Scala, SRContainer.getSubReddit SRContainer.Elm, SRContainer.getSubReddit SRContainer.React ] )
--update


type Msg
    = WeatherMsg WContainer.Msg
    | SubRedditMsg SRContainer.Msg


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



-- what I am thinking is now I know how to send messages to child ot fetch data
-- I coudl have 3 SRContainers ...and have that view be singular
-- or I could have one view layout 3 columns and data .. thats not super bad is it
-- I could extract view code to one fn so SRC itself is just row/col col col view


view : AppModel -> Html Msg
view model =
    div [ class [ MyCss.App ] ]
        [ App.map WeatherMsg (WContainer.view model.weatherModel)
        , App.map SubRedditMsg (SRContainer.view model.srModel)
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
