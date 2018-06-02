module Page.SignIn
    exposing
        ( Model
        , Msg(..)
        , update
        , initialModel
        )

import Http
import Json.Encode as Encode
import Json.Decode as Decode


type alias Model =
    { email : String
    , message : Maybe String
    }


initialModel : Model
initialModel =
    { email = ""
    , message = Nothing
    }


type Msg
    = HandleEmailInput String
    | HandleFormSubmit
    | FormSubmitResponse (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleEmailInput value ->
            { model | email = value } ! []

        HandleFormSubmit ->
            model ! [ requestToken model.email ]

        FormSubmitResponse payload ->
            case payload of
                Ok message ->
                    { model
                        | message = Just message
                        , email = ""
                    }
                        ! []

                _ ->
                    { model
                        | message = Just "We couldn't sent you your magic link due to an error, please try again later."
                        , email = ""
                    }
                        ! []


requestToken : String -> Cmd Msg
requestToken email =
    let
        body =
            Encode.object [ ( "email", Encode.string email ) ]

        request =
            Http.request
                { method = "POST"
                , headers = []
                , url = "/api/auth"
                , body = Http.jsonBody body
                , expect = Http.expectJson requestTokenDecoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send FormSubmitResponse request


requestTokenDecoder : Decode.Decoder String
requestTokenDecoder =
    Decode.at [ "message" ] Decode.string
