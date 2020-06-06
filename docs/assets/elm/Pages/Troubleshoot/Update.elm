module Pages.Troubleshoot.Update exposing (..)

import Pages.Troubleshoot.Data exposing (..)
import Platform.Cmd
import Http


type alias Model =
    { uid : Maybe String
    , configuration : Maybe Configuration
    , isLoading : Bool
    }


type Msg
    = MsgGetConfigurationResult (Result Http.Error Configuration)


initState : Flags -> ( Model, Cmd Msg )
initState flags =
    ( { uid = flags.uid
      , configuration = Nothing
      , isLoading = (flags.uid /= Nothing)
      }
    , case flags.uid of
        Just uid ->
            getConfiguration uid MsgGetConfigurationResult

        Nothing ->
            Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgGetConfigurationResult result ->
            case result of 
                Ok config ->
                    ( { model | configuration = Just config, isLoading = False }
                    , Cmd.none 
                    )
                Err _ ->
                    ( { model | isLoading = False }
                    , Cmd.none
                    )

getConfiguration : String -> (Result Http.Error Configuration -> Msg) -> Cmd Msg
getConfiguration uid msg =
    Http.get
        { url = "http://shadow.test/api/hostbins/" ++ uid ++ "/configuration"
        , expect = Http.expectJson msg configurationDecoder
        }