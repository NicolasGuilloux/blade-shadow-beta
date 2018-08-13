#!/usr/bin/perl

# Autheur: Nicolas Guilloux
# Website: https://nicolasguilloux.eu/
# Email:   novares.x@gmail.com

use strict;
use warnings;

# Create a notification
#
# @param String Title
# @param String Content
# @param Bool   (Optional) Question notification
sub alert {
    my $command = "notify-send '$_[0]' '$_[1]' -u critical -i shadow-beta";
    exec($command);
}

# Test variable
my $debug = 0;

# Messages variables
my $help = "
Wrapper for Shadow Beta that check your configuration and errors.

Usage: wrapper.pl [OPTIONS]
    --help             provides help about the wrapper
    --bypass-check     bypass the check and directly launch shadow-beta\n\n";

my $hotkeys = "Hotkeys:
    • lshift-rctrl-esc: exit
    • lshift-rctrl-space: switch fullscreen
    • lshift-rctrl-g: toggle input grab
    • lshift-rctrl-h: toggle Shadow Mode\n";

# Errors and warnings
my @errors = ();
my @warnings = ();

# -------- Arguments -------- #
for(my $i=0; $i < $#ARGV+1; $i++) {
    my $arg = $ARGV[$i];

    if( $arg eq '--help' ) {
        print $help;
        exit;
    }

    # Bypass the check and launch
    if( $arg eq '--bypass-check' ) {
        print "/!\\ Bypassing the check\n";
        goto START_SHADOW;
    }

    # Set the debug variable
    if( $arg eq '--debug' ) {
        $debug = 1;
    }
}

# -------- Vainfo -------- #

if( -f '/usr/bin/vainfo' == 0 ) {
    push @warnings, "vainfo is not installed, couldn't determine GPU capabilities, if you experience issues, please install it.\n";

} else {
    my $vainfo = `vainfo`;

    if( $vainfo ne '' ) {
        # The GPU doesn't support H264.
        if( index($vainfo, 'H264') == -1 ) {
            push @errors, "Your GPU does not support any encoding technology used by Shadow. You have to change you GPU or check your VA-API drivers to use this application.";
        }

        if( index($vainfo, 'H265') == -1 and index($vainfo, 'HEVC') == 1 ) {
            push @warnings, "Your GPU supports only H264. Do not use H265.\n\n";
        }

    } else {
        push @errors, "Your GPU is not recognized. Please check the `vainfo` command.";
    }
}


# -------- Input --------- #
my $groups = `groups \$USER`;

if( index($groups, 'input') == -1 ) {

    print "Adding the user to the input group\n";
    my $in = `pkexec gpasswd -a \$USER input`;

    push @errors, "The program tried to add the user to the \"input\" group. If you entered the right administrator password, you should reboot to apply the changes. Otherwise, ask the administrator to enter it for you.";
}


# -------- Xorg check -------- #
my $env = `echo \$XDG_SESSION_TYPE`;
chomp $env;

if( $env ne 'x11' or $debug ) {
    push @errors,  "Your environnement is not Xorg but is identified as $env. Please switch to Xorg or you will not be able to start this application.";
}


# -------- Kill ClientSDL ------ #
while( `pkill -e ClientSDL` ne '' ) {}


# -------- Start Shadow -------- #
START_SHADOW:

# Warnings
if( scalar @warnings > 0 ) {
    print "WARNING:\n";
    foreach my $i (0 .. $#warnings) {
        print "• $warnings[$i]\n";
    }
    print "\n";
}

# Display errors
if( scalar @errors > 0 ) {

    my $str = 'There is 1 error';
    if( scalar @errors > 1 ) { $str = 'There are ' . scalar @errors . ' errors'; }

    my $str2 = "";
    foreach my $i (0 .. $#errors) {
        $str2 .= "• $errors[$i]\n";
    }

    print "\nERROR ! The program can't continue. $str: \n$str2\n";
    alert("$str detected", $str2);

    exit 1;

# Start Shadow
} else {
    print "\n$hotkeys\n";
    system('./opt/Shadow\ Beta/shadow-beta');
    exit 0;
}
