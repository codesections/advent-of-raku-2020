#!/usr/bin/env raku

use v6;

sub MAIN ( $file where "example"|"input" ) {

    my @mask[36];
    my @memory;
    
    my $match;
    for $file.IO.lines -> $command {
        if $match = ( $command ~~ m/^ "mask = " $<new-mask>=(. ** 36) $/ ) {
            for $match<new-mask>.Str.comb.kv -> $i, $v { 
                if $v ~~ 1|0 { @mask[$i] = $v } else { @mask[$i]:delete }
            }
        }
        if $match = ( $command ~~ m/^ "mem[" $<key>=(\d+) "] = " $<value>=(\d+) $/ ) {
            my $key = $match<key>.Int;
            my @val = @mask Z// ( sprintf( "%036d", $match<value>.Int.base(2) ).comb );
            @memory[$key] = @val.join("").parse-base(2);
        }
    }
    say [+] @memory;
}
