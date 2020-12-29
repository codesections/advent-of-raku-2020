#!/usr/bin/env raku

use v6

sub MAIN( $file where "input"|"example", $preamble = 25 ) {
    my @current;
    for $file.IO.lines -> $value {
        if ( @current.elems == $preamble ) {
            if none( @current.combinations(2).map( { [+] $_ } ) ) == $value {
                say $value;
                exit;
            }
            @current.shift;
        }
        @current.push($value);
    }    
}
