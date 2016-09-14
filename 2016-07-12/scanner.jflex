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

token1 = "?"([a-z]{4}([a-z]{2})*|[A-Z]{5}([A-Z]{2})*)(11[01]|1[01]{3}|10(0[01]{2}|10[01]))?

token2 = {word}[-+]{word}([-+]{word}[-+]{word})*

word = ([ij]{2}){3}(([ij]{2}){3})?

date = 2016"/"0(5"/"(2[89]|3[01])|6"/"(0[1-9]|1[0-9]|2[012356789]|30)|7"/"(0[1-9]|[12][0-9]|3[01])|8"/"(0[1-9]|1[0-5]))

var = [a-zA-Z]([a-zA-Z0-9])*

comment = "/*" ~ "*/"
uint = [0-9]|[1-9][0-9]*

%%

"##"				{ return sym(sym.SEP); }
";" 				{ return sym(sym.S); }
"=" 				{ return sym(sym.EQ); }
"+"					{ return sym(sym.PLUS); }
"-"					{ return sym(sym.MINUS); }
"*"					{ return sym(sym.STAR); }
"/"					{ return sym(sym.DIV); }
"," 				{ return sym(sym.CM); }
"(" 				{ return sym(sym.RO); }
")" 				{ return sym(sym.RC); }
"{"					{ return sym(sym.BO); }
"}"					{ return sym(sym.BC); }
":" 				{ return sym(sym.C); }
"stat" 				{ return sym(sym.STAT); }
"case" 				{ return sym(sym.CASE); }
"switch" 			{ return sym(sym.SWITCH); }
"print" 			{ return sym(sym.PRINT); }
"MIN"				{ return sym(sym.MIN); }
"MAX"				{ return sym(sym.MAX); }

{token1}			{ return sym(sym.TOKEN1); }
{token2}			{ return sym(sym.TOKEN2); }
{date}				{ return sym(sym.DATE); }

{var}				{ return sym(sym.VAR, yytext()); }
{uint}				{ return sym(sym.UINT, Integer.parseInt(yytext()));}

{comment}	 		{;}
\r | \n | \r\n | " " | \t	{;}
