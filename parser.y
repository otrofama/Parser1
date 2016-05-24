%{

/*
*
*	Compiladores
*	23-mayo-2016
*
*	parser.y
*	Olivares Castillo José Luis
*	Pérez Escorza Iván
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int dir;
void newDir();

void yyerror();
extern FILE* yyout;
extern FILE* yyin;
%}

%union
{
	char* sval;
	struct
	{
		char* code;
		int type;
		int val;
	}num;
	struct
	{
		char* code;
	}type;
}

%token<sval> ID
%token LPAR RPAR NL ASIG CA CD PC
%token<num> NUM

%left MAS
%left MUL

%type<type> exp term fac sent

%start program

%%

program: program list {
		printf("P->PL\n");
		fprintf(yyout,"P->PL\n");
		} | list {
			printf("P->L\n");
			fprintf(yyout,"P->L\n");
		};

list: exp NL{
		printf("L->E NL\n");
		fprintf(yyout,"L->E NL\n");
		};	

sent: ID ASIG exp PC{
		printf("S->id=E;\n");
//		$1=(char*)malloc(2*sizeof(char));
//		strcpy($$.code,$1);
//		printf("%s=%s;\n",$$.code,$3.code);
		fprintf(yyout,"S->id=E;\n");
		};

line: ID CA exp CD{
		printf("L->id[E]\n");
		fprintf(yyout,"L->id[E]\n");
		}|	line CA exp CD{
			printf("L->L[E]");
			fprintf(yyout,"L->L[E]");
		};

exp:	exp MAS term {
		newDir();
		$$.code=(char*)malloc(2*sizeof(char));
		strcpy($$.code,"t");
		char dr[100];
		sprintf(dr,"%d",dir);
		strcat($$.code,dr);
		printf("%s = %s + %s\n", $$.code,$1.code,$3.code);
		fprintf(yyout,"%s = %s + %s\n", $$.code,$1.code,$3.code);
		printf("E->E+T\n");
		fprintf(yyout,"E->E+T\n");
		}
		| term {
			$$ = $1;
			printf("E->T\n");
			fprintf(yyout,"E->T\n");
		};

term:	term MUL fac{
		newDir();
		$$.code=(char*)malloc(2*sizeof(char));
		strcpy($$.code,"t");
		char dr[100];
		sprintf(dr,"%d",dir);
		strcat($$.code,dr);
		printf("%s = %s * %s\n", $$.code,$1.code,$3.code);
		fprintf(yyout,"%s = %s * %s\n", $$.code,$1.code,$3.code);
		printf("T->T*F\n");
		fprintf(yyout,"T->T*F\n");
		}
		| fac{
			$$=$1;
			printf("T->F\n");
			fprintf(yyout,"T->F\n");
		};

fac: LPAR exp RPAR{
		$$=$2;
		printf("F->(E)\n");
		}
		| ID{
			$$.code=(char*)malloc(2*sizeof(char));
			strcpy($$.code,$1);			
			printf("F->id\n");
			fprintf(yyout,"F->id\n");
		} |NUM {
			$$.code=(char*)malloc(2*sizeof(char));
			strcpy($$.code,$1.code);
			printf("F->num\n");
			fprintf(yyout,"F->num\n");
		}|	sent {
			printf("F->S\n");
			fprintf(yyout,"F->S\n");
		}| line{
			printf("F->L\n");
			fprintf(yyout,"F->L\n");
		};
%%

void yyerror()
{
	printf("Error sintáctico.\n");
	fprintf(yyout,"Error sintáctico.\n");
}
void newDir()
{
	dir++;
}
		

int main(int argc, char** argv)
{	
	FILE* file;
	if(argc>1)
	{
		file = fopen(argv[1],"r");
		if(!file)
		{
			perror("No se pudo abrir el archivo");
			exit(0);
		}
		else
		{
			yyin = file;
			yyout = fopen("resultado.txt","w");
			yyparse();			
		}
		fclose(yyin);
		fclose(yyout);
	}
	else
		printf("No se ingresó archivo.\n");
	return 0;
}





























