module Template.Article exposing (..)

import Html exposing (Attribute, Html)
import Html.Attributes exposing (..)
import Libs.Tailwind as TW
import String.Normalize exposing (slug)
import Template.Elements exposing (..)


type alias SectionConfig msg =
    { title : String
    , body : List (Html msg)
    }


article : SectionConfig msg -> Html msg
article config =
    Html.article [ TW.bgWhite, TW.borderB, TW.py8, TW.textBlack ]
        [ div [ TW.container, TW.maxW5xl, TW.mxAuto, TW.m8 ]
            [ p []
                [ h3 [ id (slug config.title), class "anchor" ] [ text config.title ]
                ]
            , p [ TW.wFull, TW.mb8, TW.mt4 ]
                [ Html.div [ TW.h1, TW.w32, TW.opacity25, TW.my0, TW.py0, TW.roundedT, class "gradient" ] []
                ]
            , div [ TW.wFull, TW.mb4 ] config.body
            ]
        ]
