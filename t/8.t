#!/usr/bin/perl

# Test with a complete graph of 8 vertices.

use strict;
use warnings;

use Graph::Undirected;
use Graph::HanserJauffretKaufmann;
use Test::More;

if( !$ENV{EXTENDED_TESTING} ) {
    plan skip_all => "Skip \$ENV{EXTENDED_TESTING} is not set\n";
}

plan tests => 1;

my $g = Graph::Undirected->new;

$g->add_vertices( 'a'..'h' );
for my $i ( 'a'..'h' ) {
    for my $j ( 'a'..'h' ) {
        next if $i ge $j;
        $g->add_edge( $i, $j );
    }
}

is( scalar Graph::HanserJauffretKaufmann::find_cycles( $g ), 8018 );
