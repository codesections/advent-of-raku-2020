#!/usr/bin/env raku

use v6

sub MAIN( $file where "input"|"example", Int $look-for = 23278925 ) {
    my @values = $file.IO.lines.map( *.Int );
    
    for 0..(@values.end) -> $idx {
        my @sums = [\+] @values[$idx..*-1]; 
        for 1..(@sums.end) -> $idx2 {
            if @sums[$idx2] == $look-for {
                note @sums;
                note @values;
                note "$idx, $idx2";
                my @continuous = @values[$idx..($idx+$idx2)];
                note @continuous;
                note @continuous.min, " ", @continuous.max;
                say [+] @continuous.min, @continuous.max;
                exit;
            }
        }
    }
}
