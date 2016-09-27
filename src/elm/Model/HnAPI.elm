module Model.HnAPI exposing (..)

import Json.Decode as Json exposing ((:=))
import Http exposing (Error)
import String exposing (concat)
import Task exposing (Task, andThen, sequence)
import Time exposing (Time)


type alias HNItem =
    { title : String
    , id : String
    , url : Maybe String
    }


{-| A HN Item where the kind is "story", and ranked.
-}
type alias Story =
    { item : Item
    , rank : Float
    }


{-| A parsed JSON item from HN.
-}
type alias Item =
    { id : Int
    , kind : String
    , title : String
    , by : String
    , time : Float
    , score : Int
    , url : Maybe String
    , kids : List Int
    }


{-| End-point for the HN API.
-}
v0 : String
v0 =
    "https://hacker-news.firebaseio.com/v0/"


{-| End-point for an item on HN.
-}
yc : String
yc =
    "https://news.ycombinator.com/item?id="


getIds : String -> Task Error (List Int)
getIds =
    Http.get (Json.list Json.int) << (++) "https://hacker-news.firebaseio.com/v0/"


top : Task Error (List Int)
top =
    fetch "topstories.json"


askHN : Task Error (List Int)
askHN =
    fetch "askstories.json"


{-| Download IDs from FirebaseIO.
-}
fetch : String -> Task Error (List Int)
fetch =
    Http.get (Json.list Json.int) << (++) v0


{-| Download the most recent N items from a list if IDs.
-}
items : Int -> Task Error (List Int) -> Task Error (List Item)
items n task =
    task `andThen` (sequence << List.map item << List.take n)



{- Task to download an individual Item from HN. -}


item : Int -> Task Error Item
item id =
    Http.get decoder <| concat [ v0, "item/", toString id, ".json" ]


{-| JSON decoder for a list of HN item child IDs.
-}
kids : Json.Decoder (List Int)
kids =
    Json.oneOf
        [ "kids" := Json.list Json.int
        , Json.succeed []
        ]


{-| HN Item JSON decoder.
-}
decoder : Json.Decoder Item
decoder =
    Json.object8 Item
        ("id" := Json.int)
        ("type" := Json.string)
        ("title" := Json.string)
        ("by" := Json.string)
        ("time" := Json.float)
        ("score" := Json.int)
        ("url" := Json.string |> Json.maybe)
        (kids)


{-| A filtered list of HN Items that are ranked by time.
-}
stories : Int -> Time.Time -> Task Error (List Int) -> Task Error (List Story)
stories n time ids =
    Task.map (List.filterMap (story time)) (items n ids)


{-| Create a Story from a HN Item if it is a Story.
-}
story : Time.Time -> Item -> Maybe Story
story time item =
    if item.kind == "story" then
        Just (Story item <| rank time item)
    else
        Nothing


{-| Calculates the page rank of an Item at a given Time.
-}
rank : Time.Time -> Item -> Float
rank time item =
    let
        age =
            (Time.inSeconds time) - item.time

        hours =
            age / 3600

        base =
            if item.score <= 1 then
                0.0
            else
                toFloat item.score ^ 0.8

        rank =
            base / ((hours + 2) ^ 1.8)
    in
        case item.url of
            Just _ ->
                rank

            Nothing ->
                rank * 0.4


{-| Sort a list of stories by rank.
-}
sortByRank : List Story -> List Story
sortByRank =
    List.sortBy (\s -> -s.rank)


{-| Sort a list of stories by time.
-}
sortByTime : List Story -> List Story
sortByTime =
    List.sortBy (\s -> -s.item.time)
