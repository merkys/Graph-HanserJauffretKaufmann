#!/usr/bin/perl

# Test with a chemical graph of cubane.

use strict;
use warnings;

use Chemistry::OpenSMILES::Parser;
use Graph::HanserJauffretKaufmann;
use Test::More tests => 1;

my $smiles = 'C12C3C4C1C5C2C3C45';

my $parser = Chemistry::OpenSMILES::Parser->new;
my( $g ) = $parser->parse( $smiles );

is( scalar Graph::HanserJauffretKaufmann::find_cycles( $g ), 28 );
