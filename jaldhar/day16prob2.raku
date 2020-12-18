#!/usr/bin/raku

sub findPossibleFields(%fields, @validlines) {
    my %possible;

    for 0 ..^ @validlines[*].elems -> $i {
        for %fields.keys -> $field {
            if @validlines[*;$i].all ∈ %fields{$field} {
                %possible{$field}.push($i);
            }
        }
    }

    return %possible;
}

sub order(%possible) {
    my %ordered;

    while %possible {
        for %possible -> $p {
            if $p.value.elems == 1 {
                %ordered{$p.key} = $p.value[0];
                for %possible -> $q {
                    $q.value = $q.value.grep({ $_ != ($p.value[0] // -1) });
                }
                %possible{$p.key}:delete;
            }
        }
    }

    return %ordered;
}

sub result(@yourticket, %ordered) {
    return [*]
        @yourticket[
            %ordered
            .grep({ $_.key ~~ / ^^ 'departure' / })
            .map({ $_.value })
        ];
}

sub MAIN() {

    my %fields;
    my %ranges;
    enum Section ( fields => 1, your => 2, nearby => 3 );
    my Section $section = Section::fields;
    my @validlines;
    my @yourticket;

    for "input/day16.input".IO.lines -> $line {
        given $line {
            when '' {
                next;
            }

            when 'your ticket:' {
                $section = Section::your;
            }

            when 'nearby tickets:' {
                $section = Section::nearby;
            }

            default {
                given $section {
                    when Section::fields {
                        my ($name, $range) = $line.split(':');

                        %fields{$name} = {};
                        for $range.match(/ (\d+ '-' \d+) /, :g) -> $r {
                            for $r.split('-').map({ $_.Int; }).minmax -> $i {
                                %fields{$name}{$i} = 1;
                                %ranges{$i} = 1;
                            }
                        }
                    }

                    when Section::your {
                        @yourticket = $line.split(',');
                    }

                    when Section::nearby {
                        my Bool $valid = True;
                        my @values = $line.split(',');
                        for @values -> $value {
                            if %ranges{$value}:!exists {
                                $valid = False;
                                last;
                            }
                        }

                        if $valid {
                            @validlines.push(@values);
                        }
                    }

                    default {
                    }
                }
            }
        }
    }

    say result(@yourticket, order(findPossibleFields(%fields, @validlines)));
}
