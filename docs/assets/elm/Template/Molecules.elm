module Template.Molecules exposing (..)

import Base.Utils exposing (..)
import FontAwesome
import Html exposing (Attribute, Html, span, text)
import Html.Attributes exposing (class, href, target)
import Libs.Tailwind as TW
import Template.Elements as Template


aButton : String -> String -> Bool -> Maybe FontAwesome.Icon -> Html msg
aButton label url isTargetBlank mIcon =
    Html.a
        [ href url
        , class "gradient"
        , attributeWhen isTargetBlank (target "_blank")
        , TW.mxAuto
        , TW.textWhite
        , TW.textCenter
        , TW.fontBold
        , TW.roundedFull
        , TW.my6
        , TW.py4
        , TW.px8
        , TW.lgShadow
        , TW.lgMx0
        , TW.hoverUnderline
        ]
        [ htmlJust mIcon <|
            \icon -> span [ TW.mr2 ] [ FontAwesome.icon icon ]
        , text label
        ]


codeBlock : List (Attribute msg) -> List (Html msg) -> Html msg
codeBlock attributes =
    Template.code
        (attributes
            |> (::) TW.wFull
            |> (::) TW.overflowAuto
            |> (::) TW.whitespacePre
        )
