#!/usr/bin/raku

sub zero(@code) {
    for @code -> %instruction {
        %instruction{'count'} := 0;
    }
}

sub run(@code) {
    my $acc = 0;
    my $ip = 0;

    while ($ip < @code.elems) {
        my %instruction := @code[$ip];
        %instruction{'count'} := %instruction{'count'} + 1;

        if %instruction{'count'} > 1 {
            return -1;
        }

        given (%instruction{'op'}) {
            when 'acc' {
                $acc += %instruction{'arg'};
            }

            when 'jmp' {
                $ip += (%instruction{'arg'} - 1);
            }

            when 'nop' {
            }
            
        }

        $ip++;
    }

    return $acc;
}

sub MAIN() {
    my @code;

    for "input/day08.input".IO.lines -> $line {
        my ($op, $arg) = $line.split(q{ });
        @code.push({ 'op' => $op, 'arg' => $arg, 'count' => '0' });
    }

    for 0 ..^ @code.elems -> $i {
        given @code[$i]{'op'} {
            when 'nop' {
                @code[$i]{'op'} := 'jmp';
                my $result = run(@code);
                if $result == -1 {
                    zero(@code);
                    @code[$i]{'op'} := 'nop';
                } else {
                    say $result;
                    last;
                }
            }

            when 'jmp' {
                @code[$i]{'op'} := 'nop';
                my $result = run(@code);
                if $result == -1 {
                    zero(@code);
                    @code[$i]{'op'} := 'jmp';
                } else {
                    say $result;
                    last;
                }
            }
        }
    }
}
