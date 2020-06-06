module Base.Main exposing (Flags, Model, Msg, Program, program)

import Base.View as View
import Browser exposing (Document)
import Html exposing (Html)


type alias Program flags model msg =
    { init : flags -> ( model, Cmd msg )
    , view : model -> Document msg
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    }


type alias Flags flags =
    { actualPage : String
    , subFlags : flags
    }


type alias Model model =
    { actualPage : String
    , isNavbarCollapsed : Bool
    , subModel : model
    }


type Msg msg
    = MsgSubModel msg
    | MsgToggleMenu



--type Effect msg
--    = EffectToggleMenu
--    | EffectSubCmd (Cmd msg)
--    | EffectCmd (Cmd (Msg msg))


program : Program flags model msg -> Platform.Program (Flags flags) (Model model) (Msg msg)
program pageConfig =
    Browser.document
        { init = init pageConfig.init
        , view = view pageConfig.view
        , update = update pageConfig.update
        , subscriptions = subscriptions pageConfig.subscriptions
        }


init : (flags -> ( model, Cmd msg )) -> Flags flags -> ( Model model, Cmd (Msg msg) )
init subInit flags =
    let
        ( subModel, subCmd ) =
            subInit flags.subFlags
    in
    ( { actualPage = flags.actualPage
      , isNavbarCollapsed = True
      , subModel = subModel
      }
    , subCmd |> Cmd.map MsgSubModel
    )


update : (msg -> model -> ( model, Cmd msg )) -> Msg msg -> Model model -> ( Model model, Cmd (Msg msg) )
update subUpdate msg model =
    case msg of
        MsgSubModel subMsg ->
            let
                ( subModel, subCmd ) =
                    subUpdate subMsg model.subModel
            in
            ( { model | subModel = subModel }
            , subCmd |> Cmd.map MsgSubModel
            )

        MsgToggleMenu ->
            ( { model | isNavbarCollapsed = not model.isNavbarCollapsed }
            , Cmd.none
            )


view : (model -> Document msg) -> Model model -> Document (Msg msg)
view subview model =
    let
        subDocument =
            subview model.subModel

        subBody =
            subDocument.body
                |> List.map (Html.map MsgSubModel)
    in
    { title = subDocument.title
    , body =
        [ View.view
            { actualLabel = model.actualPage
            , brand = "Shadow on Linux"
            , navbarToggleMessage = MsgToggleMenu
            , isNavbarCollapsed = model.isNavbarCollapsed
            , links = []
            }
            subBody
        ]
    }


subscriptions : (model -> Sub msg) -> Model model -> Sub (Msg msg)
subscriptions subSubcriptions model =
    subSubcriptions model.subModel
        |> Sub.map MsgSubModel
