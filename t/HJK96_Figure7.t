#!/usr/bin/perl

# Test with the graph from Figure 7 of HJK paper.

use strict;
use warnings;

use Graph::Undirected;
use Graph::HanserJauffretKaufmann;
use Test::More tests => 1;

my $g = Graph::Undirected->new;

$g->add_path( 'e', 'f', 'a', 'b', 'c', 'd', 'j', 'i', 'h', 'g', 'k', 'l', 'm', 'n', 'q', 'p', 'o' );
$g->add_edge( 'e', 'd' );
$g->add_edge( 'c', 'g' );
$g->add_edge( 'h', 'n' );
$g->add_edge( 'm', 'o' );

is( scalar Graph::HanserJauffretKaufmann::find_cycles( $g ), 10 );
