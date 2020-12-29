#!/usr/bin/env raku
use v6.d;

my $face = 'E';
my $c = <E S W N>;                # compass
my %c = (E=>0, S=>1, W=>2, N=>3); # reverse lookup
my ($x, $y) = (0, 0);             # ship location

'input'.IO.lines.map({
    my ($direction, $qty) = (~.substr(0,1), +.substr(1));

    $direction = $face  if $direction eq 'F';
    given $direction {
        when 'N' { $y += $qty }
        when 'S' { $y -= $qty }
        when 'E' { $x += $qty }
        when 'W' { $x -= $qty }
        when 'L' { my $i = %c{$face}; $i -= $qty div 90; $i = $i mod 4; $face=$c[$i]; }
        when 'R' { my $i = %c{$face}; $i += $qty div 90; $i = $i mod 4; $face=$c[$i]; }
    }
});

say "Part One: {abs($x) + abs($y)}";


($x, $y) = (0, 0);     # ship location
my ($u, $v) = (10, 1); # waypoint

'input'.IO.lines.map({
    my $qty = +.substr(1);
    my $d = .substr(0,1);

    given $d {
        when 'N' { $v += $qty }
        when 'S' { $v -= $qty }
        when 'E' { $u += $qty }
        when 'W' { $u -= $qty }
        when 'F' { $x += $u * $qty; $y += $v * $qty }
        when 'L' {
            given $qty div 90 mod 4 {
                when 3 { ($u, $v) = ( $v, -$u) }
                when 2 { ($u, $v) = (-$u, -$v) }
                when 1 { ($u, $v) = (-$v,  $u) }
            }
        }
        when 'R' {
            given $qty div 90 mod 4 {
                when 1 { ($u, $v) = ( $v, -$u) }
                when 2 { ($u, $v) = (-$u, -$v) }
                when 3 { ($u, $v) = (-$v,  $u) }
            }
        }
    }
});

say "Part Two: {abs($x) + abs($y)}";
