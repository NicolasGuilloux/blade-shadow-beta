#!/bin/bash
# https://github.com/aquadzn
# ```bash check_driver.sh```


check_codec() {
    if $(vainfo |& grep -q -e "H265" -e "HEVC")
    then
        echo -e "\n- H265 / HEVC found."
    else
        echo -e "\nH265 or HEVC not found."
    fi

    if $(vainfo |& grep -q "H264")
    then
        echo -e "- H264 found."
    else
        echo -e "\nH264 not found.\nPlease generate a report with the following command:\n\t- curl https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/scripts/report.pl | perl"
    fi
}

nvidia() {
    echo -e "For NVIDIA users, you have 2 options:\n"
    echo -e "\t* Use the Nouveau driver and install the old NVIDIA firmware that provides support for the VA API."
    echo -e "\t* Use the Arekinath patch to provides VA API compatibility for recent NVIDIA cards."
}

DISTRO=$(cat /etc/*-release |& awk -F= '/^NAME/ { print $2 }' | sed 's/"//g')
case $DISTRO in
    "Ubuntu" | "Debian GNU/Linux")
        if ! type "vainfo" > /dev/null
        then
            sudo apt-get update && sudo apt-get install vainfo libva-glx2
        fi
        pilot=$(vainfo |& grep 'vainfo: Driver version:')
        if [[ $pilot == *"Intel"* ]]
        then
            sudo apt-get install i965-va-driver libvdpau-va-gl1 -y
            sudo sh -c "echo 'export VDPAU_DRIVER=va_gl' >> /etc/profile"
        elif [[ $pilot == *"Radeon"* ]]
        then
            sudo apt-get install mesa-va-drivers -y
        elif [[ $pilot == *"NVIDIA"* ]]
        then
            nvidia
        fi

        check_codec
        ;;
    "Arch Linux")
        if ! type "vainfo" > /dev/null
        then
            sudo pacman -S libsndio-61-compat libva-utils
        fi
        pilot=$(vainfo |& grep 'vainfo: Driver version:')
        if [[ $pilot == *"Intel"* ]]
        then
            sudo pacman -S libva-intel-driver
        elif [[ $pilot == *"Radeon"* ]]
        then
            sudo pacman -S libva-mesa-driver
        elif [[ $pilot == *"NVIDIA"* ]]
        then
            nvidia
        fi

        check_codec
        ;;
    "Solus Budgie")
        if ! type "vainfo" > /dev/null
        then
            sudo eopkg it libva-utils
        fi
        pilot=$(vainfo |& grep 'vainfo: Driver version:')
        if [[ $pilot == *"Intel"* ]]
        then
            sudo eopkg it libva-intel-driver
        elif [[ $pilot == *"NVIDIA"* ]]
        then
            nvidia
        fi

        check_codec
        ;;
    "Fedora")
        if ! type "vainfo" > /dev/null
        then
            sudo dnf install librtmp libva-intel-hybrid-driver libvdpau-va-gl
            sudo sh -c "echo 'export VDPAU_DRIVER=va_gl' >> /etc/profile"
        fi
        if [[ $pilot == *"NVIDIA"* ]]
        then
            nvidia
        fi

        check_codec
        ;;
esac
