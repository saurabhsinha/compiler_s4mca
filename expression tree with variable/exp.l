%{

	#include<stdio.h>
	#include<stdlib.h>
	#include "y.tab.h"
	#include "decl.h"
	struct Tnode* allocateNode(int,int,char,char *,int);
%}
%%
[\t\n ]+	


"while"			{yylval.T = allocateNode(0,LOOP,'\0', NULL,VOID_TYPE);
					return WHILE;}
"do"				{
					return DO;
					}
"endwhile"		{return ENDWHILE;}

"begin"			{	return BEGN;
					}

"end"				{	return ED;
					}

"read"			{
					yylval.T = allocateNode(0,RD,'\0', NULL,VOID_TYPE);
					return READ;
					}

"write"			{
					yylval.T = allocateNode(0,WRT,'\0', NULL,VOID_TYPE);
					return WRITE;
					}
"decl"			{
					return DECL;
					}
"enddecl"		{
					return ENDDECL;
					}
"integer"		{
					return INTEGER;
					}
"boolean"		{
					return BOOLEAN;
					}
"if"				{
					
					return IF;
					}
"else"				{
					
					return ELSE;
					}
"then"				{
					return THEN;
					}
"endif"				{
					
					return ENDIF;
					}

">"				{
					yylval.T= allocateNode(0,greaterthen,'\0', NULL,BOOLEAN_TYPE);
					return GT;
					}


[a-zA-Z]+			{
					char *name =  (char *)malloc(sizeof(yytext));
					strcpy(name,yytext);
					yylval.T = allocateNode(0,VRBL,'\0', name,VOID_TYPE);
					return VAR;
					}

[0-9]+			{
					yylval.T = allocateNode(atoi(yytext),NUM,'\0', NULL,INT_TYPE);
					return DIGIT;
					}

[-+*=/();\n,]	{
						switch(yytext[0])
						{
							case '+':	yylval.T = allocateNode(0,ADD,'+', NULL,INT_TYPE);
										break;
							case '-':	yylval.T = allocateNode(0,SUB,'-', NULL,INT_TYPE);
										break;
							case '*':	yylval.T = allocateNode(0,MUL,'*', NULL,INT_TYPE);
										break;
							case '/':	yylval.T = allocateNode(0,DIV,'/', NULL,INT_TYPE);
										break;
							case '=':	yylval.T = allocateNode(0,ASSGN,'=', NULL,INT_TYPE);
										break;
							
							default :	;
						}
						
						return yytext[0];
						}
						. {yyerror("enter valid character");}

%%
int yyerror(char *s) 
{
	fprintf(stderr, "%s\n", s);
	return 1;
}

int yywrap(void)
{
  return 1;
}
struct Tnode* allocateNode(int value,int flg,char optr,char *name,int type)
{
	struct Tnode *N;
	N = malloc(sizeof(struct Tnode));
	N->val = value;
	N->flag = flg;
	N->op = optr;
	N->l = N->r = NULL;
	N->m = NULL;
	N->name=name;
	N->type=type;
	return N;
}
