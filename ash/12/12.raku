#!/usr/bin/env raku

my ($x, $y) = 0, 0;
my @dirs = <E N W S>;
my $dir = 0; # E

for 'input.txt'.IO.lines -> $line {
    $line ~~ /(\w) (\d+)/;
    move($/[0].Str, $/[1].Int);
}

say $x.abs + $y.abs; # 962

multi sub move('L', $deg) { $dir = ($dir + $deg / 90) % 4 }
multi sub move('R', $deg) { $dir = ($dir - $deg / 90) % 4 }

multi sub move('E', $dist) { $x += $dist }
multi sub move('N', $dist) { $y += $dist }
multi sub move('W', $dist) { $x -= $dist }
multi sub move('S', $dist) { $y -= $dist }

multi sub move('F', $dist where $dir == 0) { $x += $dist }
multi sub move('F', $dist where $dir == 1) { $y += $dist }
multi sub move('F', $dist where $dir == 2) { $x -= $dist }
multi sub move('F', $dist where $dir == 3) { $y -= $dist }
