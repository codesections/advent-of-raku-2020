#!/usr/bin/raku

sub MAIN() {

    my @numbers = "input/day09.input".IO.lines;

    for 25 ..^ @numbers.elems -> $i {
        my @valid =
            @numbers[$i - 25 ..^ $i].combinations(2).map({ @_[0] + @_[1]; });

        unless @valid.grep({ $_ == @numbers[$i] }) {
            say @numbers[$i];
            last;
        }
    }
}
