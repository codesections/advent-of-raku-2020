#!/usr/bin/env raku
use v6.d;

grammar HGC {
    rule TOP  { <inst>+ }
    rule inst { <op> <arg> }
    token op  { 'acc' | 'jmp' | 'nop' }
    token arg { <[+-]> \d+ }
}

class HGCActions {
    has $!stack = [];

    method inst ($/) { $!stack.push( %( op => ~$<op>, arg => +$<arg> ) ) }

    method exec {
        my ($pos, $acc) = (0, 0);
        for $!stack.list { .<visit> = 0 }

        while $pos < $!stack.elems {
            my ($op, $arg) = $!stack[$pos]<op arg>;
            return (1, $acc)  if ++$!stack[$pos]<visit> > 1; # Err Loop
            given $op {
                when 'nop' { $pos++ }
                when 'acc' { $pos++; $acc += $arg }
                when 'jmp' { $pos += $arg }
            };
        }

        return (0, $acc);
    }

    method ophack {
        for $!stack.grep({ .<op> ~~ /[nop | jmp]/ }) {
            .<op> = .<op> eq 'nop' ?? 'jmp' !! 'nop';
            given self.exec { when .[0] == 0 { return .[1]} }
            .<op> = .<op> eq 'nop' ?? 'jmp' !! 'nop';
        }
    }
}

sub MAIN (
        IO() :$input where *.f     = $?FILE.IO.sibling('input'),
        Int  :$part where * == 1|2 = 1, # Solve Part One or Part Two?
        --> Nil
) {
    my $a = HGCActions.new();
    HGC.parse($input.slurp, :actions($a));
    given $part {
        when 1 { say $a.exec[1] }
        when 2 { say $a.ophack}
    }
}

# Tests (run with `raku --doc -c [THIS_FILE_NAME]`)
DOC CHECK {
    my $input = q:to/§/;
        nop +0
        acc +1
        jmp +4
        acc +3
        jmp -3
        acc -99
        acc +1
        jmp -4
        acc +6
        §

    my $a = HGCActions.new();
    HGC.parse($input, :actions($a));

    say "Part One: " ~ $a.exec[1];
    say "Part Two: " ~ $a.ophack;
}

