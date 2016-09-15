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

token1 = 11":"(3[5-9]|[45][0-9])(am)?|12":"[0-5][0-9](pm)?|13":"{min_13}|01":"{min_13}pm

min_13 = [0-4][0-9]|5[01]

token2 = {quoted_string}":"{ip}

ip = {byte_}("."{byte_}){3}

byte_ = 0|[1-9][0-9]|1[0-9]{2}|2([0-4][0-9]|5[0-5])

token3 = "%"[a-zA-Z]{4}[a-zA-Z]{2}*(-3[135]|-[12][13579]|-?[13579]|[1-9][13579]|1[0-9][13579]|2[0-4][13579]|25[13])(("****""*"*)|YX(XX)*Y)?

variable = [a-z_][a-zA-Z0-9_]*

comment = "/*" ~ "*/"
quoted_string = "\"" ~ "\""
uint = [0-9]|[1-9][0-9]*

%%

"##"                { return sym(sym.SEP); }
"=="                { return sym(sym.EQEQ); }
"="                 { return sym(sym.EQ); }
"&&"                { return sym(sym.AND); }
"||"                { return sym(sym.OR); }
"!"                 { return sym(sym.NOT); }
"+"                 { return sym(sym.PLUS); }
"-"                 { return sym(sym.MINUS); }
"*"                 { return sym(sym.STAR); }
"("                 { return sym(sym.RO); }
")"                 { return sym(sym.RC); }
";"                 { return sym(sym.S); }
","                 { return sym(sym.CM); }
"o["                { return sym(sym.OFFSET_START); }
"]"                 { return sym(sym.SC); }

{token1}            { return sym(sym.TOKEN1);}
{token2}            { return sym(sym.TOKEN2);}
{token3}            { return sym(sym.TOKEN3);}

"EVALUATE"          { return sym(sym.EVALUATE); }
"CASE_TRUE"         { return sym(sym.CASE_TRUE); }
"CASE_FALSE"        { return sym(sym.CASE_FALSE); }
"SAVE"              { return sym(sym.SAVE); }

"TRUE"              { return sym(sym.BOOL, true); }
"FALSE"             { return sym(sym.BOOL, false); }

{uint}           { return sym(sym.UINT, Integer.parseInt(yytext())); }
{variable}          { return sym(sym.VARIABLE, yytext()); }

{comment}           {;}
\r | \n | \r\n | " " | \t    {;}

// effects of this line (to be left as last rule):
// - commented: exception if input does not match
// - uncommented: prints on screen non-matching chars, continue scanning input
//.                { System.out.println("Scanner Error: " + yytext()); }
