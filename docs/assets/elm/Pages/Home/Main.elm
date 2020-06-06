module Pages.Home.Main exposing (..)

import Base.Main as Base
import Browser exposing (Document)
import Pages.Home.Data exposing (..)
import Pages.Home.Update as Update exposing (Model, Msg, initState)
import Pages.Home.View as View


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
    { title = "Home - Shadow Linux Community"
    , body = View.view model
    }
