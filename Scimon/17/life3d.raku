#!/usr/bin/env raku

use v6;

multi sub MAIN("test") {
    use Test;
    is-deeply( set( parse("example") ), set( "1,0,0", "2,1,0", "0,2,0", "1,2,0", "2,2,0" ) );
    is-deeply( set( surrounds( "0,0,0" ) ), set("0,0,1", "0,1,0", "1,0,0",
                                                "0,0,-1", "0,-1,0", "-1,0,0",
                                                "0,1,1", "1,0,1", "1,1,0",
                                                "0,1,-1", "0,-1,1", "1,0,-1",
                                                "1,-1,0", "-1,0,1", "-1,1,0",
                                                "0,-1,-1", "-1,0,-1", "-1,-1,0",
                                                "1,1,1", "1,1,-1", "1,-1,1",
                                                "-1,1,1", "1,-1,-1", "-1,1,-1",
                                                "-1,-1,1", "-1,-1,-1") ); 
    is( iterate( parse("example") ).elems, 11 );
    is( iterate( iterate( parse("example") ) ).elems, 21 );
    my @t = parse("example");
    for (^6) { @t = iterate(@t) }
    is( @t.elems, 112 );
}

multi sub MAIN("part1") {
    my @cubes = parse("input");

    for (^6) {
        print ".";
        @cubes = iterate(@cubes);
    }
    say "";
    
    say @cubes.elems;
}

sub iterate( @points ) {
    return @points.race.map( -> $p { |check-cell( $p, @points ) } ).unique;
}

sub check-cell( $point, @points ) {
    my @out;
    @out.push($point) if active-count($point, @points) == 2|3;
    for surrounds($point) -> $p {
        next if $p ∈ @points;
        @out.push($p) if active-count($p, @points) == 3;
    }
    return @out;
}

sub active-count( $point, @points ) {
    (surrounds($point) ∩ @points).elems;
}

sub surrounds( Str $point ) {
    my @point = $point.split(",");
    return ( ( @point Z+ $_ for  (0,0,0,1,1,1,-1,-1,-1).combinations(3).grep( -> @c { ! [==] 0, |@c } ).map( -> $_ { | $_.permutations() } ).unique( as => { $_.join(",") }  ) ).map(*.join(",")) );
}

sub parse(Str $file) {
    my @out;
    my $y= 0;
    for $file.IO.lines -> $line {
        my $x = 0;
        for $line.comb -> $v {
            if $v ~~ '#' {
                @out.push( "$x,$y,0" );
            }
            $x++;
        }
        $y++;
    }
    return @out;    
}

