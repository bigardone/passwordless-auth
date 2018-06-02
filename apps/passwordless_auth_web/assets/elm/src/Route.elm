module Route
    exposing
        ( Route(..)
        , fromLocation
        , newUrl
        )

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, oneOf, s, string, parsePath)


-- ROUTING --


type Route
    = SignInRoute
    | LobbyRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ Url.map LobbyRoute <| s ""
        , Url.map SignInRoute <| s "sign-in"
        ]



-- INTERNAL --


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                LobbyRoute ->
                    []

                SignInRoute ->
                    [ "sign-in" ]
    in
        "/" ++ String.join "/" pieces



-- PUBLIC HELPERS --


newUrl : Route -> Cmd msg
newUrl =
    routeToString >> Navigation.newUrl


fromLocation : Location -> Maybe Route
fromLocation location =
    parsePath matchers location
