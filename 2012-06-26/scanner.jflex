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

%state not_header

sep = "*****"

hour = 0(8:(3(1(:(1[2-9]|[2-5][0-9]))?|[2-9](:[0-5][0-9])?)|[45][0-9](:[0-5][0-9])?)|9(:[0-5][0-9]){1,2})|1[0-9](:[0-5][0-9]){1,2}|2([0-2](:[0-5][0-9]){1,2}|3:([01][0-9](:[0-5][0-9])?|2(0(:[0-5][0-9]|1:(0[0-9]|10))?)))

code = ([XY]{3}([XY]{2})*)?(-(1(3[2468]|[0-2][02468])|[1-9][02468]|[2468])|[1-9]?[02468]|[1-7][0-9][02468]|8([01][02468]|2[024]))

alpha_str = [a-zA-Z]+

user_code = [a-zA-Z]{3}([a-zA-Z]{2})*"."{number}"."{number}("."{number}{2})*
number = 1[2-9]|[2-9][0-9]|1([0-2][0-9]|3[0-2])

quoted_string = "\"" ~ "\""
uint = [0-9]|[1-9][0-9]*
currency = {uint}?"."[0-9]{2}


%%

{sep}               { yybegin(not_header); return sym(sym.SEP); }
":"                 { return sym(sym.C); }
","                 { return sym(sym.CM); }
";"                 { return sym(sym.S); }
"Auction"           { return sym(sym.AUCTION); }
"min"               { return sym(sym.MIN); }
"euro"              { return sym(sym.EURO); }
"->"                { return sym(sym.ARROW); }

{hour}              { return sym(sym.HOUR); }
<YYINITIAL>{code}   { return sym(sym.CODE); }
 
{currency}          { return sym(sym.CURRENCY, Double.parseDouble(yytext())); }
{user_code}         { return sym(sym.USER_CODE, yytext()); }
{alpha_str}         { return sym(sym.ALPHA_STR, yytext()); }
{quoted_string}     { return sym(sym.QUOTED_STR, yytext()); }
{uint}              { return sym(sym.UINT, Integer.parseInt(yytext())); }

\r | \n | \r\n | " " | \t    {;}

// effects of this line (to be left as last rule):
// - commented: exception if input does not match
// - uncommented: prints on screen non-matching chars, continue scanning input
//.                  { System.out.println("Scanner Error: " + yytext()); }
