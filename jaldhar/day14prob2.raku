#!/usr/bin/raku

sub mad(%memory, @mask, @mem, $result) {
    my $floating = 0;
    my @address = @mem;
 
    for 0 ..^ @mask.elems -> $i {
        given @mask[$i] {
            when '1' {
                @address[$i] = '1';
            }

            when '0' {
            }

            when 'X' {
                @address[$i] = 'X';
                $floating++;
            }

            default {
            }
        }
    }
 
    for [X] (0, 1) xx $floating -> @floats {
        my $pos = 0;
        my $loc =
            :2(@address.map({ $_ eq 'X' ?? @floats[$pos++] !! $_; }).join);
        %memory{$loc} = $result;
    }
}

sub MAIN() {
    my %memory;
    my @mask;

    for "input/day14.input".IO.lines -> $line {
        given $line {
            when /^^ 'mask = ' (.+) / {
                @mask = $0.comb;
            }

            when /^^ 'mem[' (\d+) '] = ' (.+) / {
                mad(%memory, @mask,
                    sprintf('%0*d', @mask.elems, (0 + $0).base(2)).comb, $1);
            }

            default {
            }
        }
    }

    say [+] %memory.values;
}
