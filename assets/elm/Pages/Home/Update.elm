module Pages.Home.Update exposing (..)

import Pages.Home.Data exposing (..)
import Platform.Cmd


type alias Model =
    {}


type Msg
    = MsgNoOp


initState : Flags -> ( Model, Cmd msg )
initState _ =
    ( {}
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgNoOp ->
            ( model, Cmd.none )
