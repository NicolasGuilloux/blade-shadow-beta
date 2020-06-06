module Pages.Troubleshoot.Main exposing (..)

import Base.Main as Base
import Browser exposing (Document)
import Pages.Troubleshoot.Data exposing (..)
import Pages.Troubleshoot.Update as Update exposing (Model, Msg, initState)
import Pages.Troubleshoot.View as View


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
    { title = "Troubleshoot - Shadow Linux Community"
    , body = View.view model
    }
