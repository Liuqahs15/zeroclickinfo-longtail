#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp;
use JSON;

my $file = $ARGV[0];

my $text = read_file($file);
my $json = JSON->new->allow_nonref->decode($text);

#print '<?xml version="1.0" encoding="UTF-8"?>' . "\n"
#    . '<add allowDups="true">' . "\n\n";

print "<doc>\n";
print '<field name="l2_sec">'
    . $json->{official_title}
    . "</field>\n";
print '<field name="l3_sec">'
    . $json->{actions}[scalar @{ $json->{actions} } - 1]{in_committee}
    . "</field>\n";
print '<field name="l4_sec">'
    . (join ", ", @{ $json->{subjects} })
    . "</field>\n";
print '<field name="paragraph">'
    . $json->{summary}{text}
    . "</field>\n";
print '<field name="source">'
    . 'http://www.govtrack.us/'
    . "</field>\n";
print '<field name="title">'
    . "U.S. House Bill #" . $json->{number}
    . ($json->{short_title} ne "" ? $json->{short_title} : "")
    . "</field>\n";

print "</doc>\n\n";
#    . '</add>';
