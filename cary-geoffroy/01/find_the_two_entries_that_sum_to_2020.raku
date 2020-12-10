#!/usr/bin/env raku

use v6;

say 
gather 
{ 
	for 'input/example'
	.IO.slurp.lines
	.combinations(2) 
	{ 
		([+] $_) == 2020 
		and take [*] $_ 
	}
}
