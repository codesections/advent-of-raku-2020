#!/usr/bin/env raku

# Password grammar was taken from tyil's solution.
grammar Password {
    rule TOP { <num> '-' <num> <letter> ':' <password> }
    token num { \d+ }
    token letter { \w }
    token password { \w+ }
}

sub MAIN (
    # Part to run.
    Int $part where * == 1|2 = 1
) {
    my $valid_passwords = 0;

    for "input".IO.lines -> $entry {
        if Password.parse($entry) -> $match {
            if $part == 1 {
                my %chars;
                $match<password>.comb.map({ %chars{$_}++ });

                # Check if the letter exists in the password.
                next unless %chars{$match<letter>};

                # Check for length.
                next unless $match<num>[0].Int <= %chars{$match<letter>};
                next unless %chars{$match<letter>} <= $match<num>[1].Int;
            } elsif $part == 2 {
                my $combed = $match<password>.comb;
                my $first = $match<num>[0].Int - 1;
                my $second = $match<num>[1].Int - 1;

                next if $combed[$first] eq $combed[$second];
                next unless $combed[$first] eq $match<letter> || $combed[$second] eq $match<letter>;
            }
            # All checks were completed & this is a valid password.
            $valid_passwords++;
        }
    }
    say "Part $part: " ~ $valid_passwords;
}
