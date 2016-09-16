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

code1 = "#"[a-zA-Z]{4}[a-zA-Z]{2}*(-[1-3]|[1-9]?[0-9]|1([01][0-9]|2[0-3]))(IJK|XY(Z(ZZ)*)?)?

code2 = {hex}[:-]{hex}([:-]{hex}[:-]{hex})*

hex = [a-fA-F0-9]{2}?[a-fA-F0-9]{2}

sep = "$$$"("$$")*
comment = "//".*
uint = [0-9]|[1-9][0-9]*
float_ = {uint}?"."{uint}|{uint}"."{uint}?

%%

";"                 { return sym(sym.S); }
"("                 { return sym(sym.RO); }
")"                 { return sym(sym.RC); }
","                 { return sym(sym.CM); }
":"                 { return sym(sym.C); }

"MAX"               { return sym(sym.MAX); }
"TEMP"              { return sym(sym.TEMP); }
"FOOD"              { return sym(sym.FOOD); }
OX[YI]GEN           { return sym(sym.OXYGEN); }
"CELLS"             { return sym(sym.CELLS); }
"MOD_STATE1"        { return sym(sym.MOD_STATE1); }
"MOD_STATE2"        { return sym(sym.MOD_STATE2); }

{sep}               { return sym(sym.SEP); }
{code1}             { return sym(sym.CODE1); }
{code2}             { return sym(sym.CODE2); }

"+"                 { return sym(sym.SIGN, true); }
"-"                 { return sym(sym.SIGN, false); }
{uint}              { return sym(sym.UINT, Integer.parseInt(yytext()));}
{float_}            { return sym(sym.FLOAT, Double.parseDouble(yytext()));}

{comment}               {;}
\r | \n | \r\n | " " | \t    {;}

// effects of this line (to be left as last rule):
// - commented: exception if input does not match
// - uncommented: prints on screen non-matching chars, continue scanning input
//.                { System.out.println("Scanner Error: " + yytext()); }
