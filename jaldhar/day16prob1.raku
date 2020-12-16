#!/usr/bin/raku

sub MAIN() {

    my %ranges;
    my $invalid = 0;
    my $state = 'fields';

    for "input/day16.input".IO.lines -> $line {
        given $line {
            when '' {
                next;
            }

            when 'your ticket:' {
                $state = 'yours';
            }

            when 'nearby tickets:' {
                $state = 'nearby';
            }

            default {
                given $state {
                    when 'fields' {
                        my ($name, $range) = $line.split(':');

                        for $range.match(/ (\d+ '-' \d+) /, :g) -> $r {
                            for $r.split('-').map({ $_.Int; }).minmax -> $i {
                                %ranges{$i} = 1;
                            }
                        }
                    }

                    when 'your' {
                    }

                    when 'nearby' {
                        for $line.split(',') -> $value {
                            if %ranges{$value}:!exists {
                                $invalid += $value;
                            }
                        }
                    }

                    default {
                    }
                }
            }
        }
    }

    say $invalid;
}
