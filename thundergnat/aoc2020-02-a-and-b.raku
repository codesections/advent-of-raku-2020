my $a-valid = 0;
my $b-valid = 0;

for @*ARGS[0].IO.lines {
    my ($min, $max, $letter, $pass) = ($_ ~~ /(\d+)'-'(\d+)\s+(\w)':'\s+(\w+)/)».Str;
     ++$a-valid if (+$min..+$max).ACCEPTS: +$pass.comb($letter);
     ++$b-valid if $pass.comb[$min-1] eq $letter xor $pass.comb[$max-1] eq $letter;
}

say "Valid 02 part a: $a-valid";
say "Valid 02 part b: $b-valid";
