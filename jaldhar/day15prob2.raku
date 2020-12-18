#!/usr/bin/raku

constant MAXTURNS = 30_000_000;

sub MAIN() {
    my @numbers = "input/day15.input".IO.lines[0].split(',');
    my %occurs;

    my $previous;
    for 1 .. @numbers.elems -> $i {
        $previous = @numbers[$i - 1];
        %occurs{@numbers[$i - 1]}.push($i);
    }

    my $current;
    for @numbers.elems ^.. MAXTURNS -> $t {

        if %occurs{$previous}.elems == 1 {
            $current = 0;
        } else {
            $current = %occurs{$previous}[1] - %occurs{$previous}[0];
        }

        if %occurs{$current}.elems == 2 {
            %occurs{$current}.shift;
        }
        %occurs{$current}.push($t);

        $previous = $current;
    }

    say $current;
}