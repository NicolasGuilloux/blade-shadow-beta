module Template.Section exposing (..)

import Html exposing (Attribute, Html)
import Html.Attributes exposing (..)
import Libs.Tailwind as TW
import String.Normalize exposing (slug)
import Template.Elements exposing (..)


type alias SectionConfig msg =
    { title : String
    , body : List (Html msg)
    }


section : SectionConfig msg -> Html msg
section config =
    Html.section [ TW.bgWhite, TW.borderB, TW.py8, TW.textBlack ]
        [ div [ TW.container, TW.maxW5xl, TW.mxAuto, TW.mx8 ]
            [ h1 [ id (slug config.title), class "anchor" ] [ text config.title ]
            , div [ TW.wFull, TW.mb4 ] config.body
            ]
        ]
