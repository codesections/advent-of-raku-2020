#!/usr/bin/env raku
use v6.d;

my ($depart, $line) = 'input'.IO.slurp.split("\n");
$depart .= Int;

say "Part One: " ~
[*] $line.split(',').grep(none 'x')».Int
         .map({ $_, $_ - ($depart) mod $_ })
         .min({ .[1] })
         .flat;

# index of @l is the offset from factor
my @l = $line.split(',');
my ($r, $factor) = (0, @l[0].Int);
for 1..^@l -> $i {
    next  if @l[$i] eq 'x';
    $r = ($r, {$_ + $factor} ... -> $a { ($a + $i) mod @l[$i].Int == 0 }).tail;
    $factor *= @l[$i];
}
say "Part Two: $r";


my $fubar = q:to/END/;
    4  3
 1  .  .
 2  .  .
 3  .  D
 4  D  .
 5  .  .
*6  .  D
 7  .  .
 8  D  .
 9  .  D
 10 .  .
 11 .  .
 12 D  D
 13 .  .
 14 .  .
 15 .  D
*16 D  .
 17 .  .
 18 .  D
END
