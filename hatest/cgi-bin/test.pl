#!/usr/bin/perl
use strict;
use warnings;

# Onder mod_perl heb je Apache2::RequestRec enz.
# Maar als fallback gewoon CGI output
print "Content-type: text/html\n\n";

print "<html><head><title>mod_perl test</title></head><body>\n";
print "<h1>Hallo vanaf mod_perl / CGI</h1>\n";

# Check of we onder mod_perl draaien
if ($ENV{MOD_PERL}) {
    print "<p><b>MOD_PERL actief!</b></p>\n";
    print "<p>Versie: $ENV{MOD_PERL}</p>\n";
} else {
    print "<p>MOD_PERL lijkt niet actief, dit is gewone CGI.</p>\n";
}

# Debug: toon environment
print "<h2>ENV dump</h2><pre>\n";
for my $k (sort keys %ENV) {
    printf "%-20s => %s\n", $k, $ENV{$k};
}
print "</pre>\n";

print "</body></html>\n";

