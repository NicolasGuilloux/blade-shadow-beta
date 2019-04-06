#!/usr/bin/perl

# Autheur: Nicolas Guilloux
# Website: https://nicolasguilloux.eu/
# Email:   novares.x@gmail.com

# Thanks Kabouik for his help for the english translations
# Thanks Brother/Ilya#0013 and TheWolf#0985 for their help for the german translations

use strict;
use warnings;

use File::Basename;
use POSIX qw(locale_h);
use locale;

use Cwd 'abs_path';
use File::Basename;

# ----------- Translations ------------ #

my %fr = (
    'bypass'            => "Vérification de compatibilité désactivée.",

    'fake-error'        => "Ceci est une fonction de debug affichant une fausse erreur pour tester les notifications. Blip.",
    'fake-warning'      => "Ceci est une fonction de debug affichant un faux avertissement pour tester les notifications. Blip.",
    'strace-missing'    => "Strace n'est pas installé sur votre machine, veuillez l'installer pour utiliser cette option.",

    'lang-en'           => "Langage forcé en anglais (en_US)",
    'lang-de'           => "Langage forcé en allemand (de_DE)",
    'lang-fr'           => "Langage forcé en français (fr_FR)",

    'vainfo-optimus'    => "Votre GPU est NVIDIA. L'application ne peut pas fonctionner sur ce GPU. Néanmoins, vous disposez de la technologie Optimus. Lancez le panneau de controle NVIDIA, allez dans la rubrique Prime profiles, choisissez le GPU Intel et relancez votre session.",
    'vainfo-arekinath'  => "Votre carte est une NVIDIA de série 1000 ou plus. Si vous rencontrez des problèmes lors du démarrage du stream, il vous faudra probablement installer le patch d'Arekinath: https://gitlab.com/aar642/libva-vdpau-driver",
    'vainfo-nouveau'    => 'Votre carte est une NVIDIA de série inférieure à 1000. Nous vous recommandons de ne pas utiliser les drivers officiels de NVIDIA, et de choisir Nouveau à la place. Ensuite, vous pourrez installer le firmware NVIDIA qui tentera de rendre votre GPU compatible avec VA API (https://nouveau.freedesktop.org/wiki/VideoAcceleration/#firmware)',
    'vainfo-firmware'   => 'Votre carte est une NVIDIA de série inférieure à 1000 et vous utilisez le driver Nouveau. Nous vous conseillons d\'installer le firmware NVIDIA qui tentera de rendre votre GPU compatible avec VA API (https://nouveau.freedesktop.org/wiki/VideoAcceleration/#firmware)',

    'vainfo-missing'    => "La commande 'vainfo' n'a pas été trouvée, le support H.264 et H.265 par votre carte graphique ne peut pas être vérifié. Installez 'vainfo' (Ubuntu, Linux Mint, Debian) ou 'libva-utils' (Arch, Solus) puis relancez l'application.",
    'vainfo-bad'        => "Votre carte graphique ne supporte aucun encodage utilisé par Shadow. Vous devez changer votre carte graphique pour une compatible, ou vérifier vos drivers VA-API.",
    'vainfo-good'       => "Votre carte graphique ne supporte que le H.264. N'activez pas le H.265 (HEVC) dans l'application.",
    'vainfo-fail'       => "Votre carte graphique n'est pas reconnue par la librarie VA-API. Veuillez vérifiez vos drivers VA-API avec la commande 'vainfo'.",

    'input-adding'      => "Ajout de l'utilisateur actuel au groupe input.",
    'input-added'       => "Le programme a tenté d'ajouter l'utilisateur courant au groupe \"input\". Si vous avez entré le mot de passe administrateur, veuillez redémarrer votre ordinateur ou votre session pour appliquer le changement.",

    'xorg-fail'         => "Votre environnement de bureau n'utilise pas Xorg mais est identifié comme",
    'xorg-fail2'        => "Veuillez changer l'environnement pour utiliser Xorg ou l'application ne pourra pas fonctionner.",
    'xorg-empty'        => "Impossible de vérifier si vous êtes bien sur Xorg.",

    'errors'            => "Les erreurs suivantes empêchent\nl'application Shadow de fonctionner",

    'website'           => "Le site de la communauté Shadow Linux",

    'hotkeys'           => bold("Raccourcis") . "
    • lShift-lCtrl-Esc      Ouvre le gestionnaire de tâches de Windows
    • lShift-lCtrl-Q        Arrête le stream
    • lShift-lCtrl-F        Activer/désactiver le mode plein écran
    • lShift-lCtrl-G        Activer/désactiver la capture du clavier et de la souris\n\n"

 . bold('Notes') . ":
    • Le H265 ne s'active malheureusement pas au lancement du stream. Vérifiez dans l'application Shadow Control Panel sur votre Shadow s'il est bien activé.
    • Certains périphériques font planter le stream. Lors de la première installation, veillez à n'avoir que le strict minimum de brancher. Ensuite, brancher un à un chaque périphérique pour identifier si il y en a un qui provoque un crash."
);

my %en = (
    'bypass'            => "Bypassing the compatibility check.",

    'fake-error'        => "This is a debug feature showing a fake error to test notifications. Blip.",
    'fake-warning'      => "This is a debug feature showing a fake warning to test notifications. Blip.",
    'strace-missing'    => "Strace is not installed on your computer, please install it before using this parameter.",

    'lang-en'           => "Language forced in english (en_US)",
    'lang-de'           => "Language forced in german (de_DE)",
    'lang-fr'           => "Language forced in french (fr_FR)",

    'vainfo-optimus'    => "Your currently using the NVIDIA GPU. You can't start the application with it, but your computer supports Prime. Start the NVIDIA control panel, select the Prime panel, choose the Intel GPU and restart your session.",
    'vainfo-arekinath'  => "Your GPU brand is NVIDIA with the 1000 serie or more. If you experience issues while starting the stream, please consider to use the patch made by Arekinath: https://gitlab.com/aar642/libva-vdpau-driver",
    'vainfo-nouveau'    => 'Your GPU brand is NVIDIA with less than the 1000 serie. We recommand you to use the Nouveau drivers instead of the NVIDIA drivers and install the NVIDIA firmware to attempt to improve VA API compatibility with your GPU (https://nouveau.freedesktop.org/wiki/VideoAcceleration/#firmware)',
    'vainfo-firmware'   => 'Your GPU brand is NVIDIA with less than the 1000 serie and you use the Nouveau drivers. We recommand your to install the NVIDIA firmware to attempt to improve VA API compatibility with your GPU (https://nouveau.freedesktop.org/wiki/VideoAcceleration/#firmware)',
    'vainfo-missing'    => "'vainfo' not found, H.264 and H.265 support by your GPU could not be checked. Install 'vainfo' (Ubuntu, Linux Mint, Debian) or 'libva-utils' (Arch, Solus) and restart the application.",
    'vainfo-bad'        => "Your GPU does not support any encoding technology used by Shadow. You have to change you GPU or check your VA-API drivers to use this application.",
    'vainfo-good'       => "Your GPU supports only H.264. Do not enable H.265 (HEVC) in the application.",
    'vainfo-fail'       => "Your GPU is not recognized. Please check your hardware decoding drivers with the 'vainfo' command.",


    'input-adding'      => "Adding the current user to the input group.",
    'input-added'       => "The program tried to add the current user to the \"input\" group. If you entered the administrator password, please reboot or restart your session to apply the change.",

    'xorg-fail'         => "Your environnement is not Xorg but is identified as",
    'xorg-fail2'        => "Please switch to Xorg or you will not be able to start this application.",
    'xorg-empty'        => "Impossible to check if you are on Xorg or not.",

    'errors'            => "The following errors prevented the\nShadow application from running",

    'website'           => "The website of the Shadow Linux community",

    'hotkeys'           => bold("Hotkeys") . "
    • lShift-lCtrl-Esc      Open the Windows task manager
    • lShift-lCtrl-Q        Stop the stream
    • lShift-lCtrl-F        Toggle fullscreen or windowed
    • lShift-lCtrl-G        Toggle input grab\n\n"

 . bold('Notes') . ":
    • The H265 option is not enabled when the stream starts. Please enable it from the Shadow Control Panel on your Shadow.
    • Some devices crash the stream. During the fisrt install, make sure your only have the minimum devices plugged. Then, plug them one by one to identify quickly which one produces an error."
);

my %de = (
    'bypass'            => "Umgehung der Kompatibilitätsprüfung.",

    'fake-error'        => "Dies ist eine Debug-Funktion, die einen gefälschten Fehler anzeigt, um Benachrichtigungen zu testen.",
    'fake-warning'      => "Dies ist eine Debug-Funktion, die eine gefälschte Warnung anzeigt, um Benachrichtigungen zu testen.",
    'strace-missing'    => "Strace ist nicht auf Ihrem Computer installiert, bitte installieren Sie es, bevor Sie diesen Parameter verwenden.",

    'lang-en'           => "Sprache erzwungen in english (en_US)",
    'lang-de'           => "Sprache erzwungen in german (de_DE)",
    'lang-fr'           => "Sprache erzwungen in french (fr_FR)",

    'vainfo-optimus'    => "Sie verwenden derzeit den NVIDIA Grafikprozessor. Sie können die Anwendung damit nicht starten, aber Ihr Computer unterstützt Prime. Starten Sie das NVIDIA Control Panel, wählen Sie das Prime Panel, wählen Sie den Intel Grafikprozessor und starten Sie Ihre Sitzung neu.",
    'vainfo-arekinath'  => "Ihre GPU-Marke ist NVIDIA mit der Serie 1000 oder mehr.. Wenn beim Starten des Streams Probleme auftreten, müssen Sie wahrscheinlich den Arekinath-Patch installieren: https://gitlab.com/aar642/libva-vdpau-driver",
    'vainfo-nouveau'    => 'Ihre Karte ist ein serielles NVIDIA mit weniger als 1000 Karten. Wir empfehlen Ihnen, nicht die offiziellen Treiber von NVIDIA zu verwenden und stattdessen Neu zu wählen. Anschließend können Sie die NVIDIA-Firmware installieren, die versucht, Ihren Grafikprozessor mit der VA-API kompatibel zu machen (https://nouveau.freedesktop.org/wiki/VideoAcceleration/#firmware)',
    'vainfo-firmware'   => 'Ihre Karte ist ein serielles NVIDIA unter 1000 und Sie verwenden den neuen Treiber. Wir empfehlen Ihnen, die NVIDIA-Firmware zu installieren, die versucht, Ihren Grafikprozessor mit der VA-API kompatibel zu machen (https://nouveau.freedesktop.org/wiki/VideoAcceleration/#firmware)',
    'vainfo-missing'    => "'vainfo' nicht gefunden werden, konnte die H.264- und H.265-Unterstützung durch Ihren Grafikprozessor nicht überprüft werden. Installieren Sie 'vainfo' (Ubuntu, Linux  Mint, Debian) oder 'libva-utils' (Arch, Solus) und starten Sie die Anwendung neu.",
    'vainfo-bad'        => "Ihr Grafikprozessor unterstützt keine von Shadow verwendete Kodierungstechnologie. Sie müssen Ihren Grafikprozessor wechseln oder Ihre VA-API-Treiber überprüfen, um diese Anwendung nutzen zu können.",
    'vainfo-good'       => "Ihr Grafikprozessor unterstützt nur H.264. Sie können H.265 (HEVC) nicht verwenden.",
    'vainfo-fail'       => "Ihre GPU wird nicht erkannt. Bitte überprüfen Sie Ihren Hardware-Dekodierungstreiber mit dem Befehl 'vainfo'.",

    'input-adding'      => "Füge den aktuellen Benutzer zur Eingabengruppe hinzu.",
    'input-added'       => "Das Programm hat versucht, den aktuellen Benutzer zur Gruppe \"input\" hinzuzufügen. Wenn Sie das Administratorkennwort eingegeben haben, starten Sie Ihre Sitzung neu, um die Änderung zu übernehmen.",

    'xorg-fail'         => "Die Umgebung wurde nicht als Xorg identifiziert, sondern als",
    'xorg-fail2'        => "Bitte wechseln Sie auf Xorg, ansonsten kann die Anwendung nicht gestartet werden.",
    'xorg-empty'        => "Es konnte nicht geprüft werden ob Xorg verwendet wird oder nicht.",

    'errors'            => " Folgende Fehler haben einen \nStart von Shadow verhindert",

    'website'           => "Shadow Linux Community Website",

    'hotkeys'           => bold("Tastenbelegung") . "
    • lShift-lCtrl-Esc      Öffnet den Windows Task-Manager
    • lShift-lCtrl-Q        Stoppen Sie den Stream
    • lShift-lCtrl-F        Wechsel Vollbild / Fenster
    • lShift-lCtrl-G        Eingaben fangen umschalten\n\n"

 . bold('Anmerkungen') . ":
    • Die H265-Option ist nicht aktiviert, wenn der Stream gestartet wird. Bitte aktiviere es über die Schatten-Kontrollleiste auf deinem Schatten.
    • Einige Geräte stürzen den Stream ab. Stellen Sie bei der ersten Installation sicher, dass nur die Mindestgeräte angeschlossen sind. Dann stecken Sie sie nacheinander ein, um schnell zu erkennen, welcher Fehler auftritt."
);

my $locale = setlocale(LC_CTYPE);
my %lang = %en;

if( index($locale, 'fr') != -1 ) {
    %lang = %fr;

} elsif( index($locale, 'de') != -1 ){
    %lang = %de;
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
my $help = "Configure your computer to launch the Shadow application

Usage: configure.pl [OPTIONS]
    --help             Show this help

    --force-en         Force english (en_US)
    --force-de         Force german (de_DE)
    --force-fr         Force french (fr_FR)

    --error            Show a fake error notification
    --warning          Show a fake warning notification
    --report           Upload a report of the configuration";

# Debug, errors and warnings
my $debug  = 0;
my $strace = 0;
my $langF  = '';

my @errors   = ();
my @warnings = ();

# ------ Display help ------- #
if( grep( /^--help/, @ARGV ) ) {
    print "\n$help\n\n";
    exit;
}

# -------- Arguments -------- #
for(my $i=0; $i < $#ARGV+1; $i++) {
    my $arg = $ARGV[$i];

    # Force the launcher in english
    if( $arg eq '--force-en' ) {
        $langF = 'LANG=en_US.utf8 ';
        %lang = %en;
        push @warnings, $lang{'lang-en'}
    }

    # Force the launcher in german
    if( $arg eq '--force-de' ) {
        $langF = 'LANG=de_DE.utf8 ';
        %lang = %de;
        push @warnings, $lang{'lang-de'}
    }

    # Force the launcher in french
    if( $arg eq '--force-fr' ) {
        $langF = 'LANG=fr_FR.utf8 ';
        %lang = %fr;
        push @warnings, $lang{'lang-fr'}
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
        system('curl https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/scripts/report.pl | perl');

        exit 0;
    }
}


# -------- NVIDIA check -------- #
my $lspci = `lspci | grep 'VGA'`;
if( index($lspci, 'NVIDIA') != -1 ) {

    # Intel iGPU detected
    if( index($lspci, 'Intel') != -1 ) {

        # Currently on the NVIDIA GPU
        if( index(`nvidia-smi -L`, 'GPU ') != 1 ) {
            push @warnings, $lang{'vainfo-optimus'};
        }

    # Only NVIDIA GPU available
    } else {
        my $gpu = `echo $lspci | grep 'GeForce GTX'`;
        $gpu = $gpu =~ s/.*?([0-9]{3,4}).*/$1/;

        # 1000 series
        if( $gpu > 1000 ) {
            if( index(`vainfo`, 'arekinath') != -1 ) {
                push @warnings, $lang{'vainfo-arekinath'};
            }

        } else {
            if( `lsmod | grep nouveau` eq '' ) {
                push @warnings, $lang{'vainfo-nouveau'};

            } else {
                push @warnings, $lang{'vainfo-firmware'};
            }

        }
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
        push @warnings, $lang{'vainfo-fail'};
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


# -------- Result -------- #
print "\n";

# Website
print bold( $lang{'website'} ) . ": https://nicolasguilloux.github.io/blade-shadow-beta\n\n";

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
}

# Display a message if everything is alright
if (scalar @warnings == 0 && scalar @errors == 0) {
    print "Everything is alright. You can use your Shadow on this machine ;)";
}

exit 0;
