use v6.d;

# Advent of Code 2020 - Game Console
# Used in day 8

enum ConsoleState <INIT RUN TERM LOOP ERR>;

grammar ConsoleCode
{
    rule TOP { <instruction>+ }

    rule instruction { <operation> <argument> }

    token operation { 'nop' | 'acc' | 'jmp' }
    token argument { [ '+' | '-' ] \d+ }
}

class GameConsole
{
    has Str $.bootcode;
    has Bool $.verbose = False;

    has @.instr;
    has Int $!ptr;
    has Int $.acc;
    has Int @!visited;
    has ConsoleState $.state;

    submethod TWEAK
    {
        ConsoleCode.parse($!bootcode, :actions(self)) or die "Invalid boot code passed";
        self.initialize;

        say "> Boot code parsed ({+@!instr} instructions)." if $!verbose;
    }

    method instruction($/)
    {
        @!instr.push: [~$<operation>, +$<argument>];
    }

    method initialize
    {
        $!ptr = 0;
        $!acc = 0;
        @!visited = ();
        $!state = INIT;
    }

    method run
    {
        $!state = RUN;
        loop {
            if $!ptr ≥ @!instr {
                $!state = TERM;
                return;
            }
            elsif ($!ptr < 0) {
                $!state = ERR;
                return
            }
            elsif @!visited[$!ptr] {
                $!state = LOOP;
                return;
            }

            @!visited[$!ptr]++;
            say "> $!ptr: @!instr[$!ptr]" if $!verbose;
            self.execute(|@!instr[$!ptr]);
            $!ptr++;
            say "     [ptr=$!ptr, acc=$!acc]" if $!verbose;
        }
    }

    multi method execute('nop', Int $argument) { }
    multi method execute('acc', Int $argument) { $!acc += $argument }
    multi method execute('jmp', Int $argument) { $!ptr += $argument-1 }
    multi method execute(Str $instruction, Int $argument)
    {
        die "Invalid instruction '$instruction'!";
    }
}
