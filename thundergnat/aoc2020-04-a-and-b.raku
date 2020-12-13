my @passport = slurp.split(/\n\n+/).map: { Hash.new(.words».split(':')) };

say 'A: ', +@passport.grep: { ( .<cid>:exists and +$_ == 8 ) || ( .<cid>:!exists and +$_ == 7 ) }

say 'B: ', +@passport.grep: {
    (( .<cid>:exists and +$_ == 8 ) || ( .<cid>:!exists and +$_ == 7 ) )
    && ( 1920 <= +.<byr> <= 2002 )
    && ( 2010 <= +.<iyr> <= 2020 )
    && ( 2020 <= +.<eyr> <= 2030 )
    && ( .<hgt> ∈ flat (150..193 Z~ 'cm' xx *), (59..76 Z~ 'in' xx *) )
    && ( .<hcl> ~~ /^ '#' <:HexDigit> ** 6 $/ )
    && ( .<ecl> ∈ <amb blu brn gry grn hzl oth> )
    && ( .<pid> ~~ /^ \d ** 9 $/ )
 }
