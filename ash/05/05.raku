#!/usr/bin/env raku

my @passes = 'input.txt'.IO.lines.map: *.trans( < F B L R > => < 0 1 0 1 > );

my $max = @passes.max;

my ($row, $col) = $max.substr(0, 7), $max.substr(7);
$row = "0b$row".Int;
$col = "0b$col".Int;

my $seat = $row * 8 + $col;
say $seat; # 850
