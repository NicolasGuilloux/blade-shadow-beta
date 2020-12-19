module Base.View exposing (..)

import Base.Utils exposing (..)
import FontAwesome
import Html exposing (..)
import Html.Attributes exposing (..)
import Libs.Tailwind as TW exposing (..)
import List
import Template.Footer as Footer
import Template.Navbar as Navbar
import Template.PreFooter as PreFooter


view : Navbar.NavbarConfig msg -> List (Html msg) -> Html msg
view config subBody =
    div
        [ leadingNormal
        , trackingNormal
        , textWhite
        , pt16
        , lgPt24
        , class "gradient"
        ]
    <|
        List.concat
            [ [ navbar config ]
            , subBody
            , [ referalCodes, footer, copyright ]
            ]


navbar : Navbar.NavbarConfig msg -> Html msg
navbar config =
    Navbar.view
        { actualLabel = config.actualLabel
        , brand = config.brand
        , navbarToggleMessage = config.navbarToggleMessage
        , isNavbarCollapsed = config.isNavbarCollapsed
        , links =
            [ Navbar.NavbarLink
                |> pipe "Home"
                |> pipe "index"
                |> pipe False
                |> pipe Nothing
            , Navbar.NavbarLink
                |> pipe "Setup"
                |> pipe "setup"
                |> pipe False
                |> pipe Nothing
            , Navbar.NavbarLink
                |> pipe "Known issues"
                |> pipe "issues"
                |> pipe False
                |> pipe Nothing
            , Navbar.NavbarLink
                |> pipe "Tweaks"
                |> pipe "tweaks"
                |> pipe False
                |> pipe Nothing
            , Navbar.NavbarLink
                |> pipe "Our work on Github"
                |> pipe "https://github.com/NicolasGuilloux/blade-shadow-beta/"
                |> pipe True
                |> pipe (Just FontAwesome.gitHub)
            ]
        }


footer : Html msg
footer =
    Footer.footer
        [ Footer.FooterConfig
            |> pipe "Discord"
            |> pipe
                [ Footer.FooterLink
                    |> pipe "Official France"
                    |> pipe "https://discord.gg/shadowtech"
                    |> pipe Nothing
                    |> pipe True
                , Footer.FooterLink
                    |> pipe "Official German"
                    |> pipe "https://discord.gg/shadowde"
                    |> pipe Nothing
                    |> pipe True
                , Footer.FooterLink
                    |> pipe "Official Europe"
                    |> pipe "https://discord.gg/shadowen"
                    |> pipe Nothing
                    |> pipe True
                , Footer.FooterLink
                    |> pipe "Official USA"
                    |> pipe "https://discord.gg/m3m28kq"
                    |> pipe Nothing
                    |> pipe True
                , Footer.FooterLink
                    |> pipe "Side project"
                    |> pipe "https://discord.gg/9HwHnHq"
                    |> pipe Nothing
                    |> pipe True
                ]
        ]


referalCodes : Html msg
referalCodes =
    PreFooter.preFooter
        { title = "You want to thank us?"
        , body =
            [ Html.p [ TW.textGray300, TW.textXl, TW.px6 ]
                [ text "Nah, we don't want any money of any kind."
                , br [] []
                , text "This is not our job, and nobody has an intellectual property of any kind on anything. True OpenSource!"
                ]
            , Html.p [ TW.textGray300, TW.textXl, TW.px6 ]
                [ text "You still want to give us a gift? You're pretty stubborn, aren't you? The only way would be to use our referal codes."
                , br [] []
                , text "Feel free to use or share them :)"
                , br [] []
                , text "Thanks!"
                ]
            , Html.p [ TW.textGray300, TW.textXl, TW.mt6, TW.px6 ]
                [ Html.table [ TW.table, TW.tableAuto, TW.mAuto ] <|
                    List.map referalCode
                        [ ( "Nover", "NINC9DP" )
                        , ( "GiantPandaRoux", "JLRYV" )
                        , ( "AgentCobra", "4LKBA" )
                        , ( "Elyhaka", "JRMIXPEY" )
                        ]
                ]
            ]
        }


referalCode : ( String, String ) -> Html msg
referalCode ( pseudo, rCode ) =
    let
        link =
            \label ->
                Html.a [ href ("https://shop.shadow.tech/invite/" ++ rCode), target "_blank", TW.textGray100, TW.fontBold ]
                    [ text label
                    ]
    in
    tr []
        [ Html.td [ TW.textLeft ] [ link pseudo ]
        , Html.td [ TW.textRight ] [ link rCode ]
        ]


copyright : Html msg
copyright =
    div [ bgWhite, textCenter, p6 ]
        [ p [ textGray600 ]
            [ text "This website and its content are not linked with the "
            , a [ href "http://www.blade-group.com", target "_blank", fontBold, textGray900 ] [ text "Blade" ]
            , text " company. It was made by the community for the community."
            ]
        , p [ textGray600 ]
            [ text "Designed by Nicolas Guilloux with "
            , a [ href "https://tailwindcss.com/", target "_blank", fontBold, textGray900 ] [ text "Tailwind" ]
            , text " and "
            , a [ href "https://elm-lang.org/", target "_blank", fontBold, textGray900 ] [ text "Elm" ]
            , text ". This is a "
            , a [ href "https://www.tailwindtoolbox.com/templates/landing-page", target "_blank", fontBold, textGray900 ] [ text "Tailwind Toolbox" ]
            , text " template."
            ]
        ]
