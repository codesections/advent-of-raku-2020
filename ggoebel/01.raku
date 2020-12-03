my @input = 'input'.IO.lines;

# Part One
for @input.combinations(2) -> @a {
    if (@a.sum == 2020) {
        say "sum of "     ~ @a ~ " = " ~ [+] @a;
        say "product of " ~ @a ~ " = " ~ [*] @a;
        last;
    }
}

# Part Two
for @input.combinations(3) -> @a {
    if (@a.sum == 2020) {
        say "sum of "     ~ @a ~ " = " ~ [+] @a;
        say "product of " ~ @a ~ " = " ~ [*] @a;
        last;
    }
}

