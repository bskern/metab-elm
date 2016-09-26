module Components.SubredditContainer exposing (..)

import Model.RedditAPI exposing (..)
import Http
import Task
import Html exposing (..)
import Html.Attributes exposing (..)
import Components.Header exposing (..)
import Components.Article exposing (..)


type alias Model =
    { scala : List RedditLink
    , elm : List RedditLink
    , react : List RedditLink
    }


initModel : Model
initModel =
    { scala = []
    , elm = []
    , react = []
    }


type Subreddit
    = Scala
    | Elm
    | React


getSubReddit : Subreddit -> Cmd Msg
getSubReddit sr =
    let
        url =
            case sr of
                Scala ->
                    "https://www.reddit.com/r/scala.json"

                Elm ->
                    "https://www.reddit.com/r/elm.json"

                React ->
                    "https://www.reddit.com/r/reactjs.json"

        task =
            Http.get redditresponseDecoder url

        cmd =
            case sr of
                Scala ->
                    Task.perform Fail SubRedditScala task

                Elm ->
                    Task.perform Fail SubRedditElm task

                React ->
                    Task.perform Fail SubRedditReact task
    in
        cmd


type Msg
    = SubRedditScala RedditResponse
    | SubRedditElm RedditResponse
    | SubRedditReact RedditResponse
    | Fail Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubRedditScala resp ->
            ( { model | scala = (getListRedditLink resp) }, Cmd.none )

        SubRedditElm resp ->
            ( { model | elm = (getListRedditLink resp) }, Cmd.none )

        SubRedditReact resp ->
            ( { model | react = (getListRedditLink resp) }, Cmd.none )

        Fail error ->
            ( initModel, Cmd.none )


subredditView : Subreddit -> List RedditLink -> Html.Html a
subredditView sr ls =
    let
        srtext =
            case sr of
                Scala ->
                    "Scala"

                Elm ->
                    "Elm"

                React ->
                    "React"
    in
        Html.div []
            [ Html.div []
                [ Components.Header.header True srtext
                ]
            , Html.div []
                (List.map
                    (\articles -> (Components.Article.article articles.url articles.title))
                    ls
                )
            ]


view : Model -> Html.Html Msg
view model =
    div [ Html.Attributes.class "container-fluid" ]
        [ div [ Html.Attributes.class "row" ]
            [ div [ Html.Attributes.class "col-md-4" ] [ subredditView Scala model.scala ]
            , div [ Html.Attributes.class "col-md-4" ] [ subredditView Elm model.elm ]
            , div [ Html.Attributes.class "col-md-4" ] [ subredditView React model.react ]
            ]
        ]
