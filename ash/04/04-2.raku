#!/usr/bin/env raku

my @passports = 'input.txt'.IO.slurp.split("\n\n");

my $valid = 0;
for @passports -> $passport {
    my %required = <byr iyr eyr hgt hcl ecl pid>.map: * => 1;

    for $passport.words.map: *.split(':') -> ($key, $value) {
        my $ok = 0;
        given $key {
            when 'byr' {
                $ok = 1 if $value ~~ /^\d\d\d\d$/ && 1920 <= $value <= 2002;
            }
            when 'iyr' {
                $ok = 1 if $value ~~ /^\d\d\d\d$/ && 2010 <= $value <= 2020;
            }
            when 'eyr' {
                $ok = 1 if $value ~~ /^\d\d\d\d$/ && 2020 <= $value <= 2030;
            }
            when 'hgt' {
                if ($value ~~ /^ (\d+) (cm|in) $/) {
                    $ok = 1 if ($/[1] eq 'cm' && 150 <= $/[0] <= 193) or ($/[1] eq 'in' && 59 <= $/[0] <= 76);
                }
            }
            when 'hcl' {
                $ok = 1 if $value ~~ /^ '#' <[0..9a..f]> ** 6 $/;
            }
            when 'ecl' {
                $ok = 1 if $value ~~ /^[amb|blu|brn|gry|grn|hzl|oth]$/;
            }
            when 'pid' {
                $ok = 1 if $value ~~ /^ \d ** 9 $/;
            }
        }

        %required{$key}:delete if $ok;
    }

    $valid++ unless %required.keys;
}

say $valid; # 114
