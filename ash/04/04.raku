#!/usr/bin/env raku

my @passports = 'input.txt'.IO.slurp.split("\n\n");

my $valid = 0;
for @passports -> $passport {
    my $fields = ($passport.words.map: *.split(':').first).sort.join;    
    $valid++ if $fields eq one <byrcidecleyrhclhgtiyrpid byrecleyrhclhgtiyrpid>;
}

say $valid; # 196
