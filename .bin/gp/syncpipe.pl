#!/usr/bin/env perl

use strict;
use warnings;
use Time::HiRes qw(setitimer ITIMER_REAL);

use IO::File;
STDOUT->autoflush(1);
STDERR->autoflush(1);

die "Usage: $0 timeout_in_sec [default value]\n" if @ARGV < 1;

my $lastStr;
if (defined $ARGV[1]) {$lastStr = "$ARGV[1]\n";}

$SIG{ALRM} = sub {
  if (defined $lastStr) {print "$lastStr";}
};

setitimer(ITIMER_REAL, $ARGV[0], $ARGV[0]);

while(<STDIN>)
{
  $lastStr = $_;
}

