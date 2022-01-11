#!/usr/bin/raku

sub game(@p1 is copy, @p2 is copy) {
    my SetHash $seen;

    while (@p1.elems && @p2.elems) {

        if ('|' ~ @p1.join ~ '|' ~ @p2.join) ∈ $seen {
            return (@p1, []);
        }
        $seen{'|' ~ @p1.join ~ '|' ~ @p2.join} = 1;

        my $a = @p1.shift;
        my $b = @p2.shift;

        if @p1.elems >= $a && @p2.elems >= $b {

            my (@q1, @q2) := game(@p1[0 ..^ $a], @p2[0 ..^ $b]);

            if @q1.elems == 0 {
                @p2.push($b, $a);
            } elsif @q2.elems == 0 {
                @p1.push($a, $b);
            }

        } else {

            if ($a > $b) {
                @p1.push($a, $b);
            } elsif ($b > $a) {
                @p2.push($b, $a);
            }
        }
    }

    return (@p1, @p2);

}

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


    my (@q1, @q2) := game(@p1, @p2);
    @current :=  (@q1.elems == 0) ?? @q2 !! @q1;

    my @weights = (1 .. @current.elems).reverse;
    say [+] (@current Z @weights).map({ @_[0] * @_[1]; })

}