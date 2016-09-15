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

token1 = ("%%%%%"("%%")*|("**"|"???"){2,3})("-"(3[135]|[12][13579])|"-"?[0-9]?[13579]|[12][13579]|3[0-2][13579]|33[13])?

token2 = {date}[+-]{date}

date = 2015"/"12"/"(1[2-9]|2[0-9]|3[01])|2016"/"0(1"/"(0[12346789]|[12][0-9]|3[01])|2"/"(0[1-9]|[12][0-9])|3"/"(0[1-9]|1[0-3]))

token3 = "$"(101|11[01]|1[01]{3,4}|100[01]{3}|101000) 

separator = "####"(##)*
comment = "//".*
quoted_string = "\"" ~ "\""
uint = [0-9]|[1-9][0-9]*

%%

"("                 { return sym(sym.RO); }
")"                 { return sym(sym.RC); }
"{"                 { return sym(sym.BO); }
"}"                 { return sym(sym.BC); }
","                 { return sym(sym.CM); }
";"                 { return sym(sym.S); }
":"                 { return sym(sym.C); }
"="                 { return sym(sym.EQ); }
"->"                { return sym(sym.ARROW);}
"|"                 { return sym(sym.PIPE); }
"m"                 { return sym(sym.M); }
"m/s"               { return sym(sym.MPS); }
"PRINT_MIN_MAX"     { return sym(sym.PRINT_MIN_MAX); }
"PART"              { return sym(sym.PART); }

{separator}         { return sym(sym.SEP); }
{token1}            { return sym(sym.TOKEN1);}
{token2}            { return sym(sym.TOKEN2);}
{token3}            { return sym(sym.TOKEN3);}

{uint}                { return sym(sym.UINT, Integer.parseInt(yytext()));}
{quoted_string}     { return sym(sym.QUOTED_STR, yytext());}
{comment}             {;}
\r | \n | \r\n | " " | \t    {;}

// effects of this line (to be left as last rule):
// - commented: exception if input does not match
// - uncommented: prints on screen non-matching chars, continue scanning input
//.                { System.out.println("Scanner Error: " + yytext()); }
