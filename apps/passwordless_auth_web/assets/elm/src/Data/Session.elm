module Data.Session
    exposing
        ( Session
        , User
        , decoder
        , encode
        )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode exposing (Value)


type alias User =
    { email : String }


type alias Session =
    { user : Maybe User }



-- SERIALIZATION --


decoder : Decoder User
decoder =
    decode User
        |> required "email" Decode.string


encode : User -> Decode.Value
encode user =
    Encode.object
        [ ( "email", Encode.string user.email )
        ]
