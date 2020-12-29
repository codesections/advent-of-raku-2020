#!/usr/bin/env raku

sub MAIN (
    Int $part where * == 1|2 = 1 #= part to run (1 or 2)
) {
    # Get all boarding passes.
    my @passes = "input".IO.lines;
    my @ids;

    for @passes -> $pass {
        my ($row, $column) = pass-seat($pass);
        push @ids, seat-id($row, $column);
    }
    @ids = @ids.sort;

    if $part == 1 {
        say "Part $part: " ~ @ids[*-1];
    } elsif $part == 2 {
        for @ids.kv -> $key, $id {
            next if $key == @ids.elems - 1;
            next unless @ids[$key + 1] == $id + 2;
            say "Part $part: " ~ $id + 1;
        }
    }
}

# seat-id returns the seat id from row & column number.
sub seat-id (
    Int $row, Int $column --> Int # seat id will be an integer.
) {
    return ($row.Int * 8) + $column[0].Int;
}

# pass-seat returns the seat row, column from boarding pass.
sub pass-seat (
    Str $pass --> List # row, column will be List of Int.
) {
    if $pass ~~ /^(<[F B]> ** 7) (<[L R]> ** 3)$/ -> $match {
        my @rows = [0..127];
        my @columns = [0..7];

        for $match[0].comb -> $char {
            @rows = @rows[0 .. * / 2 - 1] if $char eq 'F';
            @rows = @rows[* / 2 .. *] if $char eq 'B';
        }

        for $match[1].comb -> $char {
            @columns = @columns[0 .. * / 2 - 1] if $char eq 'L';
            @columns = @columns[* / 2 .. *] if $char eq 'R';
        }

        return @rows[0].Int, @columns[0].Int;
    }
}
