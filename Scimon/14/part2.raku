#!/usr/bin/env raku

use v6;

sub MAIN ( $file where "example2"|"input" ) {

    my @mask[36];
    my %memory;
    
    my $match;
    for $file.IO.lines -> $command {
        if $match = ( $command ~~ m/^ "mask = " $<new-mask>=(. ** 36) $/ ) {
            for $match<new-mask>.Str.comb.kv -> $i, $v { 
                if $v ~~ 1|0 { @mask[$i] = $v } else { @mask[$i] = 2 }
            }
        }
        if $match = ( $command ~~ m/^ "mem[" $<key>=(\d+) "] = " $<value>=(\d+) $/ ) {
            my @key-space = ( sprintf( "%036d", $match<key>.Int.base(2) ).comb );
            my $val = $match<value>.Int;
            my @keys = [[],];

            for @mask.kv -> $i, $m {
                if $m == 0 {
                    for @keys -> @k {
                        @k[$i] = @key-space[$i];
                    }
                }
                elsif $m == 1 {
                    for @keys -> @k {
                        @k[$i] = 1;
                    }
                }
                else {
                    my @nk;
                    for @keys -> @k {
                        for 0,1 -> $v {
                            @nk.push( [ |@k, $v ] );
                        }
                    }
                    @keys = @nk;
                }
            }
            for @keys = @keys.map( *.join("").parse-base(2) ) -> $key {
                note "$key : $val";
                %memory{$key} = $val;
            }
        }
    }
    say [+] %memory.values;
}
