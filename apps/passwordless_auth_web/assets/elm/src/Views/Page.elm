module Views.Page exposing
    ( Msg(..)
    , frameView
    , headerView
    )

import Data.Session exposing (Session(..))
import Html exposing (Html)
import Html.Attributes as Html
import Html.Events as Html


type Msg
    = SignOut


frameView : Session -> Html msg -> Html msg -> Html msg
frameView session header content =
    case session of
        Anonymous ->
            Html.text ""

        Authenticated _ ->
            Html.div
                [ Html.class "main-section flex-1 flex-col flex h-screen" ]
                [ header
                , Html.div
                    [ Html.class "main-content bg-grey-lightest flex-1 flex items-center justify-center" ]
                    [ content ]
                ]


headerView : Html Msg
headerView =
    Html.header
        [ Html.class "main-header" ]
        [ Html.nav
            [ Html.class "flex justify-between" ]
            [ Html.span
                [ Html.class "flex-1 p-4 text-white text-left" ]
                [ Html.text "Admin panel" ]
            , Html.a
                [ Html.class "p-4"
                , Html.onClick SignOut
                ]
                [ Html.text "Sign out" ]
            ]
        ]
