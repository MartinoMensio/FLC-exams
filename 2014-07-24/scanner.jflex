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

token1 = "="([A-Z]{3}([A-Z]{2})*|[a-z]{4}([a-z]{2})*)"?"(([xy]{2}){3}([xy]{2})*)?

token2 = {hex_num}([:"."]{hex_num}){2}(([:"."]{hex_num}){2}(([:"."]{hex_num}){3})?)?

hex_num = [a-fA-F0-9]{2}([a-fA-F0-9]{2})?

email = [a-zA-Z0-9_"."]+"@"[a-zA-Z0-9]+"."(it|com|net)

identifier = [a-zA-Z_][a-zA-Z_0-9]*

comment = "/*" ~ "*/"
quoted_string = "\"" ~ "\""
uint = [0-9]|[1-9][0-9]*
real = {uint}?"."[0-9]+|{uint}"."[0-9]*

%%

"##"                { return sym(sym.SEP); }
":"                 { return sym(sym.C); }
";"                 { return sym(sym.S); }
","                 { return sym(sym.CM); }
"="                 { return sym(sym.EQ); }
"+"                 { return sym(sym.PLUS); }
"*"                 { return sym(sym.STAR); }
"("                 { return sym(sym.RO); }
")"                 { return sym(sym.RC); }
"["                 { return sym(sym.SO); }
"]"                 { return sym(sym.SC); }

"DISTANCE"          { return sym(sym.DISTANCE); }
"VALUE"             { return sym(sym.VALUE); }
"IN"                { return sym(sym.IN); }
"WRITE"             { return sym(sym.WRITE); }

{token1}            { return sym(sym.TOKEN1); }
{token2}            { return sym(sym.TOKEN2); }
{email}             { return sym(sym.EMAIL); }


//{uint}                { return sym(sym.UINT, Integer.parseInt(yytext()));}
{identifier}        { return sym(sym.ID, yytext()); }
{quoted_string}     { return sym(sym.QUOTED_STR, yytext()); }
{real}              { return sym(sym.REAL, Double.parseDouble(yytext())); }

{comment}           {;}
\r | \n | \r\n | " " | \t    {;}

// effects of this line (to be left as last rule):
// - commented: exception if input does not match
// - uncommented: prints on screen non-matching chars, continue scanning input
.                { System.out.println("Scanner Error: " + yytext()); }
