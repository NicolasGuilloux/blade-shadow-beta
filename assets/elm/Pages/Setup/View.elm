module Pages.Setup.View exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (..)
import Libs.Tailwind as TW
import Pages.Setup.Data as Data
import Pages.Setup.Update exposing (Model, Msg(..))
import Template.Elements exposing (..)
import Template.Section as Section


view : Model -> List (Html Msg)
view _ =
    [ setupGuide
    , vainfoSetup
    , gpuSetup
    ]


setupGuide : Html Msg
setupGuide =
    Section.section
        { title = "Setup guide"
        , body =
            [ p []
                [ text "Shadow is compatible with the following OS and their more recent versions:"
                ]
            , p []
                [ a [ href "https://ubuntu.com/", target "_blank" ] [ text "Ubuntu 18.04" ]
                , text ", "
                , a [ href "https://www.linuxmint.com/", target "_blank" ] [ text "Linux Mint 19" ]
                , text ", "
                , a [ href "https://www.debian.org/", target "_blank" ] [ text "Debian 10" ]
                , text ", "
                , a [ href "https://www.archlinux.org/", target "_blank" ] [ text "Arch Linux" ]
                , text ", "
                , a [ href "https://getsol.us/", target "_blank" ] [ text "Solus" ]
                , text ", "
                , a [ href "https://getfedora.org/", target "_blank" ] [ text "Fedora 28" ]
                , text ", "
                , a [ href "https://galliumos.org/", target "_blank" ] [ text "GalliumOS 3.0" ]
                , text "."
                ]
            , p [ TW.mt4 ]
                [ text "If your OS meets the minimum version, lets get started! Please "
                , a [ href "index#appimage" ] [ text "download the official AppImage" ]
                , text "."
                ]
            , p []
                [ text "You may pick the one you prefer based on your liking but keep in mind that the Linux app is not under very active development, which means sometimes it may break even in Stable and a fix may be deployed only on Alpha or Beta. We recommand your to download them all, and change if you meet a blocking bug."
                ]
            , hr [] []
            , p []
                [ text "You now have the AppImage. Make it executable and start it to check that the launcher is here. Sadly, it is rarely click'n'play."
                ]
            , p []
                [ strong [] [ text "Shadow is not compatible with Wayland!" ]
                , text " Use Xorg instead."
                ]
            , p []
                [ strong [] [ text "For every user who wants the remember me feature" ]
                , text ", you need to install "
                , a [ href "https://wiki.archlinux.org/index.php/GNOME/Keyring", target "_blank" ]
                    [ code [ TW.ml1, TW.fontNormal ] [ text "gnome-keyring" ]
                    ]
                , text "."
                ]
            , p []
                [ strong [] [ text "On Arch Linux" ]
                , text ", Shadow requires "
                , a [ href "https://aur.archlinux.org/packages/libsndio-61-compat/", target "_blank" ]
                    [ code [ TW.ml1, TW.fontNormal ] [ text "libsndio-61-compat" ]
                    ]
                , text "."
                ]
            , p []
                [ strong [] [ text "For Fedora users" ]
                , text ", you may need to install the library "
                , a [ href "https://pkgs.org/search/?q=librtmp", target "_blank" ]
                    [ code [ TW.ml1, TW.fontNormal ] [ text "librtmp" ]
                    ]
                , text "."
                ]
            , p [ TW.pt12 ]
                [ text "The community built a wonderful report script that gather all information to debug quickly your setup. Everytime you ask for help, please join the link given back the following command:"
                ]
            , p []
                [ code [ TW.overflowAuto ]
                    [ text "curl https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/scripts/report.pl | perl"
                    ]
                ]
            ]
        }


vainfoSetup : Html Msg
vainfoSetup =
    Section.section
        { title = "Setup you GPU for the VA-API"
        , body =
            [ p [ TW.mb2 ]
                [ text "As Shadow for Linux uses the VA-API, it is important to well setup your GPU for it. So it is important to understand how works"
                , code [ TW.ml1, TW.mr1 ] [ text "vainfo" ]
                , text " and how to debug it."
                ]
            , p []
                [ text "First things first, vainfo needs to be installed on your OS. It is a program that describes how your GPU is detected by the VA-API."
                ]
            , p []
                [ ul []
                    [ li []
                        [ text "Debian: "
                        , code [] [ text "sudo apt install libva-glx2 vainfo" ]
                        ]
                    , li []
                        [ text "Arch Linux: "
                        , code [] [ text "sudo pacman -S libva-utils" ]
                        ]
                    , li []
                        [ text "Solus: "
                        , code [] [ text "sudo eopkg it libva-utils" ]
                        ]
                    ]
                ]
            , p []
                [ text "Vainfo scans your GPU with the given driver to check his abilities. There are 3 things to check from the result of the command:"
                ]
            , p []
                [ ul []
                    [ li []
                        [ text "If it returns nothing or returns -1 somewhere, it means that the GPU is not well detected. Your VA driver needs to be updated."
                        ]
                    , li []
                        [ text "In the list of profiles, it mentions \"H264\" at least once. If supported, you can use the Shadow on Linux."
                        ]
                    , li []
                        [ text "In the list of profiles, it mentions \"H265\" or \"HEVC\" at least once. If not, you will not be able to use H265 but as long as you have H264, you still can use Shadow on Linux."
                        ]
                    ]
                ]
            , p []
                [ text "The following result show that the GPU is well recognized and have both profiles wanted. The relevant information are highlighted."
                ]
            , p []
                [ code [ TW.wFull, TW.overflowAuto, TW.whitespacePre ]
                    Data.validVainfoReport
                ]
            ]
        }


gpuSetup : Html msg
gpuSetup =
    Section.section
        { title = "Install your drivers"
        , body =
            [ p []
                [ text "Now that you understand how vainfo works, it is time to install the appropriate driver for your GPU. Sadly, there is not one driver and it depends on your GPU brand and model."
                ]
            , p []
                [ text "As it may change during time, we recommand you to read the documentation of the 2 main Linux distributions, especially the Arch Linux wiki because it is very complete: "
                , a [ href "https://wiki.archlinux.org/index.php/Hardware_video_acceleration#Installation", target "_blank" ] [ text "Arch Linux" ]
                , text ", "
                , a [ href "https://doc.ubuntu-fr.org/vaapi", target "_blank", TW.textGray900 ] [ text "Ubuntu" ]
                , text "."
                ]
            , p []
                [ text "But as we are so nice, the following table is a summary of all the main cases we encountered. If you meet some difficulties to install the drivers, please come in the official Discord so we can speak and let us help you."
                ]
            , intelDriver
            , amdDriver
            , nvidiaDriver
            ]
        }


intelDriver : Html msg
intelDriver =
    div []
        [ hr [] []
        , h3 [ TW.textCenter ] [ text "Intel GPU" ]
        , p []
            [ table []
                [ tr []
                    [ th [] [ text "OS" ]
                    , th [] [ text "< 8th gen" ]
                    , th [] [ text "> 8th gen" ]
                    ]
                , tr []
                    [ td [] [ text "Ubuntu" ]
                    , td [] [ text "i965-va-driver" ]
                    , td [] [ text "intel-media-va-driver-non-free" ]
                    ]
                , tr []
                    [ td [] [ text "Arch Linux" ]
                    , td [] [ text "intel-media-driver" ]
                    , td [] [ text "libva-intel-driver" ]
                    ]
                , tr []
                    [ td [] [ text "Solus" ]
                    , td [] [ text "libva-intel-driver" ]
                    , td [] [ text "x" ]
                    ]
                , tr []
                    [ td [] [ text "NixOS" ]
                    , td [] [ text "vaapiIntel" ]
                    , td [] [ text "intel-media-driver" ]
                    ]
                ]
            ]
        ]


amdDriver : Html rsg
amdDriver =
    div []
        [ hr [] []
        , h3 [ TW.textCenter ] [ text "AMD GPU" ]
        , p []
            [ table []
                [ tr []
                    [ th [] [ text "OS" ]
                    , th [] [ text "Radeon HD xxxx" ]
                    , th [] [ text "Radeon Rxxx" ]
                    ]
                , tr []
                    [ td [] [ text "Ubuntu" ]
                    , td [] [ text "mesa-va-drivers" ]
                    , td [] [ text "vdpau-va-driver" ]
                    ]
                , tr []
                    [ td [] [ text "Arch Linux" ]
                    , td [] [ text "libva-mesa-driver" ]
                    , td [] [ text "mesa-vdpau" ]
                    ]
                , tr []
                    [ td [] [ text "Solus" ]
                    , td [] [ text "x" ]
                    , td [] [ text "libvdpau-va-dl" ]
                    ]
                , tr []
                    [ td [] [ text "NixOS" ]
                    , td [] [ text "vaapiVdpau" ]
                    , td [] [ text "libvdpau-va-dl" ]
                    ]
                ]
            ]
        ]


nvidiaDriver : Html rsg
nvidiaDriver =
    div []
        [ hr [] []
        , h3 [ TW.textCenter ] [ text "NVIDIA GPU" ]
        , p []
            [ table []
                [ tr []
                    [ th [] [ text "OS" ]
                    , th [] [ text "NVIDIA < 800 series" ]
                    , th [] [ text "NVIDIA > 800 series" ]
                    ]
                , tr []
                    [ td [] [ text "Ubuntu" ]
                    , td [] [ text "x" ]
                    , td [ rowspan 2 ]
                        [ text "Check "
                        , a [ href "https://gitlab.com/aar642/libva-vdpau-driver", target "_blank" ] [ text "Arekinath's patch" ]
                        ]
                    ]
                , tr []
                    [ td [] [ text "Arch Linux" ]
                    , td [] [ text "nouveau-fw" ]
                    ]
                , tr []
                    [ td [] [ text "Solus" ]
                    , td [] [ text "x" ]
                    , td [] [ text "x" ]
                    ]
                , tr []
                    [ td [] [ text "NixOS" ]
                    , td [] [ text "x" ]
                    , td [] [ text "x" ]
                    ]
                ]
            ]
        ]
