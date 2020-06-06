module Pages.Home.View exposing (..)

import FontAwesome
import Html exposing (Html)
import Html.Attributes exposing (..)
import Libs.Tailwind as TW
import Pages.Home.Update exposing (Model, Msg(..))
import Template.Banner as Banner
import Template.CompareBlock as CompareBlock
import Template.Elements exposing (..)
import Template.Molecules exposing (..)
import Template.Section as Section


view : Model -> List (Html Msg)
view _ =
    [ banner
    , appimage
    , communityProjects
    ]


banner : Html Msg
banner =
    Banner.banner <|
        [ div [ TW.flex, TW.flexColReverse, TW.wFull, TW.justifyCenter, TW.itemsCenter, TW.textCenter, TW.mdFlexRow ]
            [ div [ TW.wFull, TW.mdW3over5, TW.mdTextLeft ]
                [ Html.h1 [ TW.wFull, TW.my4, TW.text5xl, TW.fontBold, TW.leadingTight ]
                    [ text "Welcome aboard!"
                    ]
                , Html.p [ TW.leadingNormal, TW.text2xl, TW.mb8 ]
                    [ text "This is were the Linux community puts all tips and tweaks related to Shadow, the computer of the future."
                    ]
                , Html.p [ TW.leadingNormal, TW.text2xl, TW.mb8 ]
                    [ text "You'll find the setup guide, the issues and sometimes their fix or workaround, and also some tweaks to integrate your Shadow in your favorite OS."
                    ]
                , Html.p [ TW.leadingNormal, TW.text2xl, TW.mb8, TW.fontBold ]
                    [ text "It is not an official website, it was made by the community for the community."
                    ]
                ]
            , div [ TW.wFull, TW.mdW1over5, TW.myAuto, TW.px6, TW.textCenter ]
                [ img [ id "logo", TW.w1over3, TW.mdWFull, TW.mAuto, class "color-inverted", src "images/logo.png" ] []
                ]
            ]
        ]


appimage : Html Msg
appimage =
    Section.section
        { title = "AppImage"
        , body =
            [ div [ TW.wFull, TW.smW2over5, TW.my16, TW.mxAuto ]
                [ img [ TW.wFull, TW.p6, src "images/shadow_loves_linux.svg" ] []
                ]
            , p [ TW.textCenter ]
                [ text "The Shadow teams built an Appimage, which is a all-in-one package that embeds all main librairies and the application itself to improve compatiblity."
                ]
            , p [ TW.textCenter ]
                [ text "Even though Shadow provides the AppImage, you still need to have a compatible OS with the appropriate hardware. The Linux app is much more sensitive than on the other OS. "
                , text "Please check-out the "
                , a [ href "setup" ] [ text "setup guide" ]
                , text " to prevent any hassle during the first use."
                ]
            , CompareBlock.container
                [ { title = "Stable"
                  , url = "https://account.shadow.tech/apps"
                  , isTargetBlank = False
                  , buttonLabel = "Userspace"
                  , icon = Just FontAwesome.externalLinkAlt
                  , items = [ "More stable renderer", "Shadow Control Panel in the VM" ]
                  }
                , { title = "Beta"
                  , url = "https://account.shadow.tech/apps"
                  , isTargetBlank = True
                  , buttonLabel = "Userspace"
                  , icon = Just FontAwesome.externalLinkAlt
                  , items = [ "QuickMenu", "Microphone" ]
                  }
                , { title = "Alpha"
                  , url = "#discord"
                  , isTargetBlank = False
                  , buttonLabel = "Join Discord"
                  , icon = Just FontAwesome.discord
                  , items = [ "QuickMenu", "Microphone", "Latest renderer" ]
                  }
                ]
            ]
        }


communityProjects : Html Msg
communityProjects =
    Section.section
        { title = "Community projects"
        , body =
            [ div [ TW.flex, TW.flexWrap, TW.textCenter, TW.smTextLeft ]
                [ div [ TW.wFull, TW.p6, TW.smW1over2 ]
                    [ Html.h3 [ TW.text3xl, TW.textGray800, TW.fontBold, TW.mb5, TW.leadingNone ]
                        [ text "Shadow Live OS"
                        ]
                    , Html.p [ TW.textGray600, TW.my2 ]
                        [ text "A live Linux that starts Shadow and all needed components, ready out of the box!"
                        ]
                    , Html.p [ TW.textGray600, TW.my2, TW.mb8 ]
                        [ text "It is flash and go. Use your favorite software to flash the ISO on a USB drive, boot on it and enjoy!"
                        ]
                    , aButton "Check it on Gitlab" "https://gitlab.com/NicolasGuilloux/shadow-live-os" True (Just FontAwesome.gitLab)
                    ]
                , div [ TW.wFull, TW.p6, TW.smW1over2 ]
                    [ img [ src "images/shadow_live_os.png", class "rounded-lg" ] []
                    ]
                , hr [ TW.block, TW.smHidden ] []

                -- Shadow Networked Boot
                , div [ TW.wFull, TW.flex, TW.flexColReverse, TW.smFlexRow ]
                    [ div [ TW.wFull, TW.p6, TW.smW1over2 ]
                        [ img [ src "images/shadowos_networked_boot.png", class "rounded-lg" ] []
                        ]
                    , div [ TW.wFull, TW.p6, TW.smW1over2 ]
                        [ Html.h3 [ TW.text3xl, TW.textGray800, TW.fontBold, TW.mb5, TW.leadingNone ]
                            [ text "ShadowOS Networked boot "
                            ]
                        , Html.p [ TW.textGray600, TW.my2 ]
                            [ text "If the Shadow Live OS is something wonderful, it forces the user to have a USB thumbdrive with the OS flashed on it which takes space and monopolise a whole key."
                            ]
                        , Html.p [ TW.textGray600, TW.my2, TW.mb8 ]
                            [ text "Enter the ShadowOS Networked Boot. It is a very small file (<2MB) that can point to an URL where the Live OS is available, and boot on it from the network."
                            ]
                        , aButton "Check it on Gitlab" "https://gitlab.com/aar642/shadowos-boot" True (Just FontAwesome.gitLab)
                        ]
                    ]

                -- Shadowcker
                , div [ TW.wFull, TW.p6, TW.smW1over2 ]
                    [ Html.h3 [ TW.text3xl, TW.textGray800, TW.fontBold, TW.mb5, TW.leadingNone ]
                        [ text "Shadowcker"
                        ]
                    , Html.p [ TW.textGray600, TW.my2 ]
                        [ text "Bring your Shadow client into a docker!"
                        ]
                    , Html.p [ TW.textGray600, TW.my2, TW.mb8 ]
                        [ text "It fixes some issues with certain OS where the dependencies cannot be installed."
                        ]
                    , aButton "Check it on Gitlab" "https://gitlab.com/aar642/shadowcker" True (Just FontAwesome.gitLab)
                    ]
                , div [ TW.wFull, TW.h64, TW.p6, TW.smW1over2 ]
                    [ img [ src "images/docker.png", TW.roundedLg, TW.hFull, TW.mAuto ] []
                    ]
                , hr [ TW.block, TW.smHidden ] []
                ]
            ]
        }
