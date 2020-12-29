#!/usr/bin/raku

sub MAIN() {
    my %bags;

    for "input/day07.input".IO.lines -> $line {
        my $key = $line.match( /(^^ \w+ ' ' \w+)/ );
        my @values = $line.match(/(\d+ ' ' \w+ ' ' \w+) /, :g);
        %bags{$key} = @values;
    }

    my @valid = ('shiny gold');
    my $count = 0;

    while @valid.elems {

        my $v = @valid[0];
        @valid.shift;

        for %bags{$v}.values -> $value {
            my ($n, $key) = $value.match(/(\d+) ' ' (\w+ ' ' \w+) /).list;
            $count += $n;
            for (0 ..^ $n) {
                @valid.push($key);
            }
        }

    }

    say $count;
}
