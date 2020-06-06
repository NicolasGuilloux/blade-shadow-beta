module Pages.Troubleshoot.Data exposing (..)

import Json.Decode exposing (Decoder, nullable, string, bool, succeed)
import Json.Decode.Pipeline exposing (optional, required, requiredAt)


type alias Flags =
    { uid : Maybe String
    }


type alias Configuration =
    { distribution : Maybe String
    , baseDistribution : Maybe String
    , distributionVersion : Maybe String
    , kernel : Maybe String
    , environment : Maybe String
    , cpu : Maybe String
    , gpu : Maybe String
    , vaDriver : Maybe String
    , isH264Supported : Bool
    , isH265Supported : Bool
    }


getDistributionImage : Maybe String -> String
getDistributionImage mDistribution =
    let
        filename =
            mDistribution |> Maybe.withDefault "Undefined"
    in
    "images/distributions/" ++ String.toLower filename ++ ".png"

configurationDecoder : Decoder Configuration
configurationDecoder =
    Json.Decode.succeed Configuration
        |> required "distribution" (nullable string)
        |> required "baseDistribution" (nullable string)
        |> required "distributionVersion" (nullable string)
        |> required "kernel" (nullable string)
        |> required "environment" (nullable string)
        |> required "cpu" (nullable string)
        |> required "gpu" (nullable string)
        |> required "vaDriver" (nullable string)
        |> required "isH264Supported" bool
        |> required "isH265Supported" bool