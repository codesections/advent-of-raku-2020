my @program = lines;

my $instruction-pointer = 0;
my $accumulator = 0;
my %lines;

loop {
    last if %lines{$instruction-pointer};
    %lines{$instruction-pointer}++;
    my $line = @program[$instruction-pointer];
    eval $line;
}

say 'A: ', $accumulator;



for @program.grep( {.contains: 'jmp'|'nop' }, :k ) -> $flip {
    $instruction-pointer = 0;
    $accumulator = 0;
    %lines = ();
    loop {
        last if %lines{$instruction-pointer};
        %lines{$instruction-pointer}++;
        my $line = @program[$instruction-pointer];
        if $instruction-pointer == $flip {
            my ($i, $v) = $line.words;
            $i = ($i eq 'nop' ?? 'jmp' !! 'nop');
            $line = "$i $v";
        }
        eval $line;
        say 'B: ', $accumulator and exit if $instruction-pointer + 1 > +@program;
    }
}

sub eval ($instruction) {
    my ($i, $v) = $instruction.words;
    given $i {
        when 'acc' { $accumulator += $v; ++$instruction-pointer }
        when 'jmp' { $instruction-pointer += $v }
        default    { ++$instruction-pointer }
    }
}
