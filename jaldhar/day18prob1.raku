#!/usr/bin/raku

sub parse(@tokens) {
    my @ops;
    my @terms;

    for @tokens -> $token {
        given $token {

            when /\d/ {
                @terms.push($token);
            }

            when '(' {
                @ops.push('(');
            }

            when ')' {
                while @ops and (my $x = @ops.pop and $x ne '(')
                {
                    @terms.push($x);
                }
            }
 
            default {
                while @ops {
                    if @ops.tail eq '(' {
                        last;
                    }

                    @terms.push(@ops.pop);
                }
                @ops.push($token);
            }
        }
    }

    while @ops {
        @terms.push(@ops.pop);
    }

    return @terms;
}

sub eval(@terms) {
    my @stack;

    for @terms -> $term {
        given $term {
            when /\d/ {
                @stack.push($term);
            }

            when '+' {
                my $a = @stack.pop;
                my $b = @stack.pop;
                @stack.push($b + $a);
            }

            when '-' {
                my $a = @stack.pop;
                my $b = @stack.pop;
                @stack.push($b - $a);
            }

            when '*' {
                my $a = @stack.pop;
                my $b = @stack.pop;
                @stack.push($b * $a);
            }

            when '/' {
                my $a = @stack.pop;
                my $b = @stack.pop;
                @stack.push($b / $a);
            }

            default {
                say $_;
            }
        }
    }

    return @stack.pop;
}

sub MAIN() {
    my $result;

    for "input/day18.input".IO.lines -> $line {
        my @tokens = $line.subst(/\s+/, q{}, :g).comb;
        $result += (@tokens ==> parse() ==> eval());
    }

    say $result;
}
