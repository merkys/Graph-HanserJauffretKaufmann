#!/usr/bin/perl

# Test with the graph from Figure 11 of HJK paper.

use strict;
use warnings;

use Graph::Undirected;
use Graph::HanserJauffretKaufmann;
use Test::More tests => 1;

my $g = Graph::Undirected->new;

$g->add_path( 'a', 'e', 'b', 'f', 'c', 'd', 'a' );
$g->add_path( 'e', 'h', 'f', 'i', 'd', 'g', 'e' );
$g->add_path( 'g', 'h', 'i', 'g' );

$g->add_edge( 'a', 'g' );
$g->add_edge( 'b', 'h' );
$g->add_edge( 'c', 'i' );

is( scalar Graph::HanserJauffretKaufmann::find_cycles( $g ), 248 );
