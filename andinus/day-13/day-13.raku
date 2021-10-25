#!/usr/bin/env raku

unit sub MAIN(
    IO() $file = "input" #= input file
);

my @input = $file.IO.lines;

{
    my Int $start = @input[0].Int;
    my Int @bus_ids = @input[1].split(",").grep(/\d+/)>>.Int;

    stamp: for $start .. Inf -> $stamp {
        for @bus_ids -> $id {
            next unless $stamp %% $id;
            say "Part 1: " ~ $id * ($stamp - $start);
            last stamp;
        }
    }
}

{
    my @bus_ids = @input[1].split(",");

    my Int $stamp = 0;
    my Int $step = @bus_ids.first.Int;

    id: for @bus_ids.kv[2..*] -> $idx, $id {
        next id if $id eq "x";
        $stamp += $step until ($stamp + $idx) %% $id;
        $step lcm= $id;
    }

    say "Part 2: " ~ $stamp;
}
