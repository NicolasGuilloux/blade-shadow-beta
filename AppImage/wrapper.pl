#!/usr/bin/perl

# Autheur: Nicolas Guilloux
# Website: https://nicolasguilloux.eu/
# Email:   novares.x@gmail.com

use strict;
use warnings;

use File::Basename;
use POSIX qw(locale_h);
use locale;

# ----------- Translations ------------ #

my @fr = (
    "Vérification de compatibilité désactivée.",
    "Les anciens logs ont été supprimés.",
    "Ceci est une fonction de debug affichant une fausse erreur pour tester les notifications. Blip.",
    "Ceci est une fonction de debug affichant un faux avertissement pour tester les notifications. Blip.",

    "Votre carte graphique est de marque Nvidia. Ces cartes ne sont pas supportées par Shadow sur Linux. Il faut attendre une nouvelle version de l'application ou utiliser le chipset Intel.",
    "La commande 'vainfo' n'a pas été trouvée, le support H.264 et H.265 par votre carte graphique ne peut pas être vérifié. Installez 'vainfo' (Ubuntu, Linux Mint, Debian) ou 'libva-utils' (Arch, Solus) puis relancez l'application.",
    "Votre carte graphique ne supporte aucun encodage utilisé par Shadow. Vous devez changer votre carte graphique pour une compatible, ou vérifier vos drivers VA-API.",
    "Votre carte graphique ne supporte que le H.264. Vous ne pourrez pas utiliser le H.265 (HEVC).",
    "Votre carte graphique n'est pas reconnue par la librarie VA-API. Veuillez vérifiez vos drivers VA-API avec la commande 'vainfo'.",

    "Le programme a tenté d'ajouter l'utilisateur courant au groupe \"input\". Si vous avez entré le mot de passe administrateur, veuillez redémarrer votre ordinateur ou votre session pour appliquer le changement.",

    "Votre environnement de bureau n'utilise pas Xorg mais est identifié comme",
    "Veuillez changer l'environnement pour utiliser Xorg ou l'application ne pourra pas fonctionner.",

    "Les erreurs suivantes empêchent\nl'application Shadow de fonctionner",

    bold("Raccourcis") . "
    • lshift-rctrl-esc:      Quitter
    • lshift-rctrl-space:    Activer/désactiver le mode plein écran
    • lshift-rctrl-g:        Activer/désactiver la capture du clavier et de la souris
    • lshift-rctrl-h:        Activer/désactiver le Shadow Mode"
);

my @en = (
    "Bypassing the compatibility check.",
    "The old logs have been removed.",
    "This is a debug feature showing a fake error to test notifications. Blip.",
    "This is a debug feature showing a fake warning to test notifications. Blip.",

    "Your GPU brand is Nvidia. This brand is not supported by Shadow on Linux. You have to wait for a new release from Blade, or use your Intel GPU instead.",
    "'vainfo' not found, H.264 and H.265 support by your GPU could not be checked. Install 'vainfo' (Ubuntu, Linux Mint, Debian) or 'libva-utils' (Arch, Solus) and restart the application.",
    "Your GPU does not support any encoding technology used by Shadow. You have to change you GPU or check your VA-API drivers to use this application.",
    "Your GPU supports only H.264. You will not be able to use H.265 (HEVC).",
    "Your GPU is not recognized. Please check your hardware decoding drivers with the 'vainfo' command.",

    "The program tried to add the current user to the \"input\" group. If you entered the administrator password, please reboot or restart your session to apply the change.",

    "Your environnement is not Xorg but is identified as",
    "Please switch to Xorg or you will not be able to start this application.",

    "The following errors prevented the\nShadow application from running",

    bold("Hotkeys") . "
    • lshift-rctrl-esc:      Exit
    • lshift-rctrl-space:    Toggle fullscreen or windowed
    • lshift-rctrl-g:        Toggle input grab
    • lshift-rctrl-h:        Toggle Shadow Mode"
);

my $locale = setlocale(LC_CTYPE);
my @lang = @en;

if( index($locale, 'fr') != -1 ) {
    @lang = @fr;
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
    --opt-launch       Start shadow-beta in the same directory of the wrapper
    --clientsdl        Directly launch the ClientSDL renderer

    --error            Show a fake error notification
    --warning          Show a fake warning notification
    --debug            Clear the previous log file and display the new one when the launcher is closed
    --strace           Launch the application with 'strace -f' and save the result to /var/tmp/strace_shadowbeta";

# Debug, errors and warnings
my $debug  = 0;
my $strace = 0;
my $opt    = 0;

my @errors = ();
my @warnings = ();


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
        push @warnings, $lang[0];
        goto START_SHADOW;
    }

    # Start the Shadow launcher from the /opt/Shadow Beta/shadow-beta
    if( $arg eq '--opt-launch' ) {
        $opt = 1;
    }

    # Start directly ClientSDl and stops
    if( $arg eq '--clientsdl' ) {
        system('./opt/Shadow\ Beta/resources/app.asar.unpacked/native/linux/ClientSDL');
        exit 0;
    }


    # Remove the previous logs file and display the new one when the launcher is closed
    if( $arg eq '--debug' ) {

        my $dirname = `dirname ~/.cache/blade/shadow/shadow.log`;
        chomp $dirname;

        if( -e "$dirname/shadow.log" ) {
            print "\n$lang[1]\n";
            `rm ~/.cache/blade/shadow/shadow.log`;
        }

        $debug = 1;
    }

    # Start Shadow with Strace
    if( $arg eq '--strace' ) {
        $strace = 1;
    }

    # Create a false error
    if( $arg eq '--error' ) {
        push @errors, $lang[2];
    }

    # Create a false warning
    if( $arg eq '--warning' ) {
        push @warnings, $lang[3];
    }

}

# -------- NVIDIA check -- #
if( `lspci -vnnn | perl -lne 'print if /^\\d+:.+([\\S+:\\S+])/' | grep "VGA controller" | grep -I NVIDIA` ne '' ) {
    push @errors, $lang[4];
}

# -------- Vainfo -------- #

if( -f '/usr/bin/vainfo' == 0 ) {
    push @warnings, $lang[5];

} else {
    my $vainfo = `vainfo`;

    if( $vainfo ne '' ) {
        # The GPU doesn't support H264.
        if( index($vainfo, 'H264') == -1 ) {
            push @errors, $lang[6];
        }

        if( index($vainfo, 'H265') == -1 and index($vainfo, 'HEVC') == 1 ) {
            push @warnings, $lang[7];
        }

    } else {
        push @errors, $lang[8];
    }
}


# -------- Input --------- #
my $groups = `groups \$USER`;

if( index($groups, 'input') == -1 ) {

    print "Adding the user to the input group\n";
    my $in = `pkexec gpasswd -a \$USER input`;

    push @errors, $lang[9];
}


# -------- Xorg check -------- #
my $env = `echo \$XDG_SESSION_TYPE`;
chomp $env;

if( $env ne 'x11' ) {
    push @errors,  "$lang[10] $env. $lang[11]";
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
    alert($lang[12], "\n$str");

    exit 1;

# Start Shadow
} else {
    print "$lang[13]\n\n";

    # Start Shadow with Strace
    if( $strace ) {
        system('strace -f ./opt/Shadow\ Beta/shadow-beta.wrapper &> /var/tmp/strace_shadowbeta');

    # Start the Shadow launcher from the /opt/Shadow Beta/shadow-beta
    } elsif( $opt ) {
        system('/opt/Shadow\ Beta/shadow-beta');

    # Start Shadow
    } else {
        system('./opt/Shadow\ Beta/shadow-beta.wrapper');
    }

    # Display the logs on launcher close
    if( $debug ) {
        my $logs = `cat ~/.cache/blade/shadow/shadow.log`;
        print "\n$logs\n";
    }

    exit 0;
}
