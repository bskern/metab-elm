module Components.HnContainer exposing (..)

import Model.HnAPI exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Components.Header exposing (..)
import Components.Article exposing (..)
import Task exposing (Task, perform, andThen, sequence)


type alias Model =
    { ask : List Story
    , top : List Story
    }


type alias Display =
    { title : String
    , url : String
    }


initModel : Model
initModel =
    { ask = []
    , top = []
    }


type HackerNewsType
    = Ask
    | Top


type Msg
    = RefreshTop (List Story)
    | RefreshAsk (List Story)
    | None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RefreshTop stories ->
            ( { model | top = sortByTime stories }, Cmd.none )

        RefreshAsk stories ->
            ( { model | ask = sortByTime stories }, Cmd.none )

        None ->
            ( model, Cmd.none )


getHN : HackerNewsType -> Float -> Cmd Msg
getHN hntype time =
    case hntype of
        Ask ->
            let
                items =
                    Model.HnAPI.askHN
            in
                perform (always None) RefreshAsk <| stories 15 time items

        Top ->
            let
                items =
                    Model.HnAPI.top
            in
                perform (always None) RefreshTop <| stories 15 time items


hnView : String -> List Story -> Html a
hnView title stories =
    let
        res =
            List.map
                (\s ->
                    { url = Maybe.withDefault (Model.HnAPI.yc ++ (toString s.item.id)) s.item.url
                    , title = s.item.title
                    }
                )
                stories
    in
        Html.div []
            [ Html.div [] [ Components.Header.header False title ]
            , Html.div []
                (List.map
                    (\s -> (Components.Article.article s.url s.title))
                    res
                )
            ]


view : Model -> Html Msg
view model =
    div [ Html.Attributes.class "row" ]
        [ div [ Html.Attributes.class "col-md-6" ] [ hnView "Top Stories" model.top ]
        , div [ Html.Attributes.class "col-md-6" ] [ hnView "Ask" model.ask ]
        ]
