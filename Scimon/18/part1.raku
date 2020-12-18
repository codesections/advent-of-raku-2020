#!/usr/bin/env raku

use v6;

multi sub MAIN( "test" ) {
    use Test;

    is( calculate( "1 + 2 * 3 + 4 * 5 + 6"), 71 );
    is( calculate( "1 + (2 * 3) + (4 * (5 + 6))"), 51 );
    is( calculate( "2 * 3 + (4 * 5)"), 26);
    is( calculate( "5 + (8 * 3 + 9 + 3 * 4 * 3)"), 437 );
    is( calculate( "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"), 12240 );
    is( calculate( "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"), 13632 );

    done-testing;
}

multi sub MAIN() {
    say [+] "input".IO.lines.race.map( -> $_ { calculate($_) } );
}

multi sub calculate( Str $str ) { $str.Int }

multi sub calculate( Str $str is copy where m/"(".+")"/ ) {
    $str ~~ s/"(" $<calc>=(<-[()]>+) ")"/{calculate($/<calc>.Str)}/;
    return calculate( $str );
}

multi sub calculate( Str $str is copy where m/"*"|"+"/ ) {
    my %ops = ( "+" => &infix:<+>, "*" => &infix:<*> );
    $str ~~ s/^$<o1>=(\d+) " " $<op>=("+"|"*") " " $<o2>=(\d+)/{%ops{$/<op>}($/<o1>.Int,$/<o2>.Int)}/;
    return calculate( $str );
}
