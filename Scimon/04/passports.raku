#!/usr/bin/env raku

grammar Passport {
    token TOP { <passport>+ % <sep> \n? } 
    token field-name { "byr"|"iyr"|"eyr"|"hgt"|"hcl"|"ecl"|"pid"|"cid" }
    token field-data { \S+ }
    token field { <field-name> ":" <field-data> }
    token field-row { <field>+ % ' ' }
    token passport { <field-row>+ % \n }
    token sep { \n \n }
}

class PassportActions {
    has @.passports;
    has Bool $.valid;
    
    method TOP($/) {
        @.passports = $<passport>>>.made;
    }
    method passport($/) {
        my @row = [ $<field-row>>>.made.map( *.Slip ) ];
        my $present = (@row.elems == 8) || (@row.elems == 7 && none(@row.map(*.key)) ~~ 'cid');
        my $valid = $present && ( [&&] @row>>.values.map( *[0]<valid> ) );
        make { fields => @row, valid => $valid, present => $present };
    }
    method field-row($/) {
        make [ $<field>>>.made ];
    }
    method field($/) {
        my $valid =  $.validate( $<field-name>.made, $<field-data>.made );
        my $data = {
            data => $<field-data>.made,
            valid => $valid;
        };
        make $<field-name>.made => $data;
    }
    method field-name($/) {
        make $/.Str;
    }
    method field-data($/) {
        make $/.Str;
    }
    multi method validate( $, $ ) { False }                                    
    multi method validate( "byr", UInt() $data ) {
        $data ~~ (1920..2002);
    }
    multi method validate("iyr", UInt() $data ) {
        $data ~~ (2010..2020);
    }
    multi method validate("eyr", UInt() $data ) {
        $data ~~ (2020..2030);
    }
    multi method validate("hgt", Str $data where { $data ~~ m/^ \d+ "cm" $/ } ) {
        my $m = $data ~~ m/^ $<hgt>=(\d+) "cm" $/;
        $m<hgt> ~~ (150..193);
    }
    multi method validate("hgt", Str $data where { $data ~~ m/^ \d+ "in" $/ } ) {
        my $m = $data ~~ m/^ $<hgt>=(\d+) "in" $/;
        $m<hgt> ~~ (59..76);
    }
    multi method validate("hcl", Str $data where { $data ~~ m/^ "#" <[0..9 a..f]> ** 6 $/ } ) {
        True;
    }
    multi method validate("ecl", Str $data where { $data ~~ "amb"|"blu"|"brn"|"gry"|"grn"|"hzl"|"oth" } ) {
        True;
    }
    multi method validate("pid", Str $data where { $data ~~ m/^ <[0..9]> ** 9 $/ } ) {
        True;
    }
    multi method validate("cid", $ ) {
        True;
    }
}

multi sub MAIN ( "test" ) {
    use Test;
    ok Passport.parse( "ecl:gry", :rule<field> );
    ok Passport.parse( "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd", :rule<field-row> );
    ok Passport.parse( "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd\nbyr:1937 iyr:2017 cid:147 hgt:183cm", :rule<passport> );
    ok Passport.parse( "example".IO.slurp );
    ok Passport.parse( "input".IO.slurp );
    {
        my $actions = PassportActions.new;
        Passport.parse( "invalid".IO.slurp, :$actions );
        is all($actions.passports>><valid>), False;
    }
    {
        my $actions = PassportActions.new;
        Passport.parse( "valid".IO.slurp, :$actions );
        is all($actions.passports>><valid>), True;
    }
    done-testing;
}

multi sub MAIN ( Str $file where * ~~ "input"|"example"|"valid"|"invalid" ) {
    my $actions = PassportActions.new;
    Passport.parse( $file.IO.slurp, :$actions );
    say $actions.passports.grep( -> $p { $p<present> } ).elems;
    say $actions.passports.grep( -> $p { $p<valid> } ).elems;
}
