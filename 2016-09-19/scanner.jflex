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

sep = "%%%%"("%%")*


token = (-(1(8[13]|[0-7][13579])|[1-9]?[13579])|[13579]|[1-5][13579]|6[1357])([A-Z]{4}([A-Z]{2})*)?("***"|([xy]{2}){4}([xy]{2})*)

date = 2015"/"(09"/"(19|2[0-9]|30)|1[0-2]"/"(0[1-9]|[12][0-9]|30)|1[02]"/"31)|2016"/"0(1"/"(0[1-9]|[12][0-9]|3[01])|2"/"(0[1-9]|1[0-5]))

time = ":"(0(6":"(1[3-9]|[2-5][0-9])|[7-9]":"[0-5][0-9])|1([0-4]":"[0-5][0-9]|5":"([0-3][0-9]|4[0-3])))


comment = "/*" ~ "*/"
uint = [0-9]|[1-9][0-9]*
ureal = {uint}?"."[0-9]+|{uint}"."[0-9]*

%%

{token}             { return sym(sym.TOKEN); }
{date}{time}?       { return sym(sym.DATE); }

{sep}               { return sym(sym.SEP);}
"-"                 { return sym(sym.MINUS); }
"?"                 { return sym(sym.QUESTION_MARK); }
","                 { return sym(sym.CM); }
";"                 { return sym(sym.S); }
":"                 { return sym(sym.C); }
"SET"               { return sym(sym.SET); }
"POWER"             { return sym(sym.POWER); }
"WATER"             { return sym(sym.WATER); }
"STATE_CHANGE1"     { return sym(sym.STATE_CHANGE1); }
"INCREASE"          { return sym(sym.INCREASE, true); }
"DECREASE"          { return sym(sym.INCREASE, false); }
"STATE_CHANGE2"     { return sym(sym.STATE_CHANGE2); }
"AND"               { return sym(sym.AND); }
"OR"                { return sym(sym.OR); }
"NOT"               { return sym(sym.NOT); }
"("                 { return sym(sym.RO); }
")"                 { return sym(sym.RC); }
"->"                { return sym(sym.ARROW); }
"AVG"               { return sym(sym.AVG); }
"PRESSURE"          { return sym(sym.PRESSURE); }
"TEMP"              { return sym(sym.TEMP); }
"#"                 { return sym(sym.HASH); }

"ADD"               { return sym(sym.ADD, true); }
"SUB"               { return sym(sym.ADD, false); }

"TRUE"              { return sym(sym.BOOL, true); }
"FALSE"             { return sym(sym.BOOL, false); }

{ureal}             { return sym(sym.FLOAT, Double.parseDouble(yytext())); }

{comment}           {;}
\r|\n|\r\n|\ |\t    {;}

// effects of this line (to be left as last rule):
// - commented: exception if input does not match
// - uncommented: prints on screen non-matching chars, continue scanning input
//.                  { System.out.println("Scanner Error: " + yytext()); }
