#!/usr/bin/env raku

my $window = 25;

my @data = 'input.txt'.IO.lines.map: *.Int;

# Variant 1

for $window ..^ @data  -> $i {
    if @data[$i] != any(@data[$i - $window ..^ $i].combinations(2).map: *.sum) {
        say @data[$i];
        last;
    }
}

# Variant 2

say @data[($window ..^ @data).first({
    @data[$_] != any(@data[$_ - $window ..^ $_].combinations(2).map: *.sum)
})];

# 29221323
