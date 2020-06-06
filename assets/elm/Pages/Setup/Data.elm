module Pages.Setup.Data exposing (..)

import Html exposing (Html, br, span, text)
import Libs.Tailwind exposing (..)
import List.Extra as List


type alias Flags =
    {}


validVainfoReport : List (Html msg)
validVainfoReport =
    let
        highlight =
            \label -> span [ textRed500, fontBold ] [ text label ]
    in
    [ [ text "libva info: VA-API version 1.1.0" ]
    , [ text "libva info: va_getDriverName() ", highlight "returns 0" ]
    , [ text "libva info: Trying to open /usr/lib/x86_64-linux-gnu/dri/i965_drv_video.so" ]
    , [ text "libva info: Found init function __vaDriverInit_1_1" ]
    , [ text "libva info: va_openDriver() ", highlight "returns 0" ]
    , [ text "vainfo: VA-API version: 1.1 (libva 2.1.0)" ]
    , [ text "vainfo: Driver version: Intel i965 driver for Intel(R) Skylake - 2.1.0" ]
    , [ text "vainfo: Supported profile and entrypoints" ]
    , [ text "  VAProfileMPEG2Simple            : VAEntrypointVLD" ]
    , [ text "  VAProfileMPEG2Simple            : VAEntrypointEncSlice" ]
    , [ text "  VAProfileMPEG2Main              : VAEntrypointVLD" ]
    , [ text "  VAProfileMPEG2Main              : VAEntrypointEncSlice" ]
    , [ text "  VAProfile", highlight "H264", text "ConstrainedBaseline: VAEntrypointVLD" ]
    , [ text "  VAProfile", highlight "H264", text "ConstrainedBaseline: VAEntrypointEncSlice" ]
    , [ text "  VAProfile", highlight "H264", text "ConstrainedBaseline: VAEntrypointEncSliceLP" ]
    , [ text "  VAProfile", highlight "H264", text "ConstrainedBaseline: VAEntrypointFEI" ]
    , [ text "  VAProfile", highlight "H264", text "ConstrainedBaseline: VAEntrypointStats" ]
    , [ text "  VAProfile", highlight "H264", text "Main               : VAEntrypointVLD" ]
    , [ text "  VAProfile", highlight "H264", text "Main               : VAEntrypointEncSlice" ]
    , [ text "  VAProfile", highlight "H264", text "Main               : VAEntrypointEncSliceLP" ]
    , [ text "  VAProfile", highlight "H264", text "Main               : VAEntrypointFEI" ]
    , [ text "  VAProfile", highlight "H264", text "Main               : VAEntrypointStats" ]
    , [ text "  VAProfile", highlight "H264", text "High               : VAEntrypointVLD" ]
    , [ text "  VAProfile", highlight "H264", text "High               : VAEntrypointEncSlice" ]
    , [ text "  VAProfile", highlight "H264", text "High               : VAEntrypointEncSliceLP" ]
    , [ text "  VAProfile", highlight "H264", text "High               : VAEntrypointFEI" ]
    , [ text "  VAProfile", highlight "H264", text "High               : VAEntrypointStats" ]
    , [ text "  VAProfile", highlight "H264", text "MultiviewHigh      : VAEntrypointVLD" ]
    , [ text "  VAProfile", highlight "H264", text "MultiviewHigh      : VAEntrypointEncSlice" ]
    , [ text "  VAProfile", highlight "H264", text "StereoHigh         : VAEntrypointVLD" ]
    , [ text "  VAProfile", highlight "H264", text "StereoHigh         : VAEntrypointEncSlice" ]
    , [ text "  VAProfileVC1Simple              : VAEntrypointVLD" ]
    , [ text "  VAProfileVC1Main                : VAEntrypointVLD" ]
    , [ text "  VAProfileVC1Advanced            : VAEntrypointVLD" ]
    , [ text "  VAProfileNone                   : VAEntrypointVideoProc" ]
    , [ text "  VAProfileJPEGBaseline           : VAEntrypointVLD" ]
    , [ text "  VAProfileJPEGBaseline           : VAEntrypointEncPicture" ]
    , [ text "  VAProfileVP8Version0_3          : VAEntrypointVLD" ]
    , [ text "  VAProfileVP8Version0_3          : VAEntrypointEncSlice" ]
    , [ text "  VAProfile", highlight "HEVC", text "Main               : VAEntrypointVLD" ]
    , [ text "  VAProfile", highlight "HEVC", text "Main               : VAEntrypointEncSlice" ]
    ]
        |> List.intercalate [ br [] [] ]
