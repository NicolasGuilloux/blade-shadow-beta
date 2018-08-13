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

my $errors = '',
my $errorsCount = 0;

# -------- Arguments -------- #
if( $#ARGV > -1 ) {

    if( $ARGV[0] eq '--help' ) {
        print "
Wrapper for Shadow Beta that check your configuration and errors.

Usage: wrapper.pl [OPTIONS]
  --help             provides help about the wrapper
  --bypass-check     bypass the check and directly launch shadow-beta\n";
        exit;
    }

    if( $ARGV[0] eq '--bypass-check' ) {
        goto START_SHADOW;
    }

    print $ARGV[0];
}

# -------- Vainfo -------- #
my $vainfo = `vainfo`;

if( $vainfo ne '' ) {
    # The GPU doesn't support H264.
    if( index($vainfo, 'H264') == -1 ) {
        $errors .= "• Your GPU does not support any encoding technology used by Shadow. You have to change you GPU or check your VA-API drivers to use this application.\n\n";
        $errorsCount++;
    }

    if( index($vainfo, 'H265') == -1 and index($vainfo, 'HEVC') == 1 ) {
        print "Your GPU supports only H264. Do not use H265.\n\n";
    }

} else {
    $errors .= "• Your GPU is not recognized. Please check the `vainfo` command.\n\n";
    $errorsCount++;
}



# -------- Input --------- #
my $groups = `groups \$USER`;

if( index($groups, 'input') == -1 ) {

    $errorsCount++;

    print 'Adding the user to the input group.';
    my $in = `pkexec gpasswd -a \$USER input`;

    $errors .= "• The program tried to add the user to the \"input\" group. If you entered the right administrator password, you should reboot to apply the changes. Otherwise, ask the administrator to enter it for you.\n\n";
}


# -------- Xorg check -------- #
my $env = `echo \$XDG_SESSION_TYPE`;
chomp $env;

if( $env ne 'x11' ) {
    $errors .= "• Your environnement is not Xorg but is identified as $env. Please switch to Xorg or you will not be able to start this application.";
    $errorsCount++;
}


# -------- Kill ClientSDL ------ #
while( `pkill -e ClientSDL` ne '' ) {}


# -------- Start Shadow -------- #
START_SHADOW:
if( $errorsCount > 0 ) {
    my $plurial = '';
    if( $errorsCount > 1) { $plurial = 's'; }

    print "$errorsCount error$plurial. The program can't continue.\n";
    alert("There is $errorsCount error" . $plurial, $errors);

} else {
    print "Start Shadow Beta\n";
    system('/opt/Shadow\ Beta/shadow-beta');
}
