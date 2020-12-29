#!/usr/bin/env raku

use v6;

subset PassCode of Str where { $_ ~~ m/^ <[F B]> ** 7 <[R L]> ** 3 $/ };

class BoardingPass {
    has PassCode $.code is required;
    has $!seat-id;
    
    multi sub process( $ where "F"|"L", Range $r ) {
	my $mid = $r.min + ($r.max - $r.min) div 2;
	$r.min..$mid;
    }
    multi sub process( $ where "B"|"R", Range $r ) {
	my $mid = $r.min + 1 + (($r.max - $r.min) div 2);
	$mid..$r.max;
    }
    
    method seat-id() {
	return $_ with $!seat-id;
	my $row = 0..127;
	my $col = 0..7;

	my @codes = $!code.comb;
	for (0..6) -> $idx {
	    $row = process( @codes[$idx], $row );
	}
	for (7..9) -> $idx {
	    $col = process( @codes[$idx], $col );
	}

	$!seat-id = ( $row.min * 8 ) + $col.min;
	return $!seat-id;
    }

    method Numeric() { $.seat-id }
    method Int() { $.seat-id }
    method gist() { "{$.code} : {$.seat-id}"; }
}

multi sub MAIN( "test" ) {
    use Test;
    ok( BoardingPass.new( :code<FBFBBFFRLR> ) );
    my $pass = BoardingPass.new( :code<FBFBBFFRLR> );
    is( $pass.seat-id, 357 );
    is( BoardingPass.new( :code<BFFFBBFRRR> ).seat-id(),  567 );
    is( BoardingPass.new( :code<FFFBBBFRRR> ).seat-id(),  119 );
    is( BoardingPass.new( :code<BBFFBBFRLL> ).seat-id(),  820 );
    done-testing
}

multi sub MAIN() {
    my @seats = "input".IO.lines.map( { BoardingPass.new( :code($_) ) } );
    say "Max {@seats.max({ $_.seat-id }).gist}";
    my $set = @seats.sort({$_.seat-id}).rotor( 2 => -1 ).first( -> ($a, $b) { $a+1 != $b } );
    say "Seat {$set[0]+1}";
}
