module Views.SignIn exposing (view)

import Html exposing (Html, form)
import Html.Attributes as Html
import Html.Events as Html
import Page.SignIn exposing (Model, SignInForm(..), Msg(..))


view : Model -> Html Msg
view { form } =
    let
        content =
            case form of
                Editing email ->
                    formView email

                Sending email ->
                    formView email

                Success text ->
                    successMessageView text

                Error text ->
                    errorMessageView text
    in
        Html.section
            [ Html.class "bg-purple-darker p-8 flex flex-1 items-center justify-center h-screen" ]
            [ content ]


formView : String -> Html Msg
formView email =
    Html.div
        []
        [ Html.img
            [ Html.src "/images/icons8-mailbox-128.png"
            , Html.class "mb-4 slide-in-blurred-top"
            ]
            []
        , Html.h3
            []
            [ Html.text "Password long? Hard to type?" ]
        , Html.p
            []
            [ Html.text "Get a magic link sent to your email that'll sign you instantly!" ]
        , form
            [ Html.class "w-full max-w-md"
            , Html.onSubmit HandleFormSubmit
            ]
            [ Html.input
                [ Html.class "appearance-none block w-full bg-grey-lighter text-grey-darker rounded py-3 px-4 mb-3"
                , Html.placeholder "foo@email.com"
                , Html.type_ "email"
                , Html.onInput HandleEmailInput
                , Html.value email
                ]
                []
            , Html.button
                [ Html.class "bg-blue hover:bg-blue-dark text-white py-3 px-4 mb-3 rounded w-full" ]
                [ Html.text "Send Magic Link" ]
            ]
        ]


successMessageView : String -> Html Msg
successMessageView message =
    Html.div
        []
        [ Html.img
            [ Html.src "/images/icons8-postal-128.png"
            , Html.class "mb-4 jello-horizontal"
            ]
            []
        , Html.h3
            []
            [ Html.text "Check your email" ]
        , Html.p
            []
            [ Html.text message ]
        ]


errorMessageView : String -> Html Msg
errorMessageView message =
    Html.div
        []
        [ Html.h3
            []
            [ Html.text "Whoops!" ]
        , Html.p
            []
            [ Html.text message ]
        ]
