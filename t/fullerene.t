#!/usr/bin/perl

# Test with a chemical graph of fullerene.

use strict;
use warnings;

use Chemistry::OpenSMILES::Parser;
use Graph::HanserJauffretKaufmann;
use Test::More;

if( !$ENV{EXTENDED_TESTING} ) {
    plan skip_all => "Skip \$ENV{EXTENDED_TESTING} is not set\n";
}

plan tests => 1;

my $smiles = 'c12c3c4c5c2c2c6c7c1c1c8c3c3c9c4c4c%10c5c5c2c2c6c6c%11c7c1c1c7c8c3c3c8c9c4c4c9c%10c5c5c2c2c6c6c%11c1c1c7c3c3c8c4c4c9c5c2c2c6c1c3c42';

my $parser = Chemistry::OpenSMILES::Parser->new;
my( $g ) = $parser->parse( $smiles );

is( scalar Graph::HanserJauffretKaufmann::find_cycles( $g ), 8018 );
