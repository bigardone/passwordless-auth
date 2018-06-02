module Views.Page
    exposing
        ( frame
        )

import Data.Session exposing (User)
import Html exposing (Html)
import Html.Attributes as Html


frame : Bool -> Maybe User -> Html msg -> Html msg
frame isLoading user content =
    case user of
        Nothing ->
            Html.text ""

        Just user ->
            Html.div
                [ Html.class "main-section flex-1 flex-col flex h-screen" ]
                [ Html.header
                    [ Html.class "main-header" ]
                    [ Html.nav
                        [ Html.class "flex justify-between" ]
                        [ Html.span
                            [ Html.class "p-4 text-white" ]
                            [ Html.text "PasswordlessAuth" ]
                        , Html.a
                            [ Html.class "p-4" ]
                            [ Html.text user.email ]
                        ]
                    ]
                , Html.div
                    [ Html.class "main-content bg-grey-lightest flex-1 flex items-center justify-center" ]
                    [ content ]
                ]
