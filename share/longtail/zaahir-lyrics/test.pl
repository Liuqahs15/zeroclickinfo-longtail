#!/usr/bin/env perl

use strict;
use warnings;

use Lyrics::Schema;

my $schema = Lyrics::Schema->connect('dbi:SQLite:lyrics.db');

$schema->deploy;

my $result = $schema->resultset('Test')->create({ testcol => 'blub' });

my @all = $schema->resultset('Test')->search({});

for (@all) {
        print $_->testcol."\n";
}

