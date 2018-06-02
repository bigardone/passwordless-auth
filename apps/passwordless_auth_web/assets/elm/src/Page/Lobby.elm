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
    {}


initialModel : Model
initialModel =
    {}



-- UPDATE --


type Msg
    = HandleInitSuccess Decode.Value


init : String -> ( Model, Cmd Msg )
init socketUrl =
    ( initialModel
    , Push.init "admin:lobby" "data"
        |> Push.onOk HandleInitSuccess
        |> Phoenix.push socketUrl
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleInitSuccess payload ->
            model ! []
