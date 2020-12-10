#!/usr/bin/env raku
#
use v6;

for 'input/example'
.IO.slurp.lines 
{ 
	my @sl = .split: / ":" /; 

	my @policy = @sl[0].split: / \s /;

	my @policy-constraint-nt = @policy[0].split: '-';
	my $policy-contraint-nt-lower = Int.new: @policy-constraint-nt[0];
	my $policy-contraint-nt-upper = Int.new: @policy-constraint-nt[1];

	my $policy-constraint-c = @policy[1];

	my $password = @sl[1];

	with $password {
		/ <$policy-constraint-c> ** {$policy-contraint-nt-lower .. $policy-contraint-nt-upper} /;
		if $/ {
			say "OK: $_ ($/)"
		}else{
			say "NOK $_"
		}
	}
}
