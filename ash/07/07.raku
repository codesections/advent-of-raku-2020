#!/usr/bin/env raku

my @rules = 'input.txt'.IO.lines;

my %rules;
for @rules -> $rule {
    $rule ~~ m:g/ \w+ ' ' \w+ <?before ' bag'> /;
    my @colours = $/.map: *.Str;
    # say "@colours[0] <- {@colours[1..*].join(', ')}";

    for @colours[1..*] -> $inner {
        next if $inner eq 'no other';
        %rules{$inner}{@colours[0]} = 1;
    }
}

my %final;
unroll('shiny gold');
# say %final.keys.join(',');
say %final.keys.elems;

sub unroll($current) {
    my $outer = %rules{$current};
    next unless $outer;

    for $outer.keys -> $container {
        # say "'$current' can be found in $container";
        next if %final{$container};

        # say "\tDid not see $container yet";
        %final{$container} = 1;
        unroll($container);
    }
}

# 289
