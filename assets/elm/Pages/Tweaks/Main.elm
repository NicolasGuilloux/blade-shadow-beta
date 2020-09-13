module Pages.Tweaks.Main exposing (..)

import Base.Main as Base
import Browser exposing (Document)
import Pages.Tweaks.Data exposing (..)
import Pages.Tweaks.Update as Update exposing (Model, Msg, initState)
import Pages.Tweaks.View as View


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
    { title = "Tweaks - Shadow Linux Community"
    , body = View.view model
    }
