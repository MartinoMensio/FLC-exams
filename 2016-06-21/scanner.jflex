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

code = [xyz]{6}[xyz]{2}*"|"("-"3[13579Bb]|"-"[12]{hex_odd}|"-"?{hex_odd}|[1-9Aa-fA-F]{hex_odd}|[1-9][0-9a-fA-F]{hex_odd}|[Aa][0-9Aa]{hex_odd}|[Aa][Bb][135])?

hex_odd = [13579BbDdFf]

hour = 1(0":"(1(1":"(1[2-9]|[25][0-9])|[2-9]":"[0-5][0-9])|[2-5][0-9]":"[0-5][0-9])|[1-4](":"[0-5][0-9]){2}|5":"([12][0-9]":"[0-5][0-9]|3([0-5]":"[0-5][0-9]|6":"([0-3][0-9]|4[0-7]))))

number = {bin_num}(["+"".""-"]{bin_num}){3}(["+"".""-"]{bin_num}){2}?

bin_num = [01]{3}[01]{12}?

state_name = [A-Z][A-Z0-9_]*

attribute_name = [a-z]+

comment = "/*" ~ "*/"
quoted_string = "\"" ~ "\""
signed_integer = ["+""-"]?([0-9]|[1-9][0-9]*)

%%

"##"                { return sym(sym.SEP); }
"="                 { return sym(sym.EQ); }
"["                 { return sym(sym.SO); }
"]"                 { return sym(sym.SC); }
","                 { return sym(sym.CM); }
";"                 { return sym(sym.S); }

"INIT"              { return sym(sym.INIT); }
"DEFAULT"           { return sym(sym.DEFAULT); }
"WHEN"              { return sym(sym.WHEN); }
"DO"                { return sym(sym.DO); }
"DONE"              { return sym(sym.DONE); }
"PRINT"             { return sym(sym.PRINT); }
"CASE"              { return sym(sym.CASE); }
"NEXT"              { return sym(sym.NEXT); }
"=="                { return sym(sym.EQEQ); }
"||"                { return sym(sym.OR); }
"&&"                { return sym(sym.AND); }
"!"                 { return sym(sym.NOT); }
"("                 { return sym(sym.RO); }
")"                 { return sym(sym.RC); }
"."                 { return sym(sym.DOT);}

{code}              { return sym(sym.CODE); }
{hour}              { return sym(sym.HOUR); }
{number}            { return sym(sym.NUMBER); }
{state_name}        { return sym(sym.STATE_NAME, yytext()); }
{attribute_name}    { return sym(sym.ATTRIBUTE_NAME, yytext()); }
{signed_integer}    { return sym(sym.SIGNED_INTEGER, Integer.parseInt(yytext()));}

{quoted_string}     { return sym(sym.QUOTED_STRING, yytext()); }
{comment}           {;}
\r | \n | \r\n | " " | \t    {;}

// effects of this line (to be left as last rule):
// - commented: exception if input does not match
// - uncommented: prints on screen non-matching chars, continue scanning input
//.                { System.out.println("Scanner Error: " + yytext()); }
