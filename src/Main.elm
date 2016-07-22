module Main exposing (..)

import Html.App as Html
import Model exposing (Model, initModel)
import View exposing (view)
import Update exposing (Msg, update, subscriptions)

main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

init : (Model, Cmd Msg)
init =
    (initModel, Cmd.none)
