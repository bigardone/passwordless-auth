module Page.SignIn exposing
    ( Model
    , Msg(..)
    , SignInForm(..)
    , initialModel
    , update
    )

import Http
import Json.Decode as Decode
import Json.Encode as Encode



-- MODEL --


type SignInForm
    = Editing String
    | Sending String
    | Success String
    | Error String


type alias Model =
    { form : SignInForm }


initialModel : Model
initialModel =
    { form = Editing "" }



-- UPDATE --


type Msg
    = HandleEmailInput String
    | HandleFormSubmit
    | FormSubmitResponse (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ form } as model) =
    case ( msg, form ) of
        ( HandleEmailInput value, Editing _ ) ->
            { model | form = Editing value } ! []

        ( HandleFormSubmit, Editing email ) ->
            { model | form = Sending email } ! [ requestToken FormSubmitResponse email ]

        ( FormSubmitResponse payload, Sending _ ) ->
            case payload of
                Ok message ->
                    { model | form = Success message } ! []

                _ ->
                    { model | form = Error "We couldn't sent you your magic link due to an error, please try again later." } ! []

        _ ->
            model ! []


requestToken : (Result Http.Error String -> msg) -> String -> Cmd msg
requestToken msg email =
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
    Http.send msg request


requestTokenDecoder : Decode.Decoder String
requestTokenDecoder =
    Decode.at [ "message" ] Decode.string
