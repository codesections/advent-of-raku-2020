#!/usr/bin/env raku

my @rules = 'input.txt'.IO.lines;

my %rules;
for @rules -> $rule {
    $rule ~~ /^ (\w+ ' ' \w+) /;
    my $container-colour = $/[0].Str;

    for $rule ~~ m:g/ (\d+) ' ' (\w+ ' ' \w+) / -> $content {
        my $number = $content[0].Int;
        next unless $number;

        my $colour = $content[1].Str;
        say "In $container-colour, $colour ($number)";

        %rules{$container-colour}{$colour} = $number;
    }
}

dd $_ for %rules;

say pack-bag('shiny gold');

sub pack-bag($container-colour) {
    my $total = 0;
    
    for %rules{$container-colour}.kv -> $inner-colour, $count {
        say "$container-colour <- $inner-colour ($count) : $total";
        $total += $count * pack-bag($inner-colour);
    }

    return $total; 
}
