import java_cup.runtime.*;

%%

%unicode
%cup
%line
%column
%class scanner

%{
    private Symbol sym(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    private Symbol sym(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
    
%}

hour = 1(0:(45:(1[2-9]|[2-5][0-9])|5[0-9]:[0-5][0-9])|[12](:[0-5][0-9]){2}|3:([01][0-9]:[0-5][0-9]|20:(0[0-9]|10)))

code = [%+-]{5}[%+-]{2}*[a-zA-Z0-9]*[a-zA-Z](-(4[13]|[0-3]?[13579])|[1-9]?[13579]|1([01][13579]|2[13]))?

point_name = [a-zA-Z_][a-zA-Z0-9_]*
attribute_name = [xyz]

real = [+-]?({uint}?"."[0-9]+|{uint}"."[0-9]*)
uint = [0-9]|[1-9][0-9]*

sep = ####*|\*\*\*\*(\*\*)*
comment = "/*" ~ "*/"
quoted_string = "\"" ~ "\""

%%

{sep}               { return sym(sym.SEP); }
"."                 { return sym(sym.DOT); }
":"                 { return sym(sym.C); }
","                 { return sym(sym.CM); }
";"                 { return sym(sym.S); }
"="                 { return sym(sym.EQ); }
"<"                 { return sym(sym.LESS); }
">"                 { return sym(sym.MORE); }
"["                 { return sym(sym.SO); }
"]"                 { return sym(sym.SC); }
"("                 { return sym(sym.RO); }
")"                 { return sym(sym.RC); }
"WHEN"              { return sym(sym.WHEN); }
"IS"                { return sym(sym.IS); }
"PRINT"             { return sym(sym.PRINT); }
"AND"               { return sym(sym.AND); }
"OR"                { return sym(sym.OR); }
"NOT"               { return sym(sym.NOT); }
"Z_STATS"           { return sym(sym.Z_STATS); }


"TRUE"              { return sym(sym.CONDITION, true); }
"FALSE"             { return sym(sym.CONDITION, false); }

{hour}              { return sym(sym.HOUR); }
{code}              { return sym(sym.CODE); }

{attribute_name}    { return sym(sym.ATTR_NAME, yytext()); }
{point_name}        { return sym(sym.POINT_NAME, yytext()); }
{quoted_string}     { return sym(sym.QUOTED_STR, yytext()); }
{real}              { return sym(sym.REAL, Double.parseDouble(yytext()));}

{comment}           {;}
\r | \n | \r\n | " " | \t    {;}

// effects of this line (to be left as last rule):
// - commented: exception if input does not match
// - uncommented: prints on screen non-matching chars, continue scanning input
//.                { System.out.println("Scanner Error: " + yytext()); }
