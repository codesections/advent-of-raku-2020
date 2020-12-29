#!/usr/bin/env raku

use v6;

sub MAIN( $file where "example"|"input" ) {
    my ( $time, $busses ) = $file.IO.lines;
    $busses.split(",").grep( /\d+/ ).map(
        -> $i {
            my $n = $i - ($time % $i);
            { 'i' => $i, 'n' => $n , 'v' => $i * $n };
        }).sort( *<n> ).first().say;
}
