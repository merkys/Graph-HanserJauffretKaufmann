package Graph::HanserJauffretKaufmann;

use strict;
use warnings;

# ABSTRACT: Find all cycles in a graph
# VERSION

use Bit::Vector::Overload;
use Graph::Undirected;

sub find_cycles
{
    my( $graph ) = @_;

    my $p = Graph::Undirected->new( multiedged  => 1,
                                    refvertexed => $graph->is_refvertexed,
                                    vertices    => [ $graph->vertices ],
                                    edges       => [ $graph->edges ] );

    # Vertices have to be visited in the order of increasing degree
    my @order = sort { $p->degree( $a ) <=> $p->degree( $b ) } $p->vertices;

    my $attributes = {};
    my $map = {};
    for my $i (0..$#order) {
        $map->{$order[$i]} = $i;
    }

    my @cycles;
    for my $vertex (@order) {
        my @edges;
        my @loops;
        for my $edge ($p->edges_at( $vertex )) {
            # Edges that start and end at the same vertex are self-loops
            if( $edge->[0] ne $edge->[1] ) {
                push @edges, map { [ sort( @$edge ), $_ ] } $p->get_multiedge_ids( @$edge );
            } else {
                push @loops, map { [ sort( @$edge ), $_ ] } $p->get_multiedge_ids( @$edge );
            }
        }
        for my $loop (@loops) {
            push @cycles, [ $vertex, $attributes->{$loop->[0]}{$loop->[1]}{$loop->[2]} ];
        }
        for my $i (0..$#edges) {
            EDGE: for my $j ($i+1..$#edges) {
                my $path1 = $attributes->{$edges[$i]->[0]}{$edges[$i]->[1]}{$edges[$i]->[2]};
                my $path2 = $attributes->{$edges[$j]->[0]}{$edges[$j]->[1]}{$edges[$j]->[2]};
                # If paths have more vertices in common than $vertex, they have to be eliminated.
                # $vertex will only participate in one of the paths if it is already visited and removed.
                # This cannot already be done at the time of considering $vertex.
                if( $path1 && $path2 ) {
                    my $common = $path1 & $path2;
                    next unless $common->is_empty;
                }
                my @new_edge = sort grep { $_ ne $vertex }
                                map { $_->[0], $_->[1] }
                                    ( $edges[$i], $edges[$j] );
                my $edge = $p->add_edge_get_id( @new_edge );
                my $new_path = Bit::Vector->new( scalar @order );
                $new_path->bit_flip( $map->{$vertex} );
                $new_path |= $path1 if $path1;
                $new_path |= $path2 if $path2;
                $attributes->{$new_edge[0]}{$new_edge[1]}{$edge} = $new_path;
            }
        }
        $p->delete_vertex( $vertex );
    }

    return @cycles;
}

1;
