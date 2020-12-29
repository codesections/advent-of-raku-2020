#!/usr/bin/env raku

use v6;

multi sub MAIN ( "test" ) {
    use Test;
    my $example = parse( "example" );
    is( $example<field><class><valid>, ( |(1..3), |(5..7) ) );
    is-deeply( $example<field><class><position>, Set(0,1,2) );
    is( $example<field><row><valid>, ( |(6..11), |(33..44) ) );
    is( $example<field><seat><valid>, ( |(13..40), |(45..50) ) );
    is( $example<yours>, (7,1,14) );
    is( $example<tickets>[0], (7,3,47) );
    is( $example<tickets>[3], (38,6,12) );
    is( invalid( $example )( 0 ), [] );
    is( invalid( $example )( 1 ), [4] );
    is( error-rate( $example ), 71 );
    is( valid-tickets( $example ), 0 );
    my $example2 = parse( "example2" );
    is( valid-tickets($example2).elems, 3 );
    is( valid-tickets($example2), (0,1,2) );
    is-deeply( $example2<field><class><position>, Set(0,1,2) );
    $example2 = find-attributes( $example2 );
    is( $example2<field><row><position>, 0 );
    is( $example2<field><class><position>, 1 );
    is( $example2<field><seat><position>, 1 );
}

multi sub MAIN( "part1" ) {
    say error-rate( parse( "input" ) );
}

multi sub MAIN( "part2" ) {
    my $data = find-attributes( parse( "input" ) );
    say [*] $data<yours>[$data<field>.kv.map( -> $k, $v { $k.starts-with( 'departure' ) ?? $v<position> !! Nil }).grep({defined $_})];
}

sub find-attributes( $data ) {
    for $data<field>.keys -> $key {
        for valid-tickets($data).map( { $data<tickets>[$_] } ) -> $ticket {
            for $ticket.kv -> $idx, $val {
                if $val ∉ $data<field>{$key}<valid> {
                    $data<field>{$key}<position> = $data<field>{$key}<position> ∖ $idx;
                }
            }
        }
        $data<field>{$key}<position> = $data<field>{$key}<position>.keys[0] if $data<field>{$key}<position>.elems == 1;
    }
    while $data<field>.keys.grep( { $data<field>{$_}<position> ~~ Set } ).elems {
        for $data<field>.keys.grep( { $data<field>{$_}<position> !~~ Set } ).map( { $data<field>{$_}<position> }) -> $known {
            for $data<field>.keys.grep( { $data<field>{$_}<position> ~~ Set } ) -> $unknown {
                $data<field>{$unknown}<position> = $data<field>{$unknown}<position> ∖ $known;
            }            
        }
        for $data<field>.keys.grep( { $data<field>{$_}<position> ~~ Set } ) -> $key {
            $data<field>{$key}<position> = $data<field>{$key}<position>.keys[0] if $data<field>{$key}<position>.elems == 1;
        }
    }    
    return $data;

}

sub valid-tickets( $data ) {
    my $invalid = invalid($data);

    $data<tickets>.keys.hyper.grep( -> $i { ! $invalid($i).elems } ); 
}

sub error-rate( $data ) {
    my $invalid = invalid($data);

    [+] $data<tickets>.keys.hyper.map( -> $i { [+] $invalid($i); } ); 
}

sub invalid( $data ) {
    my $invalid = none( $data<field>.values.map( { | $_<valid> } ) );
    return sub ( $ticket ) {
        $data<tickets>[$ticket].grep( * ~~ $invalid ).Array;
    }    
}

sub parse( $file ) {
    my $out = {};

    my $state = 'field';
    for $file.IO.lines -> $line {
        given $state {
            when 'field' {
                if my $match = ( $line ~~ m/^ $<name>=(.+?) ": " $<r1>=((\d+) "-" (\d+)) " or " $<r2>=((\d+) "-" (\d+)) $/ ) {
                    $out{$state}{$match<name>.Str}<valid> = ( |($match<r1>[0].Int..$match<r1>[1].Int),
                                                              |($match<r2>[0].Int..$match<r2>[1].Int) ); 
                } elsif $line ~~ 'your ticket:' {

                    for $out{$state}.keys -> $key {
                        $out{$state}{$key}<position> = (^$out{$state}.elems).Set;
                    }
                    $state = 'yours'
                }
            }
            when 'yours' {
                if $line.starts-with('near') {
                    $state = 'tickets';
                    $out{$state} = [];
                } elsif $line {
                    $out{$state} = $line.split(",").map(*.Int);
                }
            }
            when 'tickets' {
                $out{$state}.push( [ $line.split(",").map(*.Int) ] );
            }
        }
    }
    return $out;
}
