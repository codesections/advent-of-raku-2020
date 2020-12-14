#!/usr/bin/env raku

# third attempt

use v6;

multi sub MAIN() {
    my $file = "input";
    my $busses = $file.IO.lines[1];
    say find-ts( $busses, 1000000000000000 );
}

multi sub MAIN("test") {
    use Test;
    is( find-ts( "17,x,13,19",3000 ), 3417 );
    is( find-ts( "7,13,x,x,59,x,31,19" ), 1068781 );
    is( find-ts( "67,7,59,61"), 754018 );
    is( find-ts( "67,x,7,59,61"), 779210 );
    is( find-ts( "67,7,x,59,61"), 1261476 );
    is( find-ts( "1789,37,47,1889", 1000000000), 1202161486 );
}

sub find-ts( $busses, $min = 0 ) {
    my %bus-times;
    
    my $idx = -1;
    my $max = 0;
    my $max-idx = 0;
    for $busses.split(",") -> $bus {
        $idx++;
        next if $bus ~~ "x";
        my $v = $bus.Int;
        %bus-times{$idx} = $v;
        if ( $max < $v ) {
            $max = $v;
            $max-idx = $idx
        }
    }   

    $idx = ( $min div $max );
    my $val;
    loop {
        $idx++;
        $val = ($idx * $max) - $max-idx;
        note $val;
        last if check-vals( %bus-times, $val ); 
    }
    return $val;
}

sub check-vals( %times, Int $val ) {
    return so all( %times.kv.map( -> $k, $v { ($val + $k) %% $v } ) );
}
                      
