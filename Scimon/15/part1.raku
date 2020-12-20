#!/usr/bin/env raku

use v6;

multi sub MAIN( "test" ) {
    use Test;
    is( game( 2020, 0, 3, 6 ), 436 );
    is( game( 2020,1,3,2 ), 1 );
    is( game( 2020,2,1,3 ), 10 );
    is( game( 2020,1,2,3 ), 27 );
    is( game( 2020,2,3,1 ), 78 );
    is( game( 2020,3,2,1 ), 438 );
    is( game( 2020,3,1,2 ), 1836 );

    is( game( 30000000, 0, 3, 6 ), 175594 );
    is( game( 30000000,1,3,2 ), 2578 );
    is( game( 30000000,2,1,3 ), 3544142);
    is( game( 30000000,1,2,3 ), 261214 );
    is( game( 30000000,2,3,1 ), 6895259 );
    is( game( 30000000,3,2,1 ), 18 );
    is( game( 30000000,3,1,2 ), 362 );

}

multi sub MAIN("part1") {
    say game( 2020, 20,0,1,11,6,3 );
}

multi sub MAIN("part2") {
    say game( 30000000, 20,0,1,11,6,3 );
}


sub game( int $end-turn, *@start ) {
    my $turn = 1;
    my $last;
    my %said;
    for @start -> $val {
        %said{$val} = $turn;
        $last = $val;
        $turn++;
    }

    my $current = 0;
    my $next = 0;
    while ( $turn < $end-turn ) {
        if ( my $last = %said{$current} ) {
            $next = $turn - $last;
	} else {
	    $next = 0;
	}
	%said{$current} = $turn;
	$current = $next;
        $turn++;
    }
    return $current;
}
