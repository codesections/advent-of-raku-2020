unit grammar Example1;
regex TOP { <tok1> <tok2> };
token tok1 { 'a' };
regex tok2 { <tok1> <tok3> | <tok3> <tok1> };
token tok3 { 'b' };