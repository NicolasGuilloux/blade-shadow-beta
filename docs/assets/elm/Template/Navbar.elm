module Template.Navbar exposing (..)

import Base.Utils exposing (..)
import FontAwesome
import Html exposing (..)
import Html.Attributes exposing (class, href, id, target)
import Html.Events exposing (onClick)
import Libs.Tailwind exposing (..)
import String.Normalize exposing (slug)


type alias NavbarConfig msg =
    { actualLabel : String
    , brand : String
    , navbarToggleMessage : msg
    , isNavbarCollapsed : Bool
    , links : List NavbarLink
    }


type alias NavbarLink =
    { label : String
    , url : String
    , isBlankTarget : Bool
    , icon : Maybe FontAwesome.Icon
    }


view : NavbarConfig msg -> Html msg
view config =
    nav [ id "header", fixed, wFull, z30, top0, textWhite ]
        [ div [ wFull, container, mxAuto, flex, flexWrap, itemsCenter, justifyBetween, mt0, py2 ]
            [ brand config.brand
            , toggleIcon config.navbarToggleMessage
            , navbarItems config
            ]
        , hr [ borderB, borderGray100, opacity25, my0, py0 ] []
        ]


brand : String -> Html msg
brand label =
    div [ pl4, flex, itemsCenter ]
        [ a [ href "/", textWhite, noUnderline, fontBold, text2xl, lgText4xl, hoverNoUnderline, class "toggleColour" ]
            [ text label
            ]
        ]


toggleIcon : msg -> Html msg
toggleIcon toggleMsg =
    div [ block, pr4, lgHidden ]
        [ button [ id "nav-toggle", flex, itemsCenter, p1, textGray100, hoverTextGray500, onClick toggleMsg ]
            [ FontAwesome.icon FontAwesome.bars
            ]
        ]


navbarItems : NavbarConfig msg -> Html msg
navbarItems config =
    let
        item =
            navbarItem config.actualLabel
    in
    div [ id "nav-content", wFull, flexGrow, textWhite, p4, z20, mt2, lgFlex, lgItemsCenter, lgWAuto, lgBlock, lgMt0, lgBgTransparent, attributeWhen config.isNavbarCollapsed hidden ]
        [ ul [ flex1, itemsCenter, justifyEnd, lgFlex, class "list-reset" ] <|
            List.map item config.links
        ]


navbarItem : String -> NavbarLink -> Html msg
navbarItem actualLabel config =
    let
        whenCurrentLabel =
            attributeWhen (slug config.label == actualLabel)
    in
    li [ mr3 ]
        [ a
            [ href config.url
            , inlineBlock
            , py2
            , px4
            , textWhite
            , noUnderline
            , roundedFull
            , transition
            , hoverTextBlack
            , hoverBgGray300
            , whenCurrentLabel fontBold
            , whenCurrentLabel bgGray800
            , attributeWhen config.isBlankTarget (target "_blank")
            ]
            [ htmlJust config.icon <|
                \icon -> span [ mr2 ] [ FontAwesome.icon icon ]
            , text config.label
            ]
        ]
