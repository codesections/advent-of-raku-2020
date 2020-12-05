#!/usr/bin/raku

sub validate($passport) {
    my $present = 0;

    for $passport.match(/ (\S+) ':' (\S+) /, :g) -> ($key, $value) {
        given $key {
            when 'byr' {    # (Birth Year) - four digits; at least 1920 and at most 2002.
                $value ~~ / (\d+) /;
                if !$/ || $/.chars != 4 || $/ < 1920 || $/ > 2002 {
                    return False;
                }
                $present++;
            }

            when 'iyr' {    # (Issue Year) - four digits; at least 2010 and at most 2020.
                $value ~~ / (\d+) /;
                if !$/ || $/.chars != 4 || $/ < 2010 || $/ > 2020 {
                    return False;
                }
                $present++;
            }

            when 'eyr' {    # (Expiration Year) - four digits; at least 2020 and at most 2030.
                $value ~~ / (\d+) /;
                if !$/ || $/.chars != 4 || $/ < 2020 || $/ > 2030 {
                    return False;
                }
                $present++;
            }

            when 'hgt' {    # (Height) - a number followed by either cm or in:
                            # If cm, the number must be at least 150 and at most 193.
                            # If in, the number must be at least 59 and at most 76.
                $value ~~ / (\d+) (cm || in) /;
                if !$/ {
                    return False;
                }

                if $/[1] eq 'cm' && ($/[0] < 150 || $/[0] > 193) {
                    return False;
                } elsif $/[1] eq 'in' && ($/[0] < 59 || $/[0] > 76) {
                    return False;
                }
                $present++;
            }

            when 'hcl' {    # (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
                $value ~~ / ('#' <[0 .. 9 a .. f]>+) /;
                if !$/ || $/.chars != 7 {
                    return False;
                }
                $present++;
            }

            when 'ecl' {    # (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
                if $value ne < amb blu brn gry grn hzl oth >.any {
                    return False;
                }
                $present++;
            }

            when 'pid' {    # (Passport ID) - a nine-digit number, including leading zeroes.
                $value ~~ / (\d+) /;
                if !$/ || $/.chars != 9 {
                    return False;
                }
                $present++;
            }

            when 'cid' {    # (Country ID) - ignored, missing or not.
            }

            default {       # unknown field.
                return False;
            }
        }
    }

    if $present < 7 {   # Not enough fields
        return False;
    }

    return True;
}

sub MAIN() {
    my $count = 0;

    for "input/day04.input".IO.split("\n\n") -> $passport {
        if validate($passport) {
            $count++;
        }
    }

    say $count;
}
