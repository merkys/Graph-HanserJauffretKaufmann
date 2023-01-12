#!/usr/bin/perl

# Test with the graph from Figure 5 of HJK paper.

use strict;
use warnings;
use Graph::Undirected;
use Graph::HanserJauffretKaufmann;

my $g = Graph::Undirected->new;

$g->add_path( 'a', 'b', 'd', 'e', 'f', 'g' );
$g->add_edge( 'b', 'c' );
$g->add_edge( 'e', 'g' );
$g->add_path( 'd', 'h', 'k', 'l', 'p', 'o', 'n', 'm', 'j', 'i' );
$g->add_edge( 'h', 'i' );
$g->add_edge( 'l', 'm' );

Graph::HanserJauffretKaufmann::find_cycles( $g );
