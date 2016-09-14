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

// TODO: declare here regexp
//token = [0-9]
//comment = "/*" ~ "*/"
//comment = "//".*|"/*" ~ "*/"
//quoted_string = \" ~ \"
//uint = [0-9]|[1-9][0-9]*

%%

// TODO: declare actions
//{token}			{ return sym(sym.TOKEN);}


//{uint}				{ return sym(sym.UINT, Integer.parseInt(yytext()));}

//{comment}	 		{;}
\r | \n | \r\n | " " | \t	{;}

// effects of this line (to be left as last rule):
// - commented: exception if input does not match
// - uncommented: prints on screen non-matching chars, continue scanning input
//.				{ System.out.println("Scanner Error: " + yytext()); }
