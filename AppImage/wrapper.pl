#!/usr/bin/perl

# Autheur: Nicolas Guilloux
# Website: https://nicolasguilloux.eu/
# Email:   novares.x@gmail.com

use strict;
use warnings;

use File::Basename;
use POSIX qw(locale_h);
use locale;

use version;

use Cwd 'abs_path';
use File::Basename;

# ------ Exit if the user is root ------- #
if( $> == 0 ) {
    print "Please do not launch this application with the super administrator account.\n\n";
    exit 1;
}

# ----------- Translations ------------ #

my %fr = (
    'bypass'            => "Vérification de compatibilité désactivée.",

    'fake-error'        => "Ceci est une fonction de debug affichant une fausse erreur pour tester les notifications. Blip.",
    'fake-warning'      => "Ceci est une fonction de debug affichant un faux avertissement pour tester les notifications. Blip.",

    'lang-en'           => "Langage forcé en anglais (en_US)",
    'lang-de'           => "Langage forcé en allemand (de_DE)",
    'lang-fr'           => "Langage forcé en français (fr_FR)",

    'vainfo-nvidia'     => "Votre carte graphique est de marque Nvidia. Ces cartes ne sont pas supportées par Shadow sur Linux. Il faut attendre une nouvelle version de l'application.",
    'vainfo-optimus'    => "Votre GPU est NVIDIA. L'application ne peut pas fonctionner sur ce GPU. Néanmoins, vous disposez de la technologie Optimus. Lancez le panneau de controle NVIDIA, allez dans la rubrique Prime profiles, choisissez le GPU Intel et relancez votre session.",
    'vainfo-missing'    => "La commande 'vainfo' n'a pas été trouvée, le support H.264 et H.265 par votre carte graphique ne peut pas être vérifié. Installez 'vainfo' (Ubuntu, Linux Mint, Debian) ou 'libva-utils' (Arch, Solus) puis relancez l'application.",
    'vainfo-bad'        => "Votre carte graphique ne supporte aucun encodage utilisé par Shadow. Vous devez changer votre carte graphique pour une compatible, ou vérifier vos drivers VA-API.",
    'vainfo-good'       => "Votre carte graphique ne supporte que le H.264. Vous ne pourrez pas utiliser le H.265 (HEVC).",
    'vainfo-fail'       => "Votre carte graphique n'est pas reconnue par la librarie VA-API. Veuillez vérifiez vos drivers VA-API avec la commande 'vainfo'.",

    'input-adding'      => "Ajout de l'utilisateur actuel au groupe input.",
    'input-added'       => "Le programme a tenté d'ajouter l'utilisateur courant au groupe \"input\". Si vous avez entré le mot de passe administrateur, veuillez redémarrer votre ordinateur ou votre session pour appliquer le changement.",

    'xorg-fail'         => "Votre environnement de bureau n'utilise pas Xorg mais est identifié comme",
    'xorg-fail2'        => "Veuillez changer l'environnement pour utiliser Xorg ou l'application ne pourra pas fonctionner.",
    'xorg-empty'        => "Impossible de vérifier si vous êtes bien sur Xorg.",

    'errors'            => "Les erreurs suivantes empêchent\nl'application Shadow de fonctionner",

    'hotkeys'           => bold("Raccourcis") . "
    • lshift-rctrl-esc:      Quitter
    • lshift-rctrl-space:    Activer/désactiver le mode plein écran
    • lshift-rctrl-g:        Activer/désactiver la capture du clavier et de la souris
    • lshift-rctrl-h:        Activer/désactiver le Shadow Mode"
);

my %en = (
    'bypass'            => "Bypassing the compatibility check.",

    'fake-error'      => "This is a debug feature showing a fake error to test notifications. Blip.",
    'fake-warning'        => "This is a debug feature showing a fake warning to test notifications. Blip.",

    'lang-en'           => "Language forced in english (en_US)",
    'lang-de'           => "Language forced in german (de_DE)",
    'lang-fr'           => "Language forced in french (fr_FR)",

    'vainfo-nvidia'     => "Your GPU brand is Nvidia. This brand is not supported by Shadow on Linux. You have to wait for a new release from Blade.",
    'vainfo-optimus'    => "Your currently using the NVIDIA GPU. You can't start the application with it, but your computer supports Prime. Start the NVIDIA control panel, select the Prime panel, choose the Intel GPU and restart your session.",
    'vainfo-missing'    => "'vainfo' not found, H.264 and H.265 support by your GPU could not be checked. Install 'vainfo' (Ubuntu, Linux Mint, Debian) or 'libva-utils' (Arch, Solus) and restart the application.",
    'vainfo-bad'        => "Your GPU does not support any encoding technology used by Shadow. You have to change you GPU or check your VA-API drivers to use this application.",
    'vainfo-good'       => "Your GPU supports only H.264. You will not be able to use H.265 (HEVC).",
    'vainfo-fail'       => "Your GPU is not recognized. Please check your hardware decoding drivers with the 'vainfo' command.",

    'input-adding'      => "Adding the current user to the input group.",
    'input-added'       => "The program tried to add the current user to the \"input\" group. If you entered the administrator password, please reboot or restart your session to apply the change.",

    'xorg-fail'         => "Your environnement is not Xorg but is identified as",
    'xorg-fail2'        => "Please switch to Xorg or you will not be able to start this application.",
    'xorg-empty'        => "Impossible to check if you are on Xorg or not.",

    'errors'            => "The following errors prevented the\nShadow application from running",

    'hotkeys'           => bold("Hotkeys") . "
    • lshift-rctrl-esc:      Exit
    • lshift-rctrl-space:    Toggle fullscreen or windowed
    • lshift-rctrl-g:        Toggle input grab
    • lshift-rctrl-h:        Toggle Shadow Mode"
);

my $locale = setlocale(LC_CTYPE);
my %lang = %en;

if( index($locale, 'fr') != -1 ) {
    %lang = %fr;
}



# ----------- Functions ------------ #

# Create a notification
#
# @param String Title
# @param String Content
# @param Bool   (Optional) Question notification
sub alert {
    if( -f "/usr/bin/notify-send" ) {
        my $command = "notify-send \"$_[0]\" \"$_[1]\" -u critical -i shadow-beta";
        exec($command);
    }
}

###
# Display in bold
#
# @param Input string
#
# @return Bold formated string
sub bold {
    return "\033[1m$_[0]\033[0m";
}

# ----------- Variables ------------ #

# Messages variables
my $help = "Wrapper for Shadow Beta that checks your configuration and compatibility errors.

Usage: shadowbeta-linux-x86_64.AppImage [OPTIONS]
    --help             Show this help
    --bypass-check     Bypass the compatibility check and directly run the Shadow launcher
    --clientsdl        Directly launch the ClientSDL renderer

    --force-en         Force the launcher in english for people with translation issues (en_US)
    --force-de         Force the launcher in german for people with translation issues (de_DE)
    --force-fr         Force the launcher in french for people with translation issues (fr_FR)

    --error            Show a fake error notification
    --warning          Show a fake warning notification
    --strace           Launch the application with 'strace -f' and save the result to /var/tmp/strace_shadowbeta
    --report           Upload a report of the configuration";

# Debug, errors and warnings
my $debug  = 0;
my $strace = 0;
my $langF  = '';

my $isAppImg = 0;
my @errors = ();
my @warnings = ();

# -------- Update -------- #
if( -d 'opt' ) {
    # AppImage detection
    $isAppImg = 1;
    print "AppImage detected.\n";

    if( -f 'shadow-appimage-version' ) {

        # Local version
        open(my $fh, '<:encoding(UTF-8)', 'shadow-appimage-version')
          or die "Could not open file 'shadow-appimage-version' $!";
        my $localVersion = <$fh>;
        chomp $localVersion;

        $help = "AppImage $localVersion. " . $help;

        if( substr($localVersion, 0, 1) eq 'v' ) {
            # Distant version
            my $distantVersion = `curl https://gitlab.com/api/v4/projects/7962701/repository/tags | jq -r -c 'map(select(.release!=null))|.[0]|.["release"]|.["tag_name"]'`;
            chomp $distantVersion;

            # Update available
            if( version->parse($localVersion) < version->parse($distantVersion) ) {
                print "\nNEW UPDATE AVAILABLE: $distantVersion\n";
                alert('New version of the AppImage', "\nA new version of the AppImage is available on the server ($distantVersion)\n");
            }
        }

    }
}

# -------- Arguments -------- #
for(my $i=0; $i < $#ARGV+1; $i++) {
    my $arg = $ARGV[$i];

    # Display help and stop the program
    if( $arg eq '--help' ) {
        print "\n$help\n\n";
        exit;
    }

    # Bypass the check and launch
    if( $arg eq '--bypass-check' ) {
        push @warnings, $lang{'bypass'};
        goto START_SHADOW;
    }

    # Start directly ClientSDL and stops
    if( $arg eq '--clientsdl' ) {
        if( $isAppImg ) {
            system('./opt/Shadow\ Beta/resources/app.asar.unpacked/native/linux/ClientSDL');
        } else {
            system('/opt/Shadow\ Beta/resources/app.asar.unpacked/native/linux/ClientSDL');
        }

        exit 0;
    }


    # Force the launcher in english
    if( $arg eq '--force-en' ) {
        $langF = 'LANG=en_US.utf8 ';
        push @warnings, $lang{'lang-en'}
    }

    # Force the launcher in german
    if( $arg eq '--force-de' ) {
        $langF = 'LANG=de_DE.utf8 ';
        push @warnings, $lang{'lang-de'}
    }

    # Force the launcher in english
    if( $arg eq '--force-fr' ) {
        $langF = 'LANG=fr_FR.utf8 ';
        push @warnings, $lang{'lang-fr'}
    }


    # Start Shadow with Strace
    if( $arg eq '--strace' ) {
        $strace = 1;
    }

    # Create a false error
    if( $arg eq '--error' ) {
        push @errors, $lang{'fake-error'};
    }

    # Create a false warning
    if( $arg eq '--warning' ) {
        push @warnings, $lang{'fake-warning'};
    }

    # Upload a report of the configuration
    if( $arg eq '--report' ) {
        if( $isAppImg ) {
            system( './report.pl --appimage');

        } else {
            system( '"' . dirname(abs_path($0)) . '/report.pl"');
        }

        exit 0;
    }

}


# -------- NVIDIA check -------- #
if( index(`lspci | grep 'VGA'`, 'NVIDIA') != -1 ) {

    # Intel iGPU detected
    if( index(`lspci | grep 'VGA'`, 'Intel') != -1 ) {

        # Currently on the NVIDIA GPU
        if( index(`nvidia-smi -L`, 'GPU ') != 1 ) {
            push @errors, $lang{'vainfo-optimus'};
        }

    # Only NVIDIA GPU available
    } else {
        push @errors, $lang{'vainfo-nvidia'};
    }
}

# -------- Vainfo -------- #
if( -f '/usr/bin/vainfo' ) {
    my $vainfo = `vainfo`;

    if( $vainfo ne '' ) {
        # The GPU doesn't support H264.
        if( index($vainfo, 'H264') == -1 ) {
            push @errors, $lang{'vainfo-bad'};
        }

        if( index($vainfo, 'H265') == -1 and index($vainfo, 'HEVC') == 1 ) {
            push @warnings, $lang{'vainfo-good'};
        }

    } else {
        push @errors, $lang{'vainfo-fail'};
    }

} else {
    push @warnings, $lang{'vainfo-missing'};
}


# -------- Input --------- #
my $groups = `groups \$USER`;

if( index($groups, 'input') == -1 ) {

    print "$lang{'input-adding'}\n";
    my $in = `pkexec gpasswd -a \$USER input`;

    push @errors, $lang{'input-added'};
}


# -------- Xorg check -------- #
my $env = `echo \$XDG_SESSION_TYPE`;
chomp $env;

if( $env ne 'x11') {
    if( $env ne '' ) {
        push @errors,  "$lang{'xorg-fail'} $env. $lang{'xorg-fail2'}";

    } else {
        push @warnings, $lang{'xorg-empty'}
    }

}


# -------- Kill ClientSDL ------ #
while( `pkill -e ClientSDL` ne '' ) {}


# -------- Start Shadow -------- #
START_SHADOW:
print "\n";

# Warnings
if( scalar @warnings > 0 ) {
    print bold('WARNING') . ":\n";
    foreach my $i (0 .. $#warnings) {
        print " • $warnings[$i]\n";
    }
    print "\n";
}

# Display errors
if( scalar @errors > 0 ) {

    my $str = "";
    foreach my $i (0 .. $#errors) {
        $str .= " • $errors[$i]\n";
    }

    print bold('ERROR') . ":\n$str\n";
    alert($lang{'errors'}, "\n$str");

    exit 1;

# Start Shadow
} else {
    print "$lang{'hotkeys'}\n\n";

    my $pathExec = '/opt/Shadow\ Beta/shadow-beta';

    if( $isAppImg ) {
        $pathExec = './opt/Shadow\ Beta/shadow-beta.wrapper';
    }

    # Start Shadow with Strace
    if( $strace ) {
        system("$langF strace -f $pathExec &> /var/tmp/strace_shadowbeta");

    # Start Shadow
    } else {
        system("$langF $pathExec");
    }

    exit 0;
}
