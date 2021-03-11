#!/usr/bin/env perl

# Autheur: Nicolas Guilloux
# Website: https://nicolasguilloux.eu/
# Email:   novares.x@gmail.com

use strict;
use warnings;


# Send to Hostbin
#
# @param String Content
#
# @return String URL
sub share {
    open(my $fh, '>', '/tmp/report_shadow');
    print $fh $_[0];
    close $fh;

    print 'Sending the data to the server...';
    my $url = `curl -sf --data-binary "@/tmp/report_shadow" https://shadow.nicolasguilloux.eu/hostbin`;

    system('rm /tmp/report_shadow');

    return "Share the following link to get some help: $url";
}

# ------- Check application path ------- #
my $path = '/tmp/.mount_Shadow*';

if (! glob($path . '/shadow-preprod')) {
    $path = '/opt/shadowbeta';

    if (! -d "$path") {
        $path = "/opt/Shadow\\ Beta";

        if (! -d "/opt/Shadow Beta") {
            $path = '';
        }
    }
}

my $return = "Shadow Report\n";

if ($path ne '') {
    $return .= "\nRenderer version: " . `cat $path/resources/app.asar.unpacked/release/native/version.txt`;
}

# -------- Distribution information -------- #
$return .= "\n-------------------------------------\n\n";
$return .= `cat /etc/*-release`;
$return .= `uname -a`;
$return .= "\n-------------------------------------\n\n";

# -------- Environment -------- #
$return .= 'Environment server: ' . `echo \$XDG_SESSION_TYPE`;
$return .= 'Windows Manager: ' . `echo \$XDG_CURRENT_DESKTOP`;

# -------- Missing libraries -------- #
$return .= "\n\n-------------------------------------\n";
$return .= "          Missing libraries\n";
$return .= "-------------------------------------\n";

if ($path eq '') {
    $return .= 'No installation detected';
} else {
    $return .= `ldd -v $path/shadow-preprod | grep "not found"`;
    $return .= `ldd -v $path/resources/app.asar.unpacked/release/native/Shadow | grep "not found"`;
}

# -------- VA-API check -------- #
$return .= "\n-------------------------------------\n";
$return .= "                GPU\n";
$return .= "-------------------------------------\n";

$return .= "\nGPU detected:\n";
$return .= `lspci | grep VGA` . "\n";

if (-f '/usr/bin/vainfo') {
    $return .= `vainfo`;

} else {
    $return .= "'vainfo' is not installed.";
}

# -------- Hardware -------- #
$return .= "\n-------------------------------------\n";
$return .= "               HARDWARE\n";
$return .= "-------------------------------------\n";

$return .= `lspci -v`;

# -------- Logs -------- #
$return .= "\n-------------------------------------\n";
$return .= "                Logs\n";
$return .= "-------------------------------------\n";

if (-f $ENV{"HOME"} . '/.cache/blade/shadow/shadow.log') {
    my @logs = split(/Shadow client version/, `cat ~/.cache/blade/shadow/shadow.log`);
    $return .= 'Shadow client version' . $logs[-1];

} else {
    $return .= 'Logs not found.';
}

# -------- Send to Hostbin -------- #
print "\n" . share($return) . "\n";
