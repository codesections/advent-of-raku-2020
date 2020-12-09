#!/usr/bin/env raku

sub MAIN (
    # Part to run.
    Int $part where * == 1|2 = 1
) {
    my $input = slurp "input";
    my @passports = $input.split("\n\n");
    my $valid_passports = 0;

    MAIN: for @passports -> $passport {
        my %fields;

        for $passport.words -> $field {
            my ($key, $value) = $field.split(":");
            %fields{$key} = $value;
        }

        # Check for fields that are strictly required. `cid' can
        # be skipped. Skip this passport if it's not valid.
        for <byr iyr eyr hgt hcl ecl pid> -> $field {
            next MAIN unless %fields{$field};
        }

        # Do validation in part 2.
        if $part == 2 {
            next MAIN unless (
                (1920 ≤ %fields{<byr>} ≤ 2002)
                and (2010 ≤ %fields{<iyr>} ≤ 2020)
                and (2020 ≤ %fields{<eyr>} ≤ 2030)
                and (<amb blu brn gry grn hzl oth> ∋ %fields{<ecl>})
                and (%fields{<pid>} ~~ /^\d ** 9$/)
                and (%fields{<hcl>} ~~ /^'#' <[\d a..f]> ** 6/)
            );
            given substr(%fields{<hgt>}, *-2) {
                when 'cm' {
                    next MAIN unless 150 ≤ substr(%fields{<hgt>}, 0, *-2) ≤ 193;
                }
		when 'in' {
                    next MAIN unless 59 ≤ substr(%fields{<hgt>}, 0, *-2) ≤ 76;
                }
                default { next MAIN; }
	    }
        }
        $valid_passports++;
    }
    say "Part $part: " ~ $valid_passports;
}
