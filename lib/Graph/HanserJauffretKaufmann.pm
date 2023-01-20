package Graph::HanserJauffretKaufmann;

use strict;
use warnings;

# ABSTRACT: Find all cycles in a graph
# VERSION

use List::Util qw( uniq );
use Math::Matrix::MaybeGSL;

sub find_cycles
{
    my( $graph ) = @_;

    # Vertices have to be visited in the order of increasing degree
    my @order = sort { $graph->degree( $a ) <=> $graph->degree( $b ) } $graph->vertices;

    my %map;
    for (0..$#order) {
        $map{$order[$_]} = $_;
    }

    my $has_row; # Does Math::Matrix::MaybeGSL have row()?

    # Create a data structure holding a matrix for each of vertex.
    # In a matrix rows would correspond to edges to other vertices.
    my %edge_matrices;
    my %edges;
    for my $vertex ($graph->vertices) {
        $edge_matrices{$vertex} = Matrix->new( $graph->degree( $vertex ), scalar $graph->vertices );
        $has_row = $edge_matrices{$vertex}->can( 'row' ) if !defined $has_row && defined $edge_matrices{$vertex};
        $edges{$vertex} = [ $graph->neighbours( $vertex ) ];
    }

    my @cycles;
    for my $vertex (@order) {
        next unless defined $edge_matrices{$vertex};
        my $incident_edges = $edge_matrices{$vertex} * transpose( $edge_matrices{$vertex} );
        my @incident_edges;
        if( $incident_edges->can( 'find_zeros' ) ) {
            @incident_edges = map { [ $_->[0]-1, $_->[1]-1 ] }
                              grep  { $_->[0]  < $_->[1] } $incident_edges->find_zeros;
        } else {
            my( undef, $columns ) = $incident_edges->dim;
            my $pos = 0;
            for ($incident_edges->as_list) {
                if( !$_ ) {
                    my( $i, $j ) = ( int($pos/$columns), $pos % $columns );
                    push @incident_edges, [$i, $j] if $i < $j;
                }
                $pos++;
            }
        }
        for my $edge (@incident_edges) {
            my( $i, $j ) = @$edge;
            my( $vertex1, $vertex2 ) = map { $edges{$vertex}->[$_] } ( $i, $j );

            if( $vertex1 eq $vertex2 ) {
                # Self-loop detected
                push @cycles, 'cycle'; # TODO: Return something meaningful
            } else {
                my( $row_i, $row_j );
                if( $has_row ) {
                    $row_i = $edge_matrices{$vertex}->row( $i+1 );
                    $row_j = $edge_matrices{$vertex}->row( $j+1 );
                } else {
                    $row_i = row( $edge_matrices{$vertex}, $i );
                    $row_j = row( $edge_matrices{$vertex}, $j );
                }
                my $new_row = sum( $row_i, $row_j );
                $new_row->assign( 1, $map{$vertex}+1, 1 );

                $edge_matrices{$vertex1} = $edge_matrices{$vertex1}->vconcat( $new_row );
                $edge_matrices{$vertex2} = $edge_matrices{$vertex2}->vconcat( $new_row );
                push @{$edges{$vertex1}}, $vertex2;
                push @{$edges{$vertex2}}, $vertex1;
            }
        }

        delete $edge_matrices{$vertex};
        for my $neighbour (uniq @{$edges{$vertex}}) {
            my @indices = grep { $edges{$neighbour}->[$_] ne $vertex }
                              0..$#{$edges{$neighbour}};
            $edge_matrices{$neighbour} = rows( $edge_matrices{$neighbour}, @indices );
            @{$edges{$neighbour}} = map { $edges{$neighbour}->[$_] } @indices;
        }
        delete $edges{$vertex};
    }

    return @cycles;
}

sub sum
{
    my( $A, $B ) = @_;

    my @A = $A->as_list;
    my @B = $B->as_list;

    for (0..$#A) {
        $A[$_] += $B[$_];
    }
    return Matrix->new_from_rows( [ \@A ] );
}

sub row
{
    my( $matrix, $row ) = @_;
    my( $rows, $columns ) = $matrix->dim;
    my @elements = $matrix->as_list;
    return Matrix->new_from_rows( [[ @elements[$row*$columns..($row+1)*$columns-1 ] ]] );
}

sub rows
{
    my( $matrix, @rows ) = @_;
    my( $rows, $columns ) = $matrix->dim;
    return unless @rows;
    return $matrix if scalar( @rows ) == $rows; # HACK: This is broken if order is different

    my @elements = $matrix->as_list;
    my @new_rows;
    for (@rows) {
        push @new_rows, [ @elements[$_*$columns..($_+1)*$columns-1 ] ];
    }
    return Matrix->new_from_rows( \@new_rows );
}

sub transpose
{
    my( $matrix ) = @_;
    my( $rows, $columns ) = $matrix->dim;
    my @elements = $matrix->as_list;
    my @rows;
    for my $i (0..$rows-1) {
        push @rows, [ @elements[$i*$columns..($i+1)*$columns-1] ];
    }
    return Matrix->new_from_cols( \@rows );
}

1;
