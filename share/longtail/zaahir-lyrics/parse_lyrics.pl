#!/usr/bin/perl

use strict;
use warnings;
use WWW::Mechanize;
use Web::Scraper;
use Data::Dumper;
use List::MoreUtils qw(zip);
use Smart::Comments '###';
use utf8;
use Lyrics::Schema;

#Variables
my @artist_list;
my @song_list;
my %artist_and_song;
my %artists_checked;
my %songs_checked;
my $m = WWW::Mechanize->new( autocheck => 1 );
my $schema = Lyrics::Schema->connect('dbi:SQLite:lyrics.db');
$schema->deploy;

###Connect to website, grab links to alphabetic artists pages
$m->get("http://www.lyricsnmusic.com");
my @temp_links = $m->find_all_links(url_regex => qr/artists/);
my @links;

### Gathering Initial Links
foreach (@temp_links) { 	### Link Progress |===[%]    |
	my $url = $_->url();
	$m->get($url);

	my $stripped_url = $1 if ($url =~ qr/(.+)\/\d+/);
	my @temp = $m->find_all_links(url_abs_regex => qr/$stripped_url.+/);

	my $len = @temp;
	my $last_page = $temp[$len-3]->url();
	my $num = $1 if ($last_page =~ qr/(\d+)$/);
		
	push @links, $stripped_url."/$_" foreach (1..$num);
}

my $len = @links;
print "There are $len pages of artists.\n";

my $counter = 0;
###Grab artists from each page
foreach my $link (@links) {		### Artist Progress |===[%]    |
	my $artist_scraper = scraper {
	    process "div.grid_5 > a", "urls[]" => '@href', "names[]" => 'TEXT';
	};

	my $result = $artist_scraper->scrape( URI->new($link) );
	if (scalar keys %$result == 0) {next};
	my @artist_urls = @{$result->{urls}};
	my @artist_names = @{$result->{names}};
	my %artists_hash = zip @artist_names, @artist_urls;

	foreach (keys %artists_hash){
		my $url = $artists_hash{$_}->as_string;
		unless (exists $artists_checked{$url}){
			push @artist_list, $url;		
			$artists_checked{$url} = 1;
		}
	}

	$counter++;
	last if $counter == 1;
}

$len = @artist_list;
print "There are $len artists.\n";

###Grab songs from each artist
foreach my $artist (@artist_list) {		### Song Progress |===[%]    |
		
	my $song_scraper = scraper {
	    process "div.grid_10 > h5 > a", "song_urls[]" => '@href', "names[]" => 'TEXT';
	};

	my $result = $song_scraper->scrape( URI->new($artist) );
	if (scalar keys %$result == 0) {next}
	my @song_urls = @{$result->{song_urls}};
	my @song_names = @{$result->{names}};
	my %songs_hash = zip @song_names, @song_urls;
	
	foreach (keys %songs_hash) {
		my $url = $songs_hash{$_}->as_string;
		unless (m/submissions/ or exists $songs_checked{$url}) {
			push @song_list, $url;
			$songs_checked{$url} = 1;
		}
	}
}

$len = @song_list;
print "There are $len songs.\n";

###Grab lyrics for each song
foreach my $song (@song_list){		### Lyric Progress |===[%]    |

	my $lyric_scraper = scraper {
	    process "div#main.grid_8 > pre", "lyrics" => 'TEXT';
	    process "div#main.grid_8 > h2", "title" => 'TEXT';
	};

	my $result = $lyric_scraper->scrape( URI->new($song) );
	if (scalar keys %$result < 2) {next};

	my $lyrics = $result->{lyrics};
	my $title = $result->{title};
	$title =~ s/\sLyrics//;

	# NOTE: The dash below in the regex is a UTF8 character
	if ($title =~ qr/^(.+)\s–\s(.+)/){
		my $artist = $1;
		my $track = $2;

		print "Track: $track\n";

		my $create_lyric = $schema->resultset('Lyric')->create({ 
			artist_name => $artist,
			song_name => $track,
			words => $lyrics
		});

	}else{
		print "\nNO MATCH!\n$title\n";
	}
}

1;