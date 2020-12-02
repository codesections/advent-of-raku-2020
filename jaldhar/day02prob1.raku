#!/usr/bin/raku

sub MAIN() {
    my $count = 0;

    for "input/day02.input".IO.lines -> $line {
        my ($min, $max, $letter, $password) =
            $line.match(/^ (\d+) '-' (\d+)  ' ' (.) ': ' (.+) $ /).list;
        my $matches = $password.match(/ $letter /, :g);
        if $matches >= $min && $matches <= $max {
            $count++;
        }
    }

    say $count;
}
