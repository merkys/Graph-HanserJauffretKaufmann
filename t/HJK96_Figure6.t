#!/usr/bin/perl

# Test with a complete graph of 8 vertices.
# Also present as Figure 6 in the HJK paper.

use strict;
use warnings;

use Graph::Undirected;
use Graph::HanserJauffretKaufmann;
use Test::More tests => 1;

my $g = Graph::Undirected->new;

$g->add_vertices( 'a'..'h' );
for my $i ( 'a'..'h' ) {
    for my $j ( 'a'..'h' ) {
        next if $i ge $j;
        $g->add_edge( $i, $j );
    }
}

is( scalar Graph::HanserJauffretKaufmann::find_cycles( $g ), 8018 );
