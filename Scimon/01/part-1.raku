#!/usr/bin/env raku

say [*] "input".IO.lines.race.combinations(2).first( -> @l { ( [+] @l ) == 2020 } );
