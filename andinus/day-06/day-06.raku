#!/usr/bin/env raku

sub MAIN (
    Int $part where * == 1|2 = 1 #= part to run (1 or 2)
) {
    my $input = slurp "input";
    my @answers = $input.chomp.split("\n\n");
    my $count = 0;

    for @answers -> $answer {
        my %yes;
        my @individual_answers = $answer.split("\n");
        %yes{$_} += 1 for @individual_answers.join.comb;

        if $part == 1 {
            $count += keys %yes;
        } elsif $part == 2 {
            for keys %yes {
                $count += 1 if %yes{$_} eq @individual_answers.elems;
            }
        }
    }
    say "Part $part: ", $count;
}
