unit grammar Example2;
regex TOP { <tok4> <tok1> <tok5> };
regex tok1 { <tok2> <tok3> | <tok3> <tok2> };
regex tok2 { <tok4> <tok4> | <tok5> <tok5> };
regex tok3 { <tok4> <tok5> | <tok5> <tok4> };
token tok4 { 'a' };
token tok5 { 'b' };