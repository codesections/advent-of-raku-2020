#!/usr/bin/raku

sub MAIN() {

    my %ids;
    my $i = 0;
    for  "input/day13.input".IO.lines[1].split(/','/) -> $id {
        if $id ne 'x' {
            %ids{$id} = $i;
        }
        $i++;
    }

    my $interval = 1;
    my $earliest = 1;

    for %ids.keys -> $t {
        if $t eq 'x' {
            next;
        }

        my $current = $earliest;
        $earliest = 0;

        while (True) {
            if (($current + %ids{$t}) % $t == 0) {
              if ($earliest) {
                last;
              }

              $earliest ||= $current;
            }

            $current += $interval;
        }

        $interval = $current - $earliest;
    }

    say $earliest;
}
