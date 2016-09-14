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

separator = "%"{4}("%%")*|"#"("##")*
comment = "//".*

code = ("-"2[024]|"-"1[02468]|"-"[2468]|0|"+"?([2468]|[1-9][0-9]{0,1}[02468]|1[0-9]{2}[02468]|2([0-3][0-9][02468]|4([0-6][02468]|7[02]))))(["$""?"]{5}["$""?"]{2}*|[a-zA-Z]{4}([a-zA-Z]{2}[a-zA-Z]{3}?)?)

date = 2015"/"12"/"(0[6-9]|[12][0-9]|3[01])|2016"/"0(1"/"(0[1-9]|[12][0-9]|3[01])|2"/"(0[1-9]|[12][0-9])|3"/"(0[1-9]|[1-2][0-9]|3[01])){hour}?

hour = ":"(0(4":"(3[2-9]|[45][0-9])|[5-9]":"[0-5][0-9])|1([0-4]":"[0-5][0-9]|5":"([0-3][0-9]|4[0-7])))

integer = [+-]?(0|[1-9][0-9]*)

name = [a-zA-Z]+[0-9]*

%%

"."                 { return sym(sym.DOT); }
","                 { return sym(sym.CM); }
":"                 { return sym(sym.C); }
";"                 { return sym(sym.S); }
"{"                 { return sym(sym.BO); }
"}"                 { return sym(sym.BC); }

"START"             { return sym(sym.START); }
"VAR"               { return sym(sym.VAR); }
"MOVE"              { return sym(sym.MOVE); }
"WHEN"              { return sym(sym.WHEN); }
"THEN"              { return sym(sym.THEN); }
"DONE"              { return sym(sym.DONE); }
"AND"               { return sym(sym.AND); }
"OR"                { return sym(sym.OR); }
"NOT"               { return sym(sym.NOT); }
"MOVE"               { return sym(sym.MOVE); }
"!="                { return sym(sym.NOTEQ); }
"=="                { return sym(sym.EQEQ); }
{separator}         { return sym(sym.SEP); }
{code}              { return sym(sym.CODE); }
{date}              { return sym(sym.DATE); }

{integer}           { return sym(sym.INTEGER, Integer.parseInt(yytext())); }
{name}              { return sym(sym.NAME, yytext()); }

{comment}             {;}
\r | \n | \r\n | " " | \t    {;}

// effects of this line (to be left as last rule):
// - commented: exception if input does not match
// - uncommented: prints on screen non-matching chars, continue scanning input
//.                { System.out.println("Scanner Error: " + yytext()); }
