#!/usr/bin/perl

# Autheur: Nicolas Guilloux
# Website: https://nicolasguilloux.eu/
# Email:   novares.x@gmail.com

use strict;
use warnings;

my $return = "Shadow Report\n";

# -------- AppImage version -------- #
if( -f 'shadow-appimage-version' ) {

    # Local version
    open(my $fh, '<:encoding(UTF-8)', 'shadow-appimage-version')
      or die "Could not open file 'shadow-appimage-version' $!";
    my $localVersion = <$fh>;
    chomp $localVersion;

    $return .= "AppImage $localVersion \n";
}

# -------- Distribution information -------- #
$return .= "\n-------------------------------------\n\n";
$return .= `cat /etc/*-release`;
$return .= "\n-------------------------------------\n\n";

# -------- Environment -------- #
$return .= 'Environment server: ' . `echo \$XDG_SESSION_TYPE`;
if( index(`groups \$USER`, 'input') == -1 ) {
    $return .= '/!\ The user is not in the "input" group.';
} else {
    $return .= 'The user is in the "input" group.';
}

# -------- Missing libraries -------- #
$return .= "\n\n-------------------------------------\n";
$return .= "          Missing libraries\n";
$return .= "-------------------------------------\n";

if( -f 'shadow-appimage-version' ) {
    $return .= `ldd -v "./opt/Shadow\ Beta/shadow-beta" | grep "not found"`;
    $return .= `ldd -v "./opt/Shadow\ Beta/resources/app.asar.unpacked/native/linux/ClientSDL" | grep "not found"`;

} else {
    $return .= `ldd -v "/opt/Shadow\ Beta/shadow-beta" | grep "not found"`;
    $return .= `ldd -v "/opt/Shadow\ Beta/resources/app.asar.unpacked/native/linux/ClientSDL" | grep "not found"`;
}

# -------- VA-API check -------- #
$return .= "\n-------------------------------------\n";
$return .= "               Vainfo\n";
$return .= "-------------------------------------\n";

$return .= `vainfo`;

# -------- Logs -------- #
$return .= "\n-------------------------------------\n";
$return .= "                Logs\n";
$return .= "-------------------------------------\n";

my @logs = split(/template_digit/, `cat ~/.cache/blade/shadow/shadow.log`);
$return .= 'template_digit' . $logs[-1];

# print $return;

# -------- Send to Pastebin -------- #
open(my $fh, '>', '/var/tmp/report_shadow');
print $fh $return;
close $fh;

my $key = `curl -sf --data-binary "@/var/tmp/report_shadow" https://hastebin.com/documents | jq .key | sed -e "s/\\\"//g"`;

print "\nThe report is available at this link: https://hastebin.com/$key\n";
