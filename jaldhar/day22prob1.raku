#!/usr/bin/raku

sub MAIN() {
    my @p1;
    my @p2;
    my @current;

    for "input/day22.input".IO.lines -> $line {
        given $line {
            when 'Player 1:' {
                @current := @p1;
            }

            when 'Player 2:' {
                @current := @p2;
            }

            when '' {
            }

            default {
                @current.push($line.Int);
            }
        }
    }

    while (True) {
        my $a = @p1.shift;
        my $b = @p2.shift;

        if ($a > $b) {
            @p1.push($a);
            @p1.push($b);
        } elsif ($b > $a) {
            @p2.push($b);
            @p2.push($a);
        }

        if @p1.elems == 0 {
            @current := @p2;
            last;
        } elsif @p2.elems == 0 {
            @current := @p1;
            last;
        }
    }

    my @weights = (1 .. @current.elems).reverse;
    say [+] (@current Z @weights).map({ @_[0] * @_[1]; })

}