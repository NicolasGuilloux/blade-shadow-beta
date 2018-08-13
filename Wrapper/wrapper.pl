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

# Messages variables
my $help = "Wrapper for Shadow Beta that check your configuration and errors.

Usage: wrapper.pl [OPTIONS]
    --help             Provides help about the wrapper
    --bypass-check     Bypass the check and directly launch shadow-beta

    --error            Create a fake error message
    --warning          Create a fake warning message
    --debug            Removes the previous log file and display the new one when the launcher is closed";

my $hotkeys = "Hotkeys:
    • lshift-rctrl-esc: exit
    • lshift-rctrl-space: switch fullscreen
    • lshift-rctrl-g: toggle input grab
    • lshift-rctrl-h: toggle Shadow Mode\n";

# Debug, errors and warnings
my $debug = 0;
my @errors = ();
my @warnings = ();


# -------- Arguments -------- #
for(my $i=0; $i < $#ARGV+1; $i++) {
    my $arg = $ARGV[$i];

    if( $arg eq '--help' ) {
        print "\n$help\n\n";
        exit;
    }

    # Bypass the check and launch
    if( $arg eq '--bypass-check' ) {
        push @warnings, "Bypassing the check";
        goto START_SHADOW;
    }

    # Remove the previous logs file and display the new one when the launcher is closed
    if( $arg eq '--debug' ) {
        if( -f '~/.cache/blade/shadow/shadow.log' ) {
            `rm ~/.cache/blade/shadow/shadow.log`;
        }

        $debug = 1;
    }

    # Create a false error
    if( $arg eq '--error' ) {
        push @errors, "This is a debug feature to test the notification. It creates a fake error.";
    }

    # Create a false warning
    if( $arg eq '--warning' ) {
        push @warnings, "This is a debug feature. It creates a fake warning.";
    }
}

# -------- Vainfo -------- #

if( -f '/usr/bin/vainfo' == 0 ) {
    push @warnings, "vainfo is not installed, couldn't determine GPU capabilities, if you experience issues, please install it.";

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

if( $env ne 'x11' ) {
    push @errors,  "Your environnement is not Xorg but is identified as $env. Please switch to Xorg or you will not be able to start this application.";
}


# -------- Kill ClientSDL ------ #
while( `pkill -e ClientSDL` ne '' ) {}


# -------- Start Shadow -------- #
START_SHADOW:
print "\n";

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

    print "ERROR ! The program can't continue. $str: \n$str2\n";
    alert("$str detected", $str2);

    exit 1;

# Start Shadow
} else {
    print "$hotkeys\n";
    system('./opt/Shadow\ Beta/shadow-beta');

    if( $debug ) {
        my $logs = `cat ~/.cache/blade/shadow/shadow.log`;
        print "\n$logs\n";
    }

    exit 0;
}
