#!/usr/bin/env raku

my @program;

for 'input.txt'.IO.lines -> $line {
    $line ~~ / (\w+) ' ' (\S+) /;
    
    @program.push: {
        operation => $/[0].Str,
        argument => $/[1].Int,
    };
}

my $replacement-pos = 0;
my $pc = 0;
my $acc;
until $pc >= @program.end {
    my %pc;
    $pc = 0;
    $acc = 0;
    my $nop-jmp = 0;

    while !(%pc{$pc}:exists) && $pc <= @program.end {
        my $instruction = @program[$pc];
        %pc{$pc} = 1;

        # say "$pc: $instruction<operation> $instruction<argument>";

        my $operation = $instruction<operation>;
        if $operation eq 'nop' | 'jmp' {
            if $nop-jmp == $replacement-pos {
                $operation = $operation eq 'nop' ?? 'jmp' !! 'nop';
                # say "REPLACED";
            }
            $nop-jmp++;
        }

        given $operation {
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

    $replacement-pos++;
}

say $acc; # 1125
