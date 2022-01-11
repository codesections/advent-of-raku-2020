#!/usr/bin/raku

sub getkey($subjectnumber, $loopsize) {
    my $value = 1;
    my $divisor = 20201227;

    for 1 .. $loopsize {
        $value *= $subjectnumber;
        $value %= $divisor;
    }

    return $value;
}

sub getloopsize($pk) {
    my $value = 1;
    my $subjectnumber = 7;
    my $divisor = 20201227;
    my $loopsize = 0;

    while ($value != $pk) {
        $value *= $subjectnumber;
        $value %= $divisor;
        $loopsize++;
    }

    return $loopsize;
}

sub MAIN() {
    my ($door, $card) = "input/day25.input".IO.lines;
    my $doorloop = getloopsize($door);
    my $cardloop = getloopsize($card);
    my $encryptionkey = getkey($door, $cardloop);

    say $encryptionkey;
}