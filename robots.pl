#!/usr/bin/env perl
use utf8;
use strict;
use LWP::Simple;
use JSON;

my $maxResults = 100;
#my $api = decode_json(get('http://130.211.16.196:8080/posts?sort=-publishedDate&page=1&max_results='.$maxResults));
#my $total = $api->{_meta}->{total};

open FILE, ">/tmp/robots.txt";
print FILE "User-agent: *\n";
print FILE "Sitemap: https://www.mirrormedia.mg/rss/sitemap.xml\n\n";

# my $page = ($type eq 'rss') ? 1 : ceil($total/$maxResults);
my $api = decode_json(get('http://130.211.16.196:8080/posts?where={"isAdult":true}&max_results='.$maxResults));
for (@{ $api->{_items} }) {
	print FILE "Disallow: /story/".$_->{slug}."/\n";
	# $_->{story_link} =~ s/\s//g;
}
`gsutil -h "Cache-Control:max-age=3600,public" -h "Content-Language:zh" cp -a public-read /tmp/robots.txt gs://statics.mirrormedia.mg/`;
