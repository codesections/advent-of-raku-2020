#!/usr/bin/raku

sub MAIN() {
    my %bags;

    for "input/day07.input".IO.lines -> $line {
        my $key = $line.match( /(^^ \w+ ' ' \w+)/ );
        my @values = $line.match(/[\d+ ' '] <(\w+ ' ' \w+)> /, :g);
        %bags{$key} = @values;
    }

    my @valid = %bags.keys.grep({ %bags{$_}.values.grep('shiny gold'); });
    my $count = @valid.elems;
    my @seen = @valid;

    while @valid.elems {

        my $v = @valid[0];
        @valid.shift;

        for %bags.keys -> $key {
            if %bags{$key}.values.grep($v) && !@seen.grep($key) {
                @valid.push($key);
                @seen.push($key);
                $count++;
            }
        }

    }

    say $count;
}
