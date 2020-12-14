#!/usr/bin/env raku

# Second attempt

use v6;

multi sub MAIN() {
    my $file = "input";
    my $busses = $file.IO.lines[1];
    say find-ts( $busses );
}

multi sub MAIN("test") {
    use Test;
    is( find-ts( "17,x,13,19" ), 3417 );
    is( find-ts( "7,13,x,x,59,x,31,19" ), 1068781 );
    is( find-ts( "67,7,59,61"), 754018 );
    is( find-ts( "67,x,7,59,61"), 779210 );
    is( find-ts( "67,7,x,59,61"), 1261476 );
    is( find-ts( "1789,37,47,1889"), 1202161486 );
}

sub find-ts( $busses ) {
    my %bus-times;
    
    my $idx = -1;
    for $busses.split(",") -> $bus {
        $idx++;
        next if $bus ~~ "x";
        %bus-times{$idx} = { 'i' => 0, 'v' => $bus.Int };
    }   
    for %bus-times.keys -> $k {
        next if $k == 0;
        while ( %bus-times{$k}<i> * %bus-times{$k}<v> < %bus-times{0}<i> * %bus-times{0}<v> ) {
            %bus-times{$k}<i>++
        } 
    }
    while ( ! check-vals( %bus-times ) ) {
        %bus-times{0}<i>++;
        for %bus-times.keys -> $k {
            next if $k == 0;
            while ( %bus-times{$k}<i> * %bus-times{$k}<v> < %bus-times{0}<i> * %bus-times{0}<v> ) {
                %bus-times{$k}<i>++
            } 
        }
        note %bus-times.gist;
    }
    return %bus-times{0}<i> * %bus-times{0}<v>;
}

sub check-vals( %times ) {
    return so [==] %times.kv.map( -> $k, $v { ($v<i> * $v<v>) - $k } );
}
                      
