#!/usr/bin/env raku

say [*] "input".IO.lines.race.combinations(3).first( -> @l { ( [+] @l ) == 2020 } );

