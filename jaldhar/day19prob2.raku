#!/usr/bin/raku

sub MAIN() {
    enum State ( rules => 1,  messages => 2 );
    my State $parser = State::rules;
    my %rules;
    my @messages;

    for "input/day19.input".IO.lines -> $line {
        if $line eq q{} {
            $parser = State::messages;
        } else {
            given $parser {
                when State::rules {
                    my ($n, $rule) = $line.split(':');
                    if $rule ~~ / '|' / {
                        $rule = " ( $rule ) ";
                    }
                    %rules{$n} = $rule;
                }

                when State::messages {
                    @messages.push($line);
                }

                default {
                }
            }
        }
    }

    # cheating... I know.
    %rules{8} = " ( 42+ ) ";
    %rules{11} = " ( 42 ( 42 ( 42 ( 42 31 )? 31 )? 31 )? 31 ) ";

    while %rules{0} ~~ / (\d+) / {
        my $subst = $0;
        %rules{0} ~~ s/ (\d+) /%rules{$subst}/;
    }

    my $matcher = %rules{0};
    my $count = 0;

    for @messages -> $message {
        if $message.match(/^^ <$matcher> $$/) {
            $count++;
        }
    }

    say $count;
}
