import java_cup.runtime.*;

%%

%class scanner
/*%standalone*/
%unicode
%cup
%line
%column

%{
	private Symbol symbol(int type) {
		return new Symbol(type, yyline, yycolumn);
	}
	private Symbol symbol(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}
%}

comment	= "%".* 

nl = (\r|\n|\r\n)
ws = [ \t]

separator = "$$"

even_num = ("-"12[024])|("-"1[01][02468])|("-"9[02468])|("-"88)|(("-")?8[0246])|(("-")?[1-7][02468])|(("-")?[02468])

word = (1[01])|(1([01]){2})|(1([01]){3})|(1([01]){4})      

token1 = {even_num}(([a-z][a-z][a-z][a-z][a-z])([a-z][a-z]*))?((ABC)|(([XY][XY][XY][XY][XY][XY])([XY][XY])*))

token2 = {word}("*"|"-"){word}("*"|"-"){word}("*"|"-"){word}("*"|"-"){word}(("*"|"-"){word}("*"|"-"){word})*

token3 = (08":"12":"((3[4-9])|([4-5][0-9])))|(08":"1([3-9])":"([0-5][0-9]))|(((09)|(1[0-6]))":"([0-5][0-9])":"([0-5][0-9]))|(17":"(([0-1][0-9])|(20))":"([0-5][0-9]))|(17":"21":"(([0-2][0-9])|(3[0-7])))

integer = ("+"|"-")?[0-9]+

var = [a-zA-Z][a-zA-Z0-9]*


%%

"set" {return symbol(sym.SET);}
"position" {return symbol(sym.POSITION);}
"fuel" {return symbol(sym.FUEL);}
"declare" {return symbol(sym.DECLARE);}
"increases" {return symbol(sym.INCREASES);}
"decreases" {return symbol(sym.DECREASES);}
"max" {return symbol(sym.MAX);}
"min" {return symbol(sym.MIN);}
"mv" {return symbol(sym.MV);}
"and" {return symbol(sym.AND);}
"or" {return symbol(sym.OR);}
"not" {return symbol(sym.NOT);}
"else" {return symbol(sym.ELSE);}

{separator} {return symbol(sym.SEPARATOR);}
{integer} {return symbol(sym.INT, new Integer(yytext()));}
{token1} {return symbol(sym.TOKEN1);}
{token2} {return symbol(sym.TOKEN2);}
{token3} {return symbol(sym.TOKEN3);}
{comment} {}

";" {return symbol(sym.CS);}
"," {return symbol(sym.C);}
"." {return symbol(sym.DOT);}
":" {return symbol(sym.CL);}
"(" {return symbol(sym.RO);}
")" {return symbol(sym.RC);}
"{" {return symbol(sym.CO);}
"}" {return symbol(sym.CC);}
"-" {return symbol(sym.MINUS);}
"=" {return symbol(sym.EQ);}
"==" {return symbol(sym.EQEQ);}
"?" {return symbol(sym.Q);}

{var} {return symbol(sym.VAR, new String(yytext()));}

{nl}|{ws} {}
. {}
