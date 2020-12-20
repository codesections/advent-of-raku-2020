#!/usr/bin/env raku

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
    my $idx = -1;
    my @checks;
    my $min-largest = 0;
    my $inc;
    for $busses.split(",") -> $bus {
        $idx++;
        next if $bus ~~ "x";
        $inc //= $bus.Int;
        $min-largest = $min-largest < $bus + $idx ?? $bus+$idx !! $min-largest;
        @checks.push( { :t($bus.Int), :d($idx) } );
    }
    my $min = $inc * ( ( $min-largest div $inc ) +1 );
    note "$min, $inc";
    return ($min, * + $inc...* > 100_000_000_000_000).hyper( :4degree, :64batch ).grep( { check-val($_, @checks ) } ).first;
    
}

sub check-val( Int $number, @checks ) {
    so all( @checks.map( { ($number + $_<d>) %% $_<t> } ) );
}
                      
