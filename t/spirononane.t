#!/usr/bin/perl

# Test with a chemical graph of caffeine.

use strict;
use warnings;

use Chemistry::OpenSMILES::Parser;
use Graph::HanserJauffretKaufmann;
use Test::More tests => 1;

my $smiles = 'C1CCCC12CCCC2';

my $parser = Chemistry::OpenSMILES::Parser->new;
my( $g ) = $parser->parse( $smiles );

is( scalar Graph::HanserJauffretKaufmann::find_cycles( $g ), 2 );
