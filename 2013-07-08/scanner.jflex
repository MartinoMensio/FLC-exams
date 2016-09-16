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

sep = "%%"

hour = 0(8:(3[5-9]|[45][0-9])|9:[0-5][0-9])(am)?|1([0-6]:[0-5][0-9]|7:[0-4][0-9])|(1[0-1]:[0-5][0-9]|0([1-6]:[0-5][0-9]|5:[0-4][0-9]))am

code = "?"([a-z]{4}([a-z]{2})*|[A-Z]{3}([A-Z]{2})*)"?"(([xy]{2}){3}([xy]{2})*)

ip = {byte_}("."{byte_}){3}:(-[246]|[0-9]?[02468]|1[0-2][02468])

byte_ = [1-9]?[0-9]|1[0-9]{2}|2([0-4][0-9]|5[0-5])

identifier = [a-zA-Z_][a-zA-Z0-9_]*

comment = "/*" ~ "*/"
int_ = [+-]?[0-9]|[1-9][0-9]*

%%

{sep}               { return sym(sym.SEP);}
"."                 { return sym(sym.DOT); }
";"                 { return sym(sym.S); }
"="                 { return sym(sym.EQ); }
"{"                 { return sym(sym.BO); }
"}"                 { return sym(sym.BC); }
"#"                 { return sym(sym.HASH); }
"&&"                { return sym(sym.AND); }
"||"                { return sym(sym.OR); }
"=="                { return sym(sym.EQEQ); }
"STATE"             { return sym(sym.STATE); }
"START"             { return sym(sym.START); }
"PRINT"             { return sym(sym.PRINT); }
"IF"                { return sym(sym.IF); }
"THEN"              { return sym(sym.THEN); }
"ELSE"              { return sym(sym.ELSE); }


{hour}              { return sym(sym.HOUR); }
{code}              { return sym(sym.CODE); }
{ip}                { return sym(sym.IP); }

{identifier}        { return sym(sym.ID, yytext()); }
 
{int_}              { return sym(sym.INT, Integer.parseInt(yytext()));}

{comment}           {;}
\r | \n | \r\n | " " | \t    {;}

// effects of this line (to be left as last rule):
// - commented: exception if input does not match
// - uncommented: prints on screen non-matching chars, continue scanning input
//.                  { System.out.println("Scanner Error: " + yytext()); }
