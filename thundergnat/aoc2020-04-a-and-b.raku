my @passport = slurp.split(/\n\n+/).map: { Hash.new(.words».split(':')) };

say 'A valid: ', +@passport.grep: { (.<cid>:exists && +$_ == 8) or (.<cid>:!exists && +$_ == 7)}

# For some reason a grep with chained filters get wrong answer,
# so filter each attribute individually.

my $b-valid = 0;
for @passport {
    next unless ( .<cid>:exists && +$_ == 8) or (.<cid>:!exists && +$_ == 7 );
    next unless ( 1920 <= +.<byr> <= 2002 );
    next unless ( 2010 <= +.<iyr> <= 2020 );
    next unless ( 2020 <= +.<eyr> <= 2030 );
    next unless ( .<hgt> ∈ flat (150..193 Z~ 'cm' xx *), (59..76 Z~ 'in' xx *) );
    next unless ( .<hcl> ~~ /^ '#' <:HexDigit> ** 6 $/ );
    next unless ( .<ecl> ∈ <amb blu brn gry grn hzl oth> );
    next unless ( .<pid> ~~ /^ \d ** 9 $/ );
    ++$b-valid;
 }

 say 'B valid: ', $b-valid;


#`[ Wrong answer, even though the filters are exactly the same :-(

say 'B valid: ', +@passport.grep: {
    ( .<cid>:exists && +$_ == 8) or (.<cid>:!exists && +$_ == 7 )
    && ( 1920 <= +.<byr> <= 2002 )
    && ( 2010 <= +.<iyr> <= 2020 )
    && ( 2020 <= +.<eyr> <= 2030 )
    && ( .<hgt> ∈ flat (150..193 Z~ 'cm' xx *), (59..76 Z~ 'in' xx *) )
    && ( .<hcl> ~~ /^ '#' <:HexDigit> ** 6 $/ )
    && ( .<ecl> ∈ <amb blu brn gry grn hzl oth> )
    && ( .<pid> ~~ /^ \d ** 9 $/ )
 }

]
