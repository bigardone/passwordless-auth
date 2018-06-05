module Views.NotFound exposing (view)

import Html exposing (Html, form)


view : Html msg
view =
    Html.div
        []
        [ Html.h1
            []
            [ Html.text "404" ]
        , Html.p
            []
            [ Html.text "Page not found" ]
        ]
