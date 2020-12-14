#!/usr/bin/env raku

unit sub MAIN (
  #| Path to input file
  IO() :$file where *.f = ( .sibling('input/' ~ .extension('txt').basename) with $?FILE.IO ),
  #| Part of the exercise (1 or 2)
  Int  :$part where * == 1|2 = 1,
  --> Nil
);

say do given
  $file.lines.map(+*).sort.List.&({ 0, |$_, .[*-1]+3 }),
  $part
-> ( @jolts, $_ ) {

  when 1 {
    @jolts.rotor(2 => -1).map({ [R-] $_ }).Bag.Hash.&({ [*] .{1, 3} });
  }

  when 2 {
    # A hash of each key, where the values are all the keys which are
    # between 1 and 3 jolts up.
    my %paths = @jolts[0..*-2].keys.map(-> $i {
      $i => ($i X+ 1..3).grep({
        @jolts[$_]:exists && @jolts[$_] - @jolts[$i] ≤ 3
      }).List
    });

    # A junction is an adapter which connects with only a single other adapter
    # i.e. separated by 3 jolts. It must be present in all valid combinations.
    my UInt (@keys, $junction, $result) X= 0;
    # We can take the number of combinations that reach every junction and
    # multiply those together for the final result.
    my UInt @results;
    loop {
      if !@keys {
        @results.push($result);
        last if %paths{$junction}:!exists;
        $result = 0;
        @keys = $junction;
      }

      @keys = gather {
        for @keys -> $i {
          if %paths{$i}.elems > 1 {
            %paths{$i}.Slip.take;
          }
          else {
            $junction = $i + 1 unless $result++;
          }
        }
      };
    }

    [*] @results;
  }

}
