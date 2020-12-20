#!/usr/bin/raku

sub mask(@mask, @mem) {
    my @result = @mem;

    for 0 ..^ @mask.elems -> $i {
        given @mask[$i] {
            when '1' {
                @result[$i] = '1';
            }

            when '0' {
                @result[$i] = '0';
            }

            default {
            }
        }
    }

    return :2(@result.join);
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
                %memory{$0} =
                    mask(@mask, sprintf('%0*d', @mask.elems, (0 + $1).base(2)).comb);
            }

            default {
            }
        }
    }

    say [+] %memory.values;
}
