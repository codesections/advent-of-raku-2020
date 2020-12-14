#!/usr/bin/env raku

my @program;

for 'input.txt'.IO.lines -> $line {
    $line ~~ / (\w+) ' ' (\S+) /;
    
    @program.push: {
        operation => $/[0].Str,
        argument => $/[1].Int,
    };
}

my %pc;
my $pc = 0;
my $acc = 0;

while !(%pc{$pc}:exists) {
    my $instruction = @program[$pc];
    %pc{$pc} = 1;

    # say "$pc: $instruction<operation> $instruction<argument>";

    given $instruction<operation> {
        when 'nop' {
            $pc++;
        }
        when 'acc' {
            $acc += $instruction<argument>;
            $pc++;
        }
        when 'jmp' {
            $pc += $instruction<argument>;
        }
    }

}

say $acc; # 1137
