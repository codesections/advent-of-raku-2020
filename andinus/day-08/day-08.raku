#!/usr/bin/env raku

# Instruction grammar seperates the operation & argument.
grammar Instruction {
    rule TOP { <operation> <argument> }
    token operation { acc|jmp|nop }
    token argument { .* }
}

my Int $repeated = 0;

sub MAIN (
    Int $part where * == 1|2 = 1 #= part to run (1 or 2)
) {
    # To match the numbers in instructions with array we just push an
    # element at 0th index.
    my @instructions = %(instruction => "", executed => 0),;

    for "input".IO.lines {
        push @instructions, %(
            instruction => $_.Str,
            executed => 0,
        );
    }

    my Int $acc;
    if $part == 1 {
        $acc = execute-from(@instructions, 1) if $part == 1;
    } elsif $part == 2 {
        for @instructions.kv -> $idx, $entry {
            next if $idx == 0;
            $repeated = 0;
            if Instruction.parse($entry<instruction>) -> $match {
                @instructions[$idx]<instruction> = "nop $match<argument>"
                if $match<operation> eq "jmp";

                @instructions[$idx]<instruction> = "jmp $match<argument>"
                if $match<operation> eq "nop";

                $acc = execute-from(@instructions, 1);

                @instructions[$idx]<instruction> = "$match<operation> $match<argument>";
                @instructions = reset-executed(@instructions);

                last if $repeated == 0;
            }
        }
    }
    say "Part $part: ", $acc;
}

sub reset-executed (
    @instructions is copy --> List
) {
    $_<executed> = 0 for @instructions;
    return @instructions;
}

# execute-from takes an index & executes instructions from that point.
# It returns the accumulator value.
sub execute-from (
    @instructions, Int $idx --> Int
) {
    my Int $acc = 0;

    return $acc unless @instructions[$idx];
    my $entry = @instructions[$idx];

    $repeated++ if $entry<executed>;
    return $acc if $entry<executed>;

    if Instruction.parse($entry<instruction>) -> $match {
        $entry<executed> = 1;
        given $match<operation> {
            when 'acc' {
                $acc += $match<argument>;
                $acc += execute-from(@instructions, $idx + 1);
            }
            when 'jmp' {
                $acc += execute-from(@instructions, $idx + $match<argument>);
            }
            when 'nop' {
                $acc += execute-from(@instructions, $idx + 1);
            }
        }
    }
    return $acc;
}
