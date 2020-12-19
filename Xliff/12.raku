my $input;
my $d = 1; # N E S W
my $point = 0 + 0i;

sub computeCourse(:$waypoint = False) {
  for $input.lines {
    / $<i>=<[NESWFLR]> $<v>=(\d+) /;
    die "Could not parse instruction '$_'" unless $/;
    if $waypoint.not {
      my $v = $/<v>.Int;
      given $/<i> {
        when 'F' {
          given $d {
            when 0 | 2 { $point += $v * ($_ == 2 ?? -1 !! 1)  }
            when 1 | 3 { $point += $v * ($_ == 3 ?? -1 !! 1)i }
          }
        }

        when 'N' { $point += $v }
        when 'E' { $point += $v * i }
        when 'W' { $point -= $v * i }
        when 'S' { $point -= $v }

        when 'L' { $d = $d - ($v div 90); $d += 4 if $d < 0 }
        when 'R' { $d = $d + ($v div 90); $d -= 4 if $d > 3 }
      }
    } else {
      given $/<i> {
        my $v = $/<v>.Int;
        when 'F' { $point += $v * $*wp }

        when 'N' { $*wp += $v }
        when 'E' { $*wp += $v * i }
        when 'W' { $*wp -= $v * i }
        when 'S' { $*wp -= $v }

        my $turn = $v div 90;
        when 'L' { $*wp *= ($turn * -π/2).cos + ($turn * -π/2).sin * i }
        when 'R' { $*wp *= ($turn *  π/2).cos + ($turn *  π/2).sin * i }
      }
    }
  }

  sub coord ($v, :$ew) {
    do if $ew {
      $v.im < 0 ?? 'west'  !! 'east';
    } else {
      $v.re < 0 ?? 'south' !! 'north';
    } ~ ' ' ~ ($ew ?? $v.im !! $v.re).abs
  }

  say "Final position: { coord($point, :ew) }, { coord($point) }";
  say "Distance: { $point.re.abs + $point.im.abs }";
}

computeCourse;

my $*wp = 1 + 10i;
$point = 0 + 0i;
computeCourse(:waypoint);

INIT $input = 'input/12.input'.IO.slurp;
#INIT $input = q:to/INPUT/;
#  F10
#  N3
#  F7
#  R90
#  F11
#  INPUT
