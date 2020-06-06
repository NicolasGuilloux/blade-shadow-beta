module Template.PreFooter exposing (..)

import Html exposing (Html, div, object, section, text)
import Html.Attributes exposing (..)
import Libs.Tailwind exposing (..)


type alias PreFooterConfig msg =
    { title : String
    , body : List (Html msg)
    }


preFooter : PreFooterConfig msg -> Html msg
preFooter config =
    div []
        [ separation
        , section [ container, mxAuto, textCenter, py6, mb12 ]
            [ Html.h1 [ wFull, my2, text5xl, fontBold, leadingTight, textCenter, textWhite ]
                [ text config.title
                ]
            , div [ wFull, mb4 ]
                [ div [ h1, mxAuto, bgWhite, w1over6, opacity25, my0, py0, roundedT ] []
                ]
            , div [] config.body
            ]
        ]


separation : Html msg
separation =
    div []
        [ object [ attribute "data" "images/footer_separation.svg" ] []
        ]
