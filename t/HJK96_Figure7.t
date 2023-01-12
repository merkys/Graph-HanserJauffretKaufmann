#!/usr/bin/perl

# Test with the graph from Figure 5 of HJK paper.

use strict;
use warnings;
use Graph::Undirected;
use Graph::HanserJauffretKaufmann;

my $g = Graph::Undirected->new;

$g->add_path( 'e', 'f', 'a', 'b', 'c', 'd', 'j', 'i', 'h', 'g', 'k', 'l', 'm', 'n', 'q', 'p', 'o' );
$g->add_edge( 'e', 'd' );
$g->add_edge( 'c', 'g' );
$g->add_edge( 'h', 'n' );
$g->add_edge( 'm', 'o' );

Graph::HanserJauffretKaufmann::find_cycles( $g );
