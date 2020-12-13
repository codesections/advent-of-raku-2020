#!/usr/bin/raku

sub MAIN() {

    my ($t, $ids) = "input/day13.input".IO.lines;
    my @buses  = $ids.split(/','/).grep({ $_ ne 'x'});
    my %waits;

    for @buses -> $bus {
        my $time = $t + $bus - (($t + $bus) % $bus);
        %waits{$bus} = ($time - $t);
    }

    my $earliest = %waits.sort({ $^a.value <=> $^b.value }).first;
    say $earliest.key * $earliest.value;
}

