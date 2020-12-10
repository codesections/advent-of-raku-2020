#!/usr/bin/env raku

use v6;

sub MAIN ( $file where "example1"|"example2"|"input" ) {
    my @jolts = $file.IO.lines.map(*.Int).sort;
    @jolts = [ 0, |@jolts, @jolts[*-1]+3 ];
    my %counts;

    for ( 0..(@jolts.end) ) -> $idx {
        my $current = @jolts[$idx];
        my $min = $idx+1 > @jolts.end ?? @jolts.end !! $idx+1;
        my $max = $idx+3 > @jolts.end ?? @jolts.end !! $idx+3;
        my @possible = possible( $current, @jolts[$min..$max] );
        %counts{$current} //= { 'val' => 0, 'children' => @possible };
    }

    for @jolts.reverse -> $jolt {
        %counts{$jolt}<val> = 0;
        for %counts{$jolt}<children>.list -> $key {
            %counts{$jolt}<val> += %counts{$key}<val>;
        }
        %counts{$jolt}<val> ||= 1;
    }

    say %counts{0}<val>;
}


sub possible( $start, @jolts ) is pure {
    return @jolts.grep( 1 <= * - $start <= 3 );
}
