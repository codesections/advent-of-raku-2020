#!/usr/bin/env raku
#
use v6;

enum Moves (
	go-right => +3,
	go-down  => +1
);

sub is-tree (Str $c is rw){
	given $c {
		when '.' { $c = 'O' }
		when '#' { $c = 'X' }
	}
}

sub make-a-move (Int $position is rw, Int $move) {
	$position += $move
}

for gather {
	my $position = 0;
	for 'input/example'.IO.slurp.lines -> $l {
	
		my @la = $l.split("");

		make-a-move($position, go-right);
		is-tree(@la[$position]);

		take @la;
	}
} {
	.say
}
