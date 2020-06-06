module Pages.Tweaks.View exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (..)
import Libs.Tailwind as TW
import Pages.Tweaks.Update exposing (Model, Msg(..))
import Template.Article as Article
import Template.Elements exposing (..)
import Template.Molecules exposing (..)
import Template.Section as Section


view : Model -> List (Html Msg)
view _ =
    [ abstract
    , mountShadow
    , forwardUsb
    ]


abstract : Html Msg
abstract =
    Section.section
        { title = "Known issues"
        , body =
            [ p []
                [ text """
                  On Linux, a lot of scripts and tweaks can be designed, especially to integrate and interact with
                  distant computers like your Shadow. This page provides some tutorials made by the community to
                  integrate your Shadow in your favorite system.
                  """
                ]
            , div [ TW.textCenter, TW.mt12 ]
                [ a [ href "#mount-your-shadow-in-your-filesystem" ] [ text "Mount your Shadow in your filesystem" ]
                , br [] []
                , a [ href "#forward-usb-devices-directly-in-your-shadow" ] [ text "Forward USB devices directly in your Shadow" ]
                ]
            ]
        }


mountShadow : Html Msg
mountShadow =
    Article.article
        { title = "Mount your Shadow in your filesystem"
        , body =
            [ p []
                [ text """
                    Linux is very efficient to mount distant filesystem in your local one, providing a seemlessly
                    integration in your favorite file browser. For this tutorial,
                    """
                , aBlank [ href "https://www.zerotier.com/" ] [ text "ZeroTier" ]
                , text " and "
                , aBlank [ href "https://en.wikipedia.org/wiki/Samba_(software)" ] [ text "Samba" ]
                , text " will be used."
                ]
            , p []
                [ h4 [] [ text "Explanations" ]
                ]
            , p []
                [ text """
                    Samba is a Linux effort to support the SMB protocol, proprietary protocol of Microsoft for Windows.
                    We use this protocol as it is already implemented in Windows and do not need an additional server.
                    SMB is mainly designed for local sharing.
                    """
                ]
            , p []
                [ text """
                    This is where ZeroTier becomes handy. It will create a VPN tunnel between all members of the network.
                    This network can be compared to a local network where all computers are linked together through a
                    secured tunnel. So, with this network, we can seemlessly use the SMB protocol!
                    """
                ]
            , p []
                [ h4 [] [ text "ZeroTier setup" ]
                ]
            , p []
                [ text "First things first, we need to install ZeroTier. To do so, create your account "
                , aBlank [ href "https://my.zerotier.com/login" ] [ text "here" ]
                , text ", follow the instruction of the "
                , aBlank [ href "https://www.zerotier.com/download/" ] [ text "download page" ]
                , text " and create your own network. "
                ]
            , p []
                [ text """
                    Both your Linux desktop and Shadow should have the ZeroTier client installed now, and they should both
                    have join the same network. Checkout the
                    """
                , aBlank [ href "https://my.zerotier.com/network" ] [ text "network tab" ]
                , text " to find the IP address of your Shadow. This will be useful."
                ]
            , p [ TW.my4 ]
                [ img [ src "images/zerotier_network.png", TW.roundedLg ] []
                ]
            , p []
                [ h4 [] [ text "Sharing setup" ]
                ]
            , p []
                [ text """
                    Your computers are now on the same network, we can start the SMB configuration.
                    The first step will be to create a dedicated user with a password for the share to separate the
                    share from your administrator account.
                    """
                ]
            , p []
                [ text """
                    Go into the parameters, select Accounts, Family and other users and finally, click on "Add a new user".
                    Please consider for security to make this account non administrator.
                    Set a simple user name (all lower case to fit the UNIX standard) and a password.
                    For this tutorial, we consider that the user is
                    """
                , code [] [ text "nover" ]
                , text ". Please change them to the one you actually typed."
                ]
            , p []
                [ text """
                    Now we need to allow the share for Windows. It sounds scary but we will use commands on Windows...
                    Open a terminal on your Shadow by searching "cmd" and right click on the result, execute as
                    Administrator. When openned, type the following commands:
                    """
                ]
            , p []
                [ codeBlock []
                    [ text "netsh advfirewall firewall set rule group=\"File and Printer Sharing\" new enable=Yes"
                    , br [] []
                    , text "netsh advfirewall firewall set rule group=\"Network Discovery\" new enable=Yes"
                    ]
                ]
            , p []
                [ text """
                    Right click on the folder you want to share and click on parameters. For the next screen, I chose
                    to share the whole user folder called "Nicolas Guilloux". Under the "Share" tab, click on
                    "Advanced share". Check the checkbox to share it, give it a pretty name if you want and then click
                    Authorizations. My advice is to remove all users already present in the window, especially "All".
                    Then click on "Add", type
                    """
                , code [] [ text "nover" ]
                , text """
                    , click on verify and then validate. You can manage specific rights for specific users, I chose to
                    give a full access to my user. You can now close all windows by clicking on "OK".
                    """
                ]
            , p []
                [ img [ src "images/share_folder.png", TW.roundedLg ] []
                ]
            , p []
                [ text """
                    Back on your Linux, install Samba and start your favorite file browser. Get the IP of your Shadow
                    from Hamachi too. You can now access to your share by going to
                    """
                , code [] [ text "smb://ZEROTIER_IP_ADDRESS" ]
                , text " and entering the share user and his password. On Dolphin, you can add a shortcut for instance under Network."
                ]
            , p []
                [ img [ src "images/dolphin_share.png", TW.roundedLg ] []
                ]
            ]
        }


forwardUsb : Html Msg
forwardUsb =
    Article.article
        { title = "Forward USB devices directly in your Shadow"
        , body =
            [ p []
                [ aBlank [ href "https://www.virtualhere.com/" ] [ text "VirtualHere" ]
                , text """
                         will use the technology "USB Over IP" coded in the Linux Kernel to mount an USB device on the
                         client computer whatever the OS. It was designed for a local network or, at least, a secured
                         network. It uses the port 7575 and work really well in a local network.
                        """
                , br [] []
                , text "Openning the port 7575 of your box to forward VirtualHere to the outside world is "
                , strong [] [ text "very very very dangerous" ]
                , text """
                        . You litterally open your computer to anybody, and then can have a full access to your
                        peripherals (like your webcam) or damage your computer. Please, do not do this.
                        """
                ]
            , p []
                [ text "A way to bring Shadow inside your local network is to use "
                , aBlank [ href "https://www.zerotier.com/" ] [ text "ZeroTier" ]
                , text """
                    . It creates a private tunnel between every members of your network using the VPN technology. It's
                    safe, it's pretty low latency and easy to use. Moreover, as you will be on a "local" (secured
                    is more appropriated) network with your Shadow, you will be able to use VirtualHere.
                    """
                ]
            , p []
                [ h4 [] [ text "Setup" ]
                ]
            , p []
                [ text """
                    Now, let's install it, shall we? We will consider that the computer where the gamepad is plugged
                    is a Linux. But keep in mind that you can for instance plug a device on your Raspberry Pi and
                    forward this device to your Shadow asweel, it's magic! We will also that the "client" will be a
                    Shadow, so on Windows.
                    """
                ]
            , p []
                [ text "First, we will install "
                , strong [] [ text "VirtualHere" ]
                , text """
                    . On Linux, it is very straighforward as the Linux kernel already have this technology. Open a
                    terminal, move where you want to put the one-file software and then, execute the following code.
                    The URL may vary if you use a ARM devide like a Raspberry Pi for instance.
                    """
                ]
            , p []
                [ codeBlock []
                    [ text "wget https://www.virtualhere.com/sites/default/files/usbserver/vhusbdx86_64"
                    , br [] []
                    , text "chmod +x ./vhusbdx86_64"
                    , br [] []
                    , text "sudo ./vhusbdx86_64 -b"
                    ]
                ]
            ]
        }
