%{

/*
*
*	Compiladores
*	19-mayo-2016
*
*	parser.y
*	Olivares Castillo José Luis
*	Pérez Escorza Iván
*
*/


#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}

%option yylineno

digito [0-9]
letra [a-zA-Z]
%%

"+" {return MAS;}
"*" {return MUL;}
"(" {return LPAR;}
")" {return RPAR;}
"="	{return ASIG;}
"["	{return CA;}
"]"	{return CD;}
";"	{return PC;}
{digito}+ {yylval.num.val=atoi(yytext);
		  yylval.num.type = 0;
		  yylval.num.code = (char*)realloc(yylval.num.code,yyleng*sizeof(char));
		  strcpy(yylval.num.code,yytext);
		  return NUM;		  
		  }
		  
[a-zA-Z_][a-zA-Z0-9_]* {
		  yylval.sval =(char*)realloc(yylval.sval,yyleng*sizeof(char));
		  strcpy(yylval.sval,yytext);
		  return ID;		
		  }
		  

"\n"	{return NL;}

[ \t\r] {}

. {printf("Error léxico: %s en línea %d\n",yytext,yylineno);}
%%

int yywrap()
{
	return 1;
}

