module Template.Footer exposing (..)

import Base.Utils exposing (..)
import FontAwesome
import Html exposing (..)
import Html.Attributes exposing (..)
import Libs.Tailwind exposing (..)
import String.Normalize exposing (slug)


type alias FooterConfig =
    { title : String
    , links : List FooterLink
    }


type alias FooterLink =
    { label : String
    , url : String
    , icon : Maybe FontAwesome.Icon
    , isBlankTarget : Bool
    }


footer : List FooterConfig -> Html msg
footer configs =
    Html.footer [ bgWhite, p6 ]
        [ div [ container, mxAuto, px8 ]
            [ div [ flex, flexCol, py6, textCenter, mdFlexRow ] <|
                List.map footerCol configs
            ]
        ]


footerCol : FooterConfig -> Html msg
footerCol config =
    div [ flex1, wAuto, id (slug config.title) ]
        [ p [ uppercase, textGray500, mdMb6 ]
            [ text config.title
            ]
        , ul [ class "list-reset", mb6 ] <|
            List.map footerLink config.links
        ]


footerLink : FooterLink -> Html msg
footerLink config =
    li [ mt2, mr2, inlineBlock, itemsCenter, justifyBetween, textBlack, mdBlock, mdMr0 ]
        [ a [ href config.url, attributeWhen config.isBlankTarget (target "_blank") ]
            [ htmlJust config.icon <|
                \icon -> span [ mr2 ] [ FontAwesome.icon icon ]
            , text config.label
            ]
        ]
