#!/usr/bin/env raku
#
use v6;

sub go-right (Int $position is rw) {
	$position += +3
}

my \go-down = &next;

sub is-tree (Str $c is rw){
	given $c {
		when '.' { $c = 'O' }
		when '#' { $c = 'X' }
	}
}

my Str $report;

for gather {
	my $position = 0;
	for 'input/example'.IO.slurp.lines -> $l {
	
		my @la = $l.split("");

		is-tree(@la[$position]);
		go-right($position) 
			and $report ~= "\nright 3 ($position)";
		is-tree(@la[$position]);
		take @la;
		go-down 
			and $report ~= "\ndown 1 ($position)";
	}
} {
	.say
}

$report.say
