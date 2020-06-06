module Template.CompareBlock exposing (..)

import FontAwesome
import Html exposing (..)
import Libs.Tailwind exposing (..)
import Template.Molecules exposing (..)


type alias CardConfig =
    { title : String
    , url : String
    , isTargetBlank : Bool
    , buttonLabel : String
    , icon : Maybe FontAwesome.Icon
    , items : List String
    }


container : List CardConfig -> Html msg
container configs =
    div
        [ flex
        , flexCol
        , itemsCenter
        , justifyCenter
        , my12
        , pt12
        , smFlex
        , smFlexRow
        , smMy4
        , smItemsStretch
        ]
    <|
        List.map card configs


card : CardConfig -> Html msg
card config =
    div [ flex, flexCol, w5over6, mx5, roundedNone, bgWhite, mt4, lgW1over4, lgRoundedLLg ]
        [ div [ flex1, bgWhite, textGray600, roundedT, roundedBNone, overflowHidden, shadow ]
            [ div [ p8, text3xl, fontBold, textCenter, borderB4 ]
                [ text config.title
                ]
            , ul [ wFull, textCenter, textSm ] <|
                List.map
                    (\item ->
                        li [ borderB, py4 ]
                            [ text item
                            ]
                    )
                    config.items
            ]
        , div [ flexNone, mtAuto, bgWhite, roundedB, roundedTNone, overflowHidden, shadow, p6 ]
            [ div [ flex, itemsCenter, justifyCenter ]
                [ aButton config.buttonLabel config.url config.isTargetBlank config.icon
                ]
            ]
        ]
