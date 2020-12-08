#!/usr/bin/env raku

unit sub MAIN (
  #| Path to input file
  IO() :$file where *.f = ( .sibling('input/' ~ .extension('txt').basename) with $?FILE.IO ),
  #| Part of the exercise (1 or 2)
  Int  :$part where * == 1|2 = 1,
  Bool :$step = False,
  Bool :$log  = $step,
  --> Nil
);

loop (
  my Int:D ( $i, $acc ) is default(0);
  $i < my @lines := @($file.lines);
) {
  LAST $acc.say;

  state Bool:D $switch is default(False);
  state UInt:D ( @idxs, @changed );

  say sprintf "% @lines.elems.chars()u: %s", $i + 1, @lines[$i] if $log;
  prompt if $step;

  when $i ∈ @idxs {
    say 'LOOP DETECTED' if $log;

    given $part {
      when 1 { last }

      when 2 {
        ( $acc, $i, $switch ) X= Nil;
        @idxs = Empty;
      }
    }
  }

  @idxs.push($i);

  if @lines[$i] ~~ /^ ( <[a..z]>+ ) ' ' ( <[+-]> <.digit>+ ) $/ {
    given $ = $/[0] <-> $_ {
      use MONKEY-SEE-NO-EVAL;

      when 'acc' {
        EVAL '$acc = $acc' ~ $/[1];
      }

      if $part == 2 && !$switch && $i ∉ @changed {
        $switch = True;
        $_      = $_ eq 'jmp' ?? 'nop' !! 'jmp' when <jmp nop>.any;

        say "SWAP $/[0] TO $_" if $log;
        @changed.push($i);
      }

      when 'jmp' {
        EVAL '$i = $i' ~ $/[1];
        next;
      }
    }
  }

  $i++;
}
