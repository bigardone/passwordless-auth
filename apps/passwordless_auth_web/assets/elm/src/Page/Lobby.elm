module Page.Lobby
    exposing
        ( Model
        , Msg(..)
        , init
        , update
        )

import Json.Decode as Decode exposing (Value)
import Phoenix
import Phoenix.Push as Push exposing (Push)


-- MODEL --


type alias Model =
    List String


initialModel : Model
initialModel =
    []



-- UPDATE --


type Msg
    = HandleInitSuccess Decode.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleInitSuccess payload ->
            case Decode.decodeValue usersDecoder payload of
                Ok emails ->
                    emails ! []

                Err _ ->
                    model ! []


usersDecoder : Decode.Decoder (List String)
usersDecoder =
    Decode.at [ "data" ] <| Decode.list Decode.string



-- INIT --


init : String -> ( Model, Cmd Msg )
init socketUrl =
    ( initialModel
    , Push.init "admin:lobby" "data"
        |> Push.onOk HandleInitSuccess
        |> Phoenix.push socketUrl
    )
