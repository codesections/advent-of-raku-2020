#!/usr/bin/env raku

sub MAIN (
    Int $part where * == 1|2 = 1 #= part to run (1 or 2)
) {
    my %bag;
    my Int $count = 0;
    my @valid_bags = "shiny gold",;

    for "input".IO.lines -> $entry {
        if $entry ~~ /^(.*) \s bags \s contain (.*)./ -> $match {
            my $bag = $match[0];
            for $match[1].split(", ") {
                if $_ ~~ /(\d) \s (.*) \s bag/ -> $contain_bag {
                    push %bag{$bag}, {
                        count => $contain_bag[0].Int,
                        bag => $contain_bag[1].Str
                    };
                }
            }
        }
    }

    if $part == 1 {
        MAIN: while True {
            my $previous_count = $count;
            for keys %bag {
                for @(%bag{$_}) -> $contain {
                    push @valid_bags, $_ if @valid_bags ∋ $contain<bag>;
                }
            }

            $count = 0;
            COUNT: for keys %bag {
                for @(%bag{$_}) -> $contain {
                    if @valid_bags ∋ $contain<bag> {
                        $count++;
                        next COUNT;
                    }
                }
            }
            last MAIN if $previous_count == $count;
        }
    } elsif $part == 2 {
        $count = count-bags(%bag, 'shiny gold');
    }
    say "Part $part: ", $count;
}

# count-bags takes %bag & the bag for which we have to count the bags
# & returns the count. Count here means the number of bags that will
# be inside $bag.
sub count-bags (
    %bag, Str $bag --> Int # count will be an integer.
) {
    return 0 unless %bag{$bag};
    my Int $count = 0;

    for @(%bag{$bag}) {
        my $sub_bags = count-bags(%bag, $_<bag>);
        $count += $_<count>;
        unless $sub_bags == 0 {
            $count += $_<count> * $sub_bags;
        }
    }
    return $count;
}
