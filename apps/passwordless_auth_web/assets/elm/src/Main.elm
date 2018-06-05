module Main exposing (main)

import Data.Session exposing (Session(..))
import Html exposing (Html, form, map)
import Json.Decode as Decode exposing (Value)
import Navigation exposing (Location)
import Page.Lobby
import Page.SignIn
import Phoenix
import Phoenix.Channel as Channel exposing (Channel)
import Phoenix.Push as Push exposing (Push)
import Phoenix.Socket as Socket exposing (AbnormalClose, Socket)
import Ports
import Route exposing (Route(..))
import Views.Lobby
import Views.NotFound
import Views.Page
import Views.SignIn



-- MODEL --


type ConnectionStatus
    = Connecting
    | Connected ChannelState
    | Disconnected


type ChannelState
    = Joining
    | Joined
    | Left


type Page
    = BlankPage
    | NotFoundPage
    | SignInPage Page.SignIn.Model
    | LobbyPage Page.Lobby.Model


type alias Flags =
    { token : Maybe String
    , socketUrl : String
    }


type alias Model =
    { page : Page
    , session : Session
    , connectionStatus : ConnectionStatus
    , flags : Flags
    }



-- UPDATE --


type Msg
    = SetRoute (Maybe Route)
    | ConnectionStatusChanged ConnectionStatus
    | HandleAdminChannelJoin Decode.Value
    | ViewsPageMsg Views.Page.Msg
    | HandleSignOutSuccess Decode.Value
    | PageSignInMsg Page.SignIn.Msg
    | PageLobbyMsg Page.Lobby.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ flags, page } as model) =
    let
        { socketUrl } =
            flags

        toPage toModel toMsg subUpdate subMsg subModel =
            let
                ( newModel, newCmd ) =
                    subUpdate subMsg subModel
            in
            ( { model | page = toModel newModel }, Cmd.map toMsg newCmd )
    in
    case ( msg, page ) of
        ( SetRoute route, _ ) ->
            setRoute route model

        ( ConnectionStatusChanged connectionStatus, _ ) ->
            let
                cmds =
                    case connectionStatus of
                        Disconnected ->
                            [ Route.newUrl SignInRoute
                            , Ports.saveToken Nothing
                            ]

                        _ ->
                            []
            in
            { model | connectionStatus = connectionStatus } ! cmds

        ( HandleAdminChannelJoin payload, _ ) ->
            case Decode.decodeValue Data.Session.decoder payload of
                Ok user ->
                    { model
                        | session =
                            Authenticated user
                        , connectionStatus = Connected Joined
                    }
                        ! [ Ports.saveToken model.flags.token ]

                Err error ->
                    let
                        _ =
                            Debug.log "Error" error
                    in
                    model ! []

        ( HandleSignOutSuccess _, _ ) ->
            { model
                | connectionStatus = Disconnected
                , session = Anonymous
            }
                ! [ Route.newUrl SignInRoute, Ports.saveToken Nothing ]

        ( ViewsPageMsg subMsg, _ ) ->
            case subMsg of
                Views.Page.SignOut ->
                    model
                        ! [ Push.init "admin:lobby" "sign_out"
                                |> Push.onOk HandleSignOutSuccess
                                |> Phoenix.push socketUrl
                          ]

        ( PageSignInMsg subMsg, SignInPage subModel ) ->
            toPage SignInPage PageSignInMsg Page.SignIn.update subMsg subModel

        ( PageLobbyMsg subMsg, LobbyPage subModel ) ->
            toPage LobbyPage PageLobbyMsg Page.Lobby.update subMsg subModel

        ( _, _ ) ->
            model ! []


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute ({ connectionStatus, session, flags } as model) =
    let
        transition init page toMsg =
            let
                ( subModel, subCmd ) =
                    init
            in
            { model | page = page subModel } ! [ Cmd.map toMsg subCmd ]
    in
    case maybeRoute of
        Nothing ->
            { model | page = NotFoundPage } ! [ Cmd.none ]

        Just SignInRoute ->
            { model | page = SignInPage Page.SignIn.initialModel } ! [ Cmd.none ]

        Just LobbyRoute ->
            case connectionStatus of
                Disconnected ->
                    model ! [ Route.newUrl SignInRoute ]

                _ ->
                    transition (Page.Lobby.init flags.socketUrl) LobbyPage PageLobbyMsg



-- VIEW --


view : Model -> Html Msg
view { session, page } =
    let
        header =
            Html.map ViewsPageMsg Views.Page.headerView

        frame =
            Views.Page.frameView session header
    in
    case ( page, session ) of
        ( SignInPage subModel, _ ) ->
            map PageSignInMsg (Views.SignIn.view subModel)

        ( LobbyPage subModel, Authenticated user ) ->
            frame <| map PageLobbyMsg (Views.Lobby.view user subModel)

        ( NotFoundPage, Authenticated _ ) ->
            frame Views.NotFound.view

        _ ->
            frame <| Html.text "View not implemented yet"



-- SUBSCRIPTIONS --


socket : Flags -> Socket Msg
socket { socketUrl, token } =
    Socket.init socketUrl
        |> Socket.withParams [ ( "token", Maybe.withDefault "" token ) ]
        |> Socket.onOpen (ConnectionStatusChanged (Connected Joining))
        |> Socket.onClose (\_ -> ConnectionStatusChanged Disconnected)
        |> Socket.withDebug


subscriptions : Model -> Sub Msg
subscriptions { connectionStatus, flags } =
    let
        { token } =
            flags

        adminChannel =
            Channel.init "admin:lobby"
                |> Channel.onJoin HandleAdminChannelJoin
                |> Channel.withDebug
    in
    case connectionStatus of
        Disconnected ->
            Sub.none

        _ ->
            Phoenix.connect (socket flags) [ adminChannel ]



-- MAIN AND INIT --


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        ( model, cmd ) =
            setRoute (Route.fromLocation location)
                { page = BlankPage
                , session = Anonymous
                , connectionStatus = Connecting
                , flags = flags
                }
    in
    model ! [ cmd ]


main : Program Flags Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
