#!/usr/bin/env raku
use v6.d;

class Automaton {
    subset Layout of Str where {
        # all rows same length and contain only . L or #
        .lines>>.chars.unique == 1 and m/^^<[.L#]>+$$/
    }
    has Int ($.width, $.height);
    has Bool $.changed is rw = False;
    has Int $.tolerance is rw = 4;
    has @.a;

    multi method new (Layout $s, Int $tolerance? = 4) {
        self.new(
            :width( .pick.chars ),
            :height( .elems ),
            :a( .map({ [.comb] }) ),
            :tolerance($tolerance)
        )
        given $s.lines.cache;
    }

    method gist { join "\n", map { .join }, self.a }

    method is_occupied (Int $r, Int $c, $d --> Bool) {
        # out-of-bounds equals empty
        return False unless ?(0 <= $r < self.height and 0 <= $c < self.width);

        do given self.a[$r][$c] {
            when '#' { True }
            when 'L' { False }
            when '.' { False }
        }
    }

    method adj_occupied (Int $r, Int $c --> Int) {
        +( (-1, -1), (-1, 0), (-1, +1),
           ( 0, -1),          ( 0, +1),
           ( 1, -1), ( 1, 0), ( 1, +1)
        ).map({ self.is_occupied($r+.[0], $c+.[1], $_) }).grep({ ?$_ });
    }

    method seats_occupied {
        self.a.map({ @$_.grep('#').elems }).sum;
    }

    # provide postfix ++
    method succ {
        my Bool $changed = False;
        my $o = self.new(
            :$!width,
            :$!height,
            :a(gather for ^self.height -> $r { take [
                   gather for ^self.width -> $c {
                       take do given self.a[$r][$c] {
                           # If empty (L) and no adjacent seats occupied -> becomes occupied
                           # If occupied (#) and 4+ adjacent seats occupied -> becomes empty
                           when '.' { '.' }
                           when 'L' {
                               if self.adj_occupied($r, $c) == 0 {
                                   $changed = True;
                                   '#';
                               } else {
                                   'L';
                               }
                           }
                           when '#' {
                               if self.adj_occupied($r, $c) >= self.tolerance {
                                   $changed = True;
                                   'L';
                               } else {
                                   '#';
                               }
                           }
                       }
                   }
            ]} ),
            :$!tolerance
        );
        $o.changed = $changed  if $changed;
        $o;
    }
}

class Automaton2 is Automaton {
    method is_occupied (Int $r, Int $c, $d --> Bool) {
        # out-of-bounds equals empty
        return False unless ?(0 <= $r < self.height and 0 <= $c < self.width);

        do given self.a[$r][$c] {
            when '#' { True }
            when 'L' { False }
            when '.' { self.is_occupied($r+$d[0], $c+$d[1], $d) }
        }
    }
}

my $input = q:to/EOF/;
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    EOF

$input = 'input'.IO.slurp;
my $part1 = Automaton.new($input);
$part1.changed = True;
while ($part1.changed == True) {
    say $part1++;
    say '--';
}
say "";

my $part2 = Automaton2.new($input, 5);
$part2.changed = True;
while ($part2.changed == True) {
    say $part2++;
    say '--';
}

say "Part One: " ~ $part1.seats_occupied;
say "Part Two: " ~ $part2.seats_occupied;
