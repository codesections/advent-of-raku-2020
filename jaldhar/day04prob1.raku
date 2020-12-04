#!/usr/bin/raku

sub MAIN() {
    my $count = 0;
    my @passports;

    for "input/day04.input".IO.split("\n\n") -> $record {
        my @fields = $record.match(/ <(\S+)> (':' \S+) /, :g).list;
        if @fields.elems == 8 || (@fields.elems == 7 && @fields.any ne 'cid') {
            $count++;
        }
    }

    say $count;
}
