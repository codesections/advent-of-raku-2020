#!/usr/bin/env raku

use v6;

sub MAIN( $file where "example"|"input", $verbose = 0 ) {
    my @current-grid = load-grid( $file );
    my $height = @current-grid.elems - 2;
    my $width = @current-grid[0].elems - 2;
    my @next-grid = [ @current-grid.map(*.clone) ];

    my @surrounds = ((-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1));
    repeat {
        @current-grid = [ @next-grid.map(*.clone) ];
        say print-grid( @current-grid ) if $verbose; 
        say '---' if $verbose;
        ( (1..$height) X, (1..$width) ).race.map(
            -> ($y, $x) {
                my $seat = @current-grid[$y][$x];
                my @s = [ for ( @surrounds ) -> ($dy,$dx) { @current-grid[$y+$dy][$x+$dx] } ];
                note "$y, $x, $seat, {@s}, {next-seat($seat,@s)}" if $verbose > 1;
                @next-grid[$y][$x] = next-seat($seat,@s);
            });
        
    } until ( @current-grid ~~ @next-grid );

    say print-grid( @next-grid ) if $verbose;
    say [+] @next-grid.map( *.grep('#').elems );
}

multi sub next-seat( '.', @ ) { '.' }
multi sub next-seat( '#', @s where @s.grep('#').elems >= 4 ) { 'L' }
multi sub next-seat( 'L', @s where @s.grep('#').elems == 0 ) { '#' }
multi sub next-seat( 'L', @ ) { 'L' }
multi sub next-seat( '#', @ ) { '#' }

sub print-grid( @grid ) {
    @grid.map(*.join("")).join("\n");
}

sub load-grid( $file ) {
    my @grid = [['.',],];
    for $file.IO.lines -> $line {
        @grid.push( [ '.', | $line.comb, '.' ] );
    }
    @grid[0] = ('.' xx @grid[1].elems).Array;
    @grid.push( ('.' xx @grid[1].elems).Array );
    return @grid;
}
