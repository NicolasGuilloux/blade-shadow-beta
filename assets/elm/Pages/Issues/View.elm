module Pages.Issues.View exposing (..)

import Base.Utils exposing (..)
import Html exposing (Html)
import Html.Attributes exposing (..)
import Libs.Tailwind as TW
import Pages.Issues.Update exposing (Model, Msg(..))
import Template.Article as Article
import Template.Elements exposing (..)
import Template.Section as Section


view : Model -> List (Html Msg)
view _ =
    [ abstract
    , nvidiaIssue
    , compositingIssue
    , drircIssue
    , noSandboxIssue
    ]


abstract : Html Msg
abstract =
    Section.section
        { title = "Known issues"
        , body =
            [ p []
                [ text """
                  Especially on the Linux application, there are a lot of issues that are not fixed yet.
                  This page describes the well known ones, and what you can do to fix them is possible.
                  """
                ]
            , div [ TW.textCenter, TW.mt12 ]
                [ a [ href "#the-nvidia-issue" ] [ text "The NVIDIA issue" ]
                , br [] []
                , a [ href "#the-compositing-issue" ] [ text "The application makes my environment jerky and all transparent components opaque" ]
                , br [] []
                , a [ href "#the-drirc-fix" ] [ text "The stream is colored or not sharp with an AMD or an Intel GPU" ]
                , br [] []
                , a [ href "#the-no-sandbox-fix" ] [ text "The launcher does not start at all" ]
                , br [] []
                ]
            ]
        }


nvidiaIssue : Html Msg
nvidiaIssue =
    Article.article
        { title = "The NVIDIA issue"
        , body =
            [ p []
                [ text """
                  The Shadow application on Linux uses the VA API (Video Acceleration API) which gives a set of tools
                  to manipulate video streams. Recent NVIDIA graphics cards hardly support VA API because NVIDIA chose
                  to use a proprietary codec called NVdecode (NVCuvid) and NVencode. More information about it over
                  """
                , a [ href "https://developer.nvidia.com/nvidia-video-codec-sdk", target "_blank" ] [ text "here" ]
                , text "."
                ]
            , p []
                [ text """
                  A workaround for Optimus equiped PC would be to use the Intel GPU instead of the NVIDIA GPU.
                  However, this mean having worst performance because the Intel GPU is obviously less powerful.
                  But for Shadow, most of the time, it is sufficient to decode without any glitch or lag the video
                  and audio stream.
                  """
                ]
            ]
                |> flip List.append nvidiaOptimus
                |> flip List.append nvidiaDiscrete
        }


nvidiaOptimus : List (Html msg)
nvidiaOptimus =
    [ p []
        [ h4 [] [ text "The Optimus case " ]
        ]
    , p []
        [ text """
          Optimus is a technology available on laptop where a NVIDIA and a Intel GPU are setup in the computer,
          working successively based on the workload. It gives a better power management for small tasks but provides
          the computing power stay high as for heavy tasks, the computer switches automatically to the NVIDIA GPU.
          So it means we can use Intel GPU instead of NVIDIA GPU if you have the sticker "NVIDIA Optimus".
          """
        ]
    , p []
        [ text "First things first, you need to install proprietary drivers. I let you find, based on your distribution ("
        , aBlank [ href "https://websiteforstudents.com/install-proprietary-nvidia-gpu-drivers-on-ubuntu-16-04-17-10-18-04/" ] [ text "Ubuntu" ]
        , text ", "
        , aBlank [ href "https://wiki.archlinux.org/index.php/NVIDIA#Installation" ] [ text "Arch Linux" ]
        , text ")"
        ]
    , p []
        [ img [ src "images/nvidia_prime_profiles.png", alt "Nvidia X Server Settings", TW.my6 ] []
        ]
    , p []
        [ text """
          Now open the NVIDIA X Server Settings (an application available now in your app menu) and click on
          "Prime profiles". You can now choose the Intel GPU. It can take a while (3 min) when you change your GPU.
          When the confirmation window appears, log out and in again (or reboot to be sure). Now reopen the NVIDIA X
          Server Settings, and you should see less options, and in the Prime profiles, the Intel GPU should be selected.
          """
        ]
    , p []
        [ text "All you have todo now is to "
        , a [ href "setup#setup-you-gpu-for-the-va-api" ] [ text "configure your Intel GPU for the VA-API" ]
        , text "."
        ]
    ]


nvidiaDiscrete : List (Html msg)
nvidiaDiscrete =
    [ p []
        [ h4 [] [ text "NVIDIA discrete GPU" ]
        ]
    , p []
        [ text """
          If you have only an NVIDIA GPU in your computer, you will need to patch your OS first to attempt to make the
          NVIDIA card work with Shadow.
          """
        ]
    , p []
        [ text "Check out the "
        , aBlank [ href "https://gitlab.com/aar642/libva-vdpau-driver" ]
            [ text "Arekinath's patch"
            ]
        , text "."
        ]
    , p []
        [ text "After patching, all you have to do now is to "
        ]
    , p []
        [ text "All you have todo now is to "
        , a [ href "setup#setup-you-gpu-for-the-va-api" ] [ text "check the specs of your GPU with the VA-API" ]
        , text "."
        ]
    ]


compositingIssue : Html Msg
compositingIssue =
    Article.article
        { title = "The compositing issue"
        , body =
            [ p []
                [ text """
                  When the stream starts, the application can kind of interfere with the transparent components.
                  This is actually a feature asked a long time ago by the Linux community.
                  """
                ]
            , p []
                [ text "The "
                , aBlank [ href "https://en.wikipedia.org/wiki/Compositing_window_manager#Linux" ] [ text "compositing" ]
                , text """
                  is a component that uses the GPU acceleration to bring some effects to the window manager.
                  But you are playing a video game, it is not necessary to loose performance for effects you're not
                  supposed to see. So, when an application uses intensively the GPU, the window manager stops the
                  compositing, so the transparent effects.
                  """
                ]
            , p []
                [ text """
                On KDE, it is pretty easy to avoid this effect. In the general configuration, in the section "Window
                management", you add a "Window rule". Click on "New", and set the class of windows to "shadow". Then go
                to the "Appearence and corrections" tab and at the bottom, you will find an option called "Block the
                compositing". Check it, select "Force" and select "No". Now restart your application and Voilà!
                """
                ]
            ]
        }


drircIssue : Html Msg
drircIssue =
    Article.article
        { title = "The DRIRC fix"
        , body =
            [ p []
                [ img [ src "images/rgba_issue.jpg" ] []
                ]
            , p []
                [ text """
                  The AMD or Intel drivers may not be well configured for Shadow, especially about the bit range for the
                  colors . A quick fix is to configure properly the drivers by executing the following command:
                  """
                ]
            , p []
                [ code []
                    [ text "sudo curl https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/resources/drirc -o /etc/drirc"
                    ]
                ]
            , p []
                [ strong [] [ text "Be carefull! " ]
                , text "this is a "
                , code [] [ text "sudo" ]
                , text " command, it is not harmless!"
                ]
            ]
        }


noSandboxIssue : Html Msg
noSandboxIssue =
    Article.article
        { title = "The No-Sandbox fix"
        , body =
            [ p []
                [ text "Due to a "
                , aBlank [ href "https://nicolasguilloux.github.io/blade-shadow-beta/issues.html" ] [ text "Debian bug" ]
                , text ", the AppImage may not launch the application. To fix this quickly, start the application with the "
                , code [] [ text "--no-sandbox" ]
                , text " parameter."
                ]
            , p []
                [ text "Another solution to fix it during time is to let the user create a sandbox for the application. 2 ways of doing it:"
                ]
            , p []
                [ ul []
                    [ li []
                        [ code [] [ text "sudo sysctl -w kernel.unprivileged_userns_clone=1" ]
                        ]
                    , li []
                        [ code [] [ text "sudo sh -c 'echo \"kernel.unprivileged_userns_clone=1\" > /etc/sysctl.d/99-shadow.conf'" ]
                        ]
                    ]
                ]
            , p []
                [ strong [] [ text "Be carefull! " ]
                , text "this is a "
                , code [] [ text "sudo" ]
                , text " command, it is not harmless!"
                ]
            ]
        }
