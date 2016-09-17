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

sep = ###

codice = [XY]{2}([XY]{2})*([0-9]{2}([0-9]{3})?|[a-z]{3}([a-z]{2})*)("++")*

data = ((0[5-9]|[12][0-9])"/"02|(0[1-9]|[12][0-9]|3[01])"/"03|(0[1-9]|1[0-2])"/"04)"/"2012


nome = [a-zA-Z][a-zA-Z0-9_]*

id_oggetto = "%"(-(3[01]|[12][0-9])|-?[1-9]|0|[1-9][0-9]|1([0-3][0-9]|14[0-5]))


uint = [0-9]|[1-9][0-9]*

%%

{sep}               { return sym(sym.SEP);}
":"                 { return sym(sym.C); }
","                 { return sym(sym.CM); }
";"                 { return sym(sym.S); }
"+"                 { return sym(sym.PLUS); }
"-"                 { return sym(sym.MINUS); }
"*"                 { return sym(sym.STAR); }
"/"                 { return sym(sym.DIV); }
"("                 { return sym(sym.RO); }
")"                 { return sym(sym.RC); }
"[["                { return sym(sym.SOSO); }
"]]"                { return sym(sym.SCSC); }
"->"                { return sym(sym.ARROW); }

{codice}            { return sym(sym.CODICE); }
{data}              { return sym(sym.DATA); }

{nome}              { return sym(sym.NOME, yytext()); }
{id_oggetto}        { return sym(sym.ID_OGG, yytext()); }

 
{uint}              { return sym(sym.UINT, Integer.parseInt(yytext()));}

\r | \n | \r\n | " " | \t    {;}

// effects of this line (to be left as last rule):
// - commented: exception if input does not match
// - uncommented: prints on screen non-matching chars, continue scanning input
//.                  { System.out.println("Scanner Error: " + yytext()); }
