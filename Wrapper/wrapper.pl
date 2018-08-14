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
    "Vérification non réalisée.",
    "Les anciens logs ont été supprimés.",
    "C'est une fonctionnalité de debug pour tester les notifications. Cela envoie une fausse erreur.",
    "C'est une fonctionnalité de debug. Cela envoie un faux Warning.",

    "Votre carte graphique est de la marque NVIDIA. Malheureusement, ces cartes ne sont pas supportées par Shadow sur Linux. Il faut attendre une nouvelle version de l'application.",
    "Le logiciel 'vainfo' n'est pas installé, les capacités de votre carte graphique ne peuvent être vérifiée. Installez 'vainfo' pour avoir une vérification complète.",
    "Votre carte graphique ne supporte aucun encodage utilisé par Shadow. Vous devez changer votre carte graphique pour une compatible, ou vérifier vos drivers VA-API.",
    "Votre carte graphique ne supporte que le H264. Vous ne pouvez pas utiliser le H265 (HEVC).",
    "Votre carte graphique n'est pas reconnu par la librarie VA-API. Veuillez vérifiez vos drivers VA-API avec la commande 'vainfo'.",

    "Le programme a tenté d'ajouter l'utilisateur courant dans le groupe \"input\". Si vous avez entré le bon mot de passe administrateur, veuillez redémarrer votre ordinateur pour appliquer les changements. Sinon, demandez à votre administrateur de le faire pour vous.",

    "Votre environnement de bureau n'utilise pas Xorg, il est reconnu comme",
    "Veuillez changer l'environnement pour utiliser Xorg ou l'application ne pourra pas se lancer.",

    "Les erreurs suivantes empêchent le Shadow de fonctionner",

    bold("Raccourcis") . "
    • lshift-rctrl-esc:      Quitter
    • lshift-rctrl-space:    Basculer en plein écran
    • lshift-rctrl-g:        Basculer la capture des entrées
    • lshift-rctrl-h:        Basculer en Shadow Mode"
);

my @en = (
    "Bypassing the check.",
    "The old logs has been removed.",
    "This is a debug feature to test the notification. It creates a fake error.",
    "This is a debug feature. It creates a fake warning.",

    "Your GPU brand is NVIDIA. Unfortunatelly, this brand is not yet supported by Shadow on Linux. You have to wait for a new release from Blade.",
    "vainfo is not installed, couldn't determine GPU capabilities, if you experience issues, please install it.",
    "Your GPU does not support any encoding technology used by Shadow. You have to change you GPU or check your VA-API drivers to use this application.",
    "Your GPU supports only H264. Do not use H265 (HEVC).",
    "Your GPU is not recognized. Please check the `vainfo` command.",

    "The program tried to add the user to the \"input\" group. If you entered the right administrator password, you should reboot to apply the changes. Otherwise, ask the administrator to enter it for you.",

    "Your environnement is not Xorg but is identified as",
    "Please switch to Xorg or you will not be able to start this application.",

    "The following errors block the Shadow application",

    bold("Hotkeys") . "
    • lshift-rctrl-esc:      Exit
    • lshift-rctrl-space:    Switch fullscreen
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
my $help = "Wrapper for Shadow Beta that check your configuration and errors.

Usage: " . basename($0) . " [OPTIONS]
    --help             Provides help about the wrapper
    --bypass-check     Bypass the check and directly launch shadow-beta
    --clientsdl        Launch directly ClientSDL
    --vainfo-appimage  Execute vainfo with the embedded VA library

    --error            Create a fake error message
    --warning          Create a fake warning message
    --debug            Removes the previous log file and display the new one when the launcher is closed
    --strace           Launch the app with strace -f and put the result in /var/tmp/strace_shadowbeta";

my $hotkeys = "Hotkeys:
    • lshift-rctrl-esc: exit
    • lshift-rctrl-space: switch fullscreen
    • lshift-rctrl-g: toggle input grab
    • lshift-rctrl-h: toggle Shadow Mode";

# Debug, errors and warnings
my $debug = 0;
my $strace = 0;

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

    # Start directly ClientSDl and stops
    if( $arg eq '--clientsdl' ) {
        system('./opt/Shadow\ Beta/resources/app.asar.unpacked/native/linux/ClientSDL');
        exit 0;
    }

    # Execute vainfo with the embedded VA library
    if( $arg eq '--vainfo-appimage' ) {
        system('./usr/bin/vainfo');
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
