module Pages.Issues.Main exposing (..)

import Base.Main as Base
import Browser exposing (Document)
import Pages.Issues.Data exposing (..)
import Pages.Issues.Update as Update exposing (Model, Msg, initState)
import Pages.Issues.View as View


main : Platform.Program (Base.Flags Flags) (Base.Model Model) (Base.Msg Msg)
main =
    Base.program
        { init = initState
        , view = partialView
        , update = Update.update
        , subscriptions = \_ -> Sub.none
        }


partialView : Model -> Document Msg
partialView model =
    { title = "Setup - Shadow Linux Community"
    , body = View.view model
    }
