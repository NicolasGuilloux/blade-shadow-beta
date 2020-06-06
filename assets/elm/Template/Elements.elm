module Template.Elements exposing (..)

import Html exposing (Attribute, Html)
import Html.Attributes exposing (..)
import Libs.Tailwind as TW



-- Sections


div : List (Attribute msg) -> List (Html msg) -> Html msg
div =
    Html.div



-- Titles


h1 : List (Attribute msg) -> List (Html msg) -> Html msg
h1 attributes body =
    Html.div [ TW.wFull ]
        [ Html.h1
            (attributes
                |> (::) TW.wFull
                |> (::) TW.my2
                |> (::) TW.text5xl
                |> (::) TW.fontBold
                |> (::) TW.leadingTight
                |> (::) TW.textCenter
                |> (::) TW.textGray800
            )
            body
        , Html.div [ TW.wFull, TW.mb8, TW.mt4 ]
            [ Html.div [ TW.h1, TW.mxAuto, TW.w64, TW.opacity25, TW.my0, TW.py0, TW.roundedT, class "gradient" ] []
            ]
        ]


h3 : List (Attribute msg) -> List (Html msg) -> Html msg
h3 attributes =
    Html.h3
        (attributes
            |> (::) TW.textXl
            |> (::) TW.fontBold
            |> (::) TW.textGray700
        )


h4 : List (Attribute msg) -> List (Html msg) -> Html msg
h4 attributes =
    Html.h4
        (attributes
            |> (::) TW.textLg
            |> (::) TW.fontBold
            |> (::) TW.textGray700
            |> (::) TW.mt6
        )



-- GROUPING CONTENT


p : List (Attribute msg) -> List (Html msg) -> Html msg
p attributes =
    Html.p
        (attributes
            |> (::) TW.textGray600
            |> (::) TW.my2
            |> (::) TW.px6
            |> (::) TW.mxAuto
            |> (::) TW.wFull
            |> (::) TW.smW4over5
        )


hr : List (Attribute msg) -> List (Html msg) -> Html msg
hr attributes =
    Html.hr
        (attributes
            |> (::) TW.w2over5
            |> (::) TW.h1
            |> (::) TW.mxAuto
            |> (::) TW.roundedTFull
            |> (::) TW.borderB
            |> (::) TW.borderGray100
            |> (::) TW.opacity25
            |> (::) TW.my6
            |> (::) TW.py0
            |> (::) (class "gradient")
        )


code : List (Attribute msg) -> List (Html msg) -> Html msg
code attributes =
    Html.code
        (attributes
            |> (::) TW.inlineBlock
            |> (::) TW.bgGray100
            |> (::) TW.m2
            |> (::) TW.p1
            |> (::) TW.mxAuto
            |> (::) TW.borderGray500
            |> (::) TW.border
            |> (::) TW.borderSolid
            |> (::) TW.roundedLg
            |> (::) TW.maxWFull
        )



-- List


ul : List (Attribute msg) -> List (Html msg) -> Html msg
ul attributes =
    Html.ul
        (attributes
            |> (::) TW.listDisc
            |> (::) TW.listOutside
            |> (::) TW.ml8
            |> (::) TW.alignMiddle
        )


ol : List (Attribute msg) -> List (Html msg) -> Html msg
ol attributes =
    Html.ol
        (attributes
            |> (::) TW.listDecimal
            |> (::) TW.listOutside
            |> (::) TW.ml8
            |> (::) TW.alignMiddle
        )


li : List (Attribute msg) -> List (Html msg) -> Html msg
li =
    Html.li



-- Text


text : String -> Html msg
text =
    Html.text


a : List (Attribute msg) -> List (Html msg) -> Html msg
a attributes =
    Html.a
        (attributes
            |> (::) TW.textGray900
            |> (::) TW.fontBold
        )


aBlank : List (Attribute msg) -> List (Html msg) -> Html msg
aBlank attributes =
    a
        (attributes
            |> (::) (target "_blank")
        )


span : List (Attribute msg) -> List (Html msg) -> Html msg
span =
    Html.span


strong : List (Attribute msg) -> List (Html msg) -> Html msg
strong attributes =
    Html.strong
        (attributes
            |> (::) TW.fontBold
        )


{-| Represents a line break.
-}
br : List (Attribute msg) -> List (Html msg) -> Html msg
br =
    Html.br



-- EMBEDDED CONTENT


{-| Represents an image.
-}
img : List (Attribute msg) -> List (Html msg) -> Html msg
img attributes =
    Html.img
        (attributes
            |> (::) TW.maxWFull
        )


object : List (Attribute msg) -> List (Html msg) -> Html msg
object =
    Html.object



-- TABULAR DATA


{-| Represents data with more than one dimension.
-}
table : List (Attribute msg) -> List (Html msg) -> Html msg
table attributes =
    Html.table
        (attributes
            |> (::) TW.table
            |> (::) TW.tableFixed
            |> (::) TW.mxAuto
            |> (::) TW.border2
            |> (::) TW.borderSolid
            |> (::) TW.borderGray500
        )


tr : List (Attribute msg) -> List (Html msg) -> Html msg
tr =
    Html.tr


td : List (Attribute msg) -> List (Html msg) -> Html msg
td attributes =
    Html.td
        (attributes
            |> (::) TW.px4
            |> (::) TW.py2
            |> (::) TW.border
            |> (::) TW.borderSolid
            |> (::) TW.borderGray300
        )


th : List (Attribute msg) -> List (Html msg) -> Html msg
th attributes =
    Html.th
        (attributes
            |> (::) TW.px4
            |> (::) TW.py2
            |> (::) TW.fontBold
            |> (::) TW.textCenter
        )
