#!/usr/bin/raku

sub MAIN() {

    my @numbers = "input/day09.input".IO.lines;
    my $invalid = 36_845_998;

    for 0 ..^ @numbers.elems -> $i {
        my $sum = @numbers[$i];
        my @set = [ @numbers[$i] ];

        for $i + 1 .. @numbers.elems -> $j {
            $sum += @numbers[$j];

            if $sum < $invalid {
                @set.push(@numbers[$j]);

            } elsif $sum == $invalid {
                @set.push(@numbers[$j]);
                say @set.min + @set.max;
                return;

            } else {
                last;
            }
        }
    }
}
