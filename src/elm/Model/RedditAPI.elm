module Model.RedditAPI exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)


getListRedditLink : RedditResponse -> List RedditLink
getListRedditLink rr =
    List.map (\child -> child.data) rr.data.children


type alias RedditResponse =
    { data : RedditWrapper }


redditresponseDecoder : Decoder RedditResponse
redditresponseDecoder =
    decode RedditResponse
        |> required "data" redditwrapperDecoder


type alias RedditWrapper =
    { children : List RedditData }


redditwrapperDecoder : Decoder RedditWrapper
redditwrapperDecoder =
    decode RedditWrapper
        |> required "children" (list redditdataDecoder)


type alias RedditData =
    { data : RedditLink }


redditdataDecoder : Decoder RedditData
redditdataDecoder =
    decode RedditData
        |> required "data" redditlinkDecoder


type alias RedditLink =
    { title : String
    , url : String
    }


redditlinkDecoder : Decoder RedditLink
redditlinkDecoder =
    decode RedditLink
        |> required "title" string
        |> required "url" string
