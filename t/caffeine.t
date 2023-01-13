#!/usr/bin/perl

# Test with a chemical graph of caffeine.

use strict;
use warnings;

use Chemistry::OpenSMILES::Parser;
use Graph::HanserJauffretKaufmann;
use Test::More tests => 1;

my $caffeine = 'CN1C=NC2=C1C(=O)N(C(=O)N2C)C';

my $parser = Chemistry::OpenSMILES::Parser->new;
my( $g ) = $parser->parse( $caffeine );

is( scalar Graph::HanserJauffretKaufmann::find_cycles( $g ), 3 );
