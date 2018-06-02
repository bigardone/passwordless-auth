port module Ports exposing (saveToken)


port saveToken : Maybe String -> Cmd msg
