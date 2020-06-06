module Pages.Setup.Main exposing (..)

import Base.Main as Base
import Browser exposing (Document)
import Pages.Setup.Data exposing (..)
import Pages.Setup.Update as Update exposing (Model, Msg, initState)
import Pages.Setup.View as View


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
