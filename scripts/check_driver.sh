#!/bin/bash
# https://github.com/aquadzn
# ```bash check_driver.sh```


check_h265_hevc() {
    if $(vainfo |& grep -q -E "VAProfile((H265|HEVC))")
    then
        true
    else
        false
    fi
}

check_h264() {
    if $(vainfo |& grep -q -E "VAProfileH264Main")
    then
        true
    else
        echo -e "❌ \e[91mH264 not found.\e[0m\nPlease generate a report with the following command:\n\t- curl https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/scripts/report.pl | perl"
        false
    fi
}


print_nvidia() {
    echo -e "For NVIDIA users, you have 2 options:\n"
    echo -e "\t* Use the Nouveau driver and install the old NVIDIA firmware that provides support for the VA API."
    echo -e "\t* Use the Arekinath patch to provides VA API compatibility for recent NVIDIA cards."
    echo -e "\t* https://gitlab.com/aar642/libva-vdpau-driver"
}


print_distro() {
    echo -e "✅ \e[32mFound $1.\e[0m"
}


print_vainfo_warning() {
    echo -e "❌ \e[91mvainfo not found.\e[0m\n"
    echo -e "⏸️  \e[93mNeed permission to install vainfo. Please re-run the script after installation.\e[0m\n"
    sleep 2
}

print_driver_warning() {
    echo -e "⏸️  \e[93mNeed permission to install driver(s).\e[0m\n"
    sleep 2
}


main() {
    echo -e "\n⚠️ \e[93mWarning\033[0m\nThis script will ask for sudo permission in order to install missings packages and/or drivers.\n"
    sleep 3

    DISTRO=$(cat /etc/*-release |& awk -F= '/^NAME/ { print $2 }' | sed 's/"//g')

    case $DISTRO in
        "Ubuntu" | "Debian GNU/Linux")
            print_distro $DISTRO
            if ! type "vainfo" > /dev/null 2>&1
            then
                print_vainfo_warning
                sudo apt-get install vainfo libva-glx2
                echo 
            else
                echo -e "✅ \e[32mFound vainfo.\e[0m\n"

                if [[ check_h264 ]] && [[ check_h265_hevc ]]
                then
                    echo -e "✅ \e[32mH264 found.\e[0m"
                    echo -e "✅ \e[32mH265 / HEVC found.\e[0m\n"
                    return
                fi
                if [[ ! check_h264 ]]
                then
                    echo -e "❌ \e[91mH264 not found.\e[0m\nPlease generate a report with the following command:\n\t- curl https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/scripts/report.pl | perl"
                fi
                if [[ ! check_h265_hevc ]]
                then
                    echo -e "❌ \e[91mH265 or HEVC not found.\e[0m"
                fi

                pilot=$(vainfo |& grep 'vainfo: Driver version:')
                print_driver_warning
                if [[ $pilot == *"Intel"* ]]
                then
                    sudo apt-get install i965-va-driver libvdpau-va-gl1
                    sudo sh -c "echo 'export VDPAU_DRIVER=va_gl' >> /etc/profile"
                elif [[ $pilot == *"Radeon"* ]]
                then
                    sudo apt-get install mesa-va-drivers
                elif [[ $pilot == *"NVIDIA"* ]]
                then
                    print_nvidia
                else
                    echo -e "❌ \e[91mPilot not found.\e[0m\n"
                fi
                return

            fi
            ;;
        "Arch Linux")
            print_distro $DISTRO
            if ! type "vainfo" > /dev/null 2>&1
            then
                print_vainfo_warning
                sudo pacman -S libsndio-61-compat libva-utils
            else
                echo -e "✅ \e[32mFound vainfo.\e[0m\n"

                if [[ check_h264 ]] && [[ check_h265_hevc ]]
                then
                    echo -e "✅ \e[32mH264 found.\e[0m"
                    echo -e "✅ \e[32mH265 / HEVC found.\e[0m\n"
                    return
                fi
                if [[ ! check_h264 ]]
                then
                    echo -e "❌ \e[91mH264 not found.\e[0m\nPlease generate a report with the following command:\n\t- curl https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/scripts/report.pl | perl"
                fi
                if [[ ! check_h265_hevc ]]
                then
                    echo -e "❌ \e[91mH265 or HEVC not found.\e[0m"
                fi
                
                pilot=$(vainfo |& grep 'vainfo: Driver version:')
                print_driver_warning
                if [[ $pilot == *"Intel"* ]]
                then
                    sudo pacman -S libva-intel-driver
                elif [[ $pilot == *"Radeon"* ]]
                then
                    sudo pacman -S libva-mesa-driver
                elif [[ $pilot == *"NVIDIA"* ]]
                then
                    print_nvidia
                else
                    echo -e "❌ \e[91mPilot not found.\e[0m\n"
                fi
                return

            fi
            ;;
        "Solus Budgie")
            print_distro $DISTRO
            if ! type "vainfo" > /dev/null 2>&1
            then
                print_vainfo_warning
                sudo eopkg it libva-utils
            else
                echo -e "✅ \e[32mFound vainfo.\e[0m\n"

                if [[ check_h264 ]] && [[ check_h265_hevc ]]
                then
                    echo -e "✅ \e[32mH264 found.\e[0m"
                    echo -e "✅ \e[32mH265 / HEVC found.\e[0m\n"
                    return
                fi
                if [[ ! check_h264 ]]
                then
                    echo -e "❌ \e[91mH264 not found.\e[0m\nPlease generate a report with the following command:\n\t- curl https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/scripts/report.pl | perl"
                fi
                if [[ ! check_h265_hevc ]]
                then
                    echo -e "❌ \e[91mH265 or HEVC not found.\e[0m"
                fi

                pilot=$(vainfo |& grep 'vainfo: Driver version:')
                print_driver_warning
                if [[ $pilot == *"Intel"* ]]
                then
                    sudo eopkg it libva-intel-driver
                elif [[ $pilot == *"NVIDIA"* ]]
                then
                    print_nvidia
                else
                    echo -e "❌ \e[91mPilot not found.\e[0m\n"
                fi
                return

            fi
            ;;
        "Fedora")
            print_distro $DISTRO
            if ! type "vainfo" > /dev/null 2>&1
            then
                print_vainfo_warning
                sudo dnf install librtmp
            else
                echo -e "✅ \e[32mFound vainfo.\e[0m\n"

                if [[ check_h264 ]] && [[ check_h265_hevc ]]
                then
                    echo -e "✅ \e[32mH264 found.\e[0m"
                    echo -e "✅ \e[32mH265 / HEVC found.\e[0m\n"
                    return
                fi
                if [[ ! check_h264 ]]
                then
                    echo -e "❌ \e[91mH264 not found.\e[0m\nPlease generate a report with the following command:\n\t- curl https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/scripts/report.pl | perl"
                fi
                if [[ ! check_h265_hevc ]]
                then
                    echo -e "❌ \e[91mH265 or HEVC not found.\e[0m"
                fi

                pilot=$(vainfo |& grep 'vainfo: Driver version:')
                print_driver_warning
                if [[ $pilot == *"Intel"* ]]
                then
                    sudo dnf install libva-intel-hybrid-driver libvdpau-va-gl
                    sudo sh -c "echo 'export LIBVA_DRIVER_NAME=i965' >> /etc/profile"
                elif [[ $pilot == *"NVIDIA"* ]]
                then
                    print_nvidia
                else
                    echo -e "❌ \e[91mPilot not found.\e[0m\n"
                fi
                return

            fi
            ;;
        *)
            echo -e "❌ \e[91mDistribution not found. Please try again.\e[0m\n"
            return
            ;;
    esac
}

main
