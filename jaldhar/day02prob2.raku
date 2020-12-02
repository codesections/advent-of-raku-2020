#!/usr/bin/raku

sub MAIN() {
    my $count = 0;

    for "input/day02.input".IO.lines -> $line {
        my ($first, $second, $letter, $password) =
            $line.match(/^ (\d+) '-' (\d+)  ' ' (.) ': ' (.+) $ /).list;
        $first = $first - 1;
        $second = $second - 1;

        my @pchars = $password.comb;

        if (!@pchars[$first] || !@pchars[$second]) {
            next;
        }

        if (@pchars[$first] eq $letter && @pchars[$second] !eq $letter) ||
        (@pchars[$second] eq $letter && @pchars[$first] !eq $letter) {
            $count++;
        }
    }

    say $count;
}
