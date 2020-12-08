#!/usr/bin/raku

sub MAIN() {
    my $acc = 0;
    my $ip = 0;
    my @code;

    for "input/day08.input".IO.lines -> $line {
        my ($op, $arg) = $line.split(q{ });
        @code.push({ 'op' => $op, 'arg' => $arg, 'count' => '0' });
    }

    while ($ip < @code.elems) {
        my %instruction := @code[$ip];
        %instruction{'count'}++;

        if %instruction{'count'} > 1 {
            last;
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

    say $acc;
}
