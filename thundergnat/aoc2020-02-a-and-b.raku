my $a-valid = 0;
my $b-valid = 0;

for (lines) {
    my ($min, $max, $letter, $pass) = ($_ ~~ /(\d+)'-'(\d+)\s+(\w)':'\s+(\w+)/)».Str;
     ++$a-valid if (+$min..+$max).ACCEPTS: +$pass.comb($letter);
     ++$b-valid if $pass.comb[$min-1] eq $letter xor $pass.comb[$max-1] eq $letter;
}

say "A: $a-valid";
say "B: $b-valid";
