package Graph::HanserJauffretKaufmann;

use strict;
use warnings;

use Data::Dumper;
use Graph::Undirected;
use List::Util qw( uniq );

sub find_cycles
{
    my( $graph ) = @_;

    my $p = Graph::Undirected->new( multiedged  => 1,
                                    vertices    => [ $graph->vertices ],
                                    edges       => [ $graph->edges ] );

    my @cycles;
    while( my( $vertex ) = $p->vertices ) {
        my @edges;
        my @loops;
        for my $edge ($p->edges_at( $vertex )) {
            if( $edge->[0] ne $edge->[1] ) {
                push @edges, map { [ @$edge, $_ ] } $p->get_multiedge_ids( @$edge );
            } else {
                push @loops, map { [ @$edge, $_ ] } $p->get_multiedge_ids( @$edge );
            }
        }
        for my $loop (@loops) {
            push @cycles, [ $vertex, @{$p->get_edge_attribute_by_id( @$loop, 'path' )} ];
        }
        for my $i (0..$#edges) {
            for my $j ($i+1..$#edges) {
                my @new_path;
                if( $p->has_edge_attribute_by_id( @{$edges[$i]}, 'path' ) ) {
                    push @new_path,
                         @{$p->get_edge_attribute_by_id( @{$edges[$i]}, 'path' )};
                }
                push @new_path, $vertex;
                if( $p->has_edge_attribute_by_id( @{$edges[$j]}, 'path' ) ) {
                    push @new_path,
                         @{$p->get_edge_attribute_by_id( @{$edges[$j]}, 'path' )};
                }
                next unless scalar( uniq @new_path ) == scalar( @new_path );
                my @new_edge = grep { $_ ne $vertex } map { $_->[0], $_->[1] } ( $edges[$i], $edges[$j] );
                my $edge = $p->add_edge_get_id( @new_edge );
                $p->set_edge_attribute_by_id( @new_edge, $edge, 'path', \@new_path );
            }
        }
        $p->delete_vertex( $vertex );
    }

    return @cycles;
}

1;
