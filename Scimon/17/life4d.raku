#!/usr/bin/env raku

use v6;

constant SURROUNDS = (0,0,0,0,1,1,1,1,-1,-1,-1,-1).combinations(4).grep( -> @c { ! [==] 0, |@c } ).map( -> $_ { | $_.permutations() } ).unique( as => { $_.join(",") }  ).List;

multi sub MAIN("test") {
    use Test;
    is-deeply( set( parse("example") ), set( "1,0,0,0", "2,1,0,0", "0,2,0,0", "1,2,0,0", "2,2,0,0" ) );
    is( surrounds( "0,0,0,0" ).elems, 80 );
    is( iterate( parse("example") ).elems, 29 );
    my @t = parse("example");
    for (^6) { @t = iterate(@t) }
    is( @t.elems, 848 );
}

multi sub MAIN() {
    my @cubes = parse("input");

    for (^6) {
        @cubes = iterate(@cubes);
    }
    
    say @cubes.elems;
}

sub iterate( @points ) {
    my @all = @points.race.map( -> $p { |surrounds($p) } ).unique;
    note @points.elems, ":", @all.elems;
    my $point-set = @points.Set;
    
    return @all.race.grep( -> $p { check-cell( $p, $point-set) } );
}

multi sub check-cell( $point, $ps where { $point ∈ $ps } ) {
    active-count( $point, $ps ) == 2|3;
}

multi sub check-cell( $point, $ps where { $point ∉ $ps } ) {
    active-count( $point, $ps ) == 3;
}

sub active-count( $point, $ps ) {
    (surrounds($point) ∩ $ps).elems;
}

sub surrounds( Str $point ) {
    my @point = $point.split(",");
    return ( ( @point Z+ $_ for SURROUNDS ).map(*.join(",")) );
}

sub parse(Str $file) {
    my @out;
    my $y= 0;
    for $file.IO.lines -> $line {
        my $x = 0;
        for $line.comb -> $v {
            if $v ~~ '#' {
                @out.push( "$x,$y,0,0" );
            }
            $x++;
        }
        $y++;
    }
    return @out;    
}

