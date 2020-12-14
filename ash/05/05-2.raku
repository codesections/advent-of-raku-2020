#!/usr/bin/env raku

my @seats = 'input.txt'.IO.lines.map: *.trans( < F B L R > => < 0 1 0 1 > );

@seats.=map({"0b$_".Int});
@seats.=sort;

say 1 + @seats[(^@seats.end).first({@seats[$_] + 1 != @seats[$_ + 1]})]; # 599
