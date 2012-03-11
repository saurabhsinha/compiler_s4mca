%{

	#include<stdio.h>
	#include<stdlib.h>
	#include "y.tab.h"
	#include "decl.h"
	struct Tnode* allocateNode(int,int,char,int);
%}
%%
[\t\n ]+	


"while"			{yylval.T = allocateNode(0,LOOP,'\0',-1);
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
					yylval.T = allocateNode(0,RD,'\0',-1);
					return READ;
					}

"write"			{
					yylval.T = allocateNode(0,WRT,'\0',-1);
					return WRITE;
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
					yylval.T= allocateNode(0,greaterthen,'\0',-1);
					return GT;
					}


[a-z]			{
					yylval.T = allocateNode(0,VRBL,'\0',yytext[0]-'a');
					return VAR;
					}

[0-9]+			{
					yylval.T = allocateNode(atoi(yytext),NUM,'\0',-1);
					return DIGIT;
					}

[-+*=/();\n]	{
						switch(yytext[0])
						{
							case '+':	yylval.T = allocateNode(0,ADD,'+',-1);
										break;
							case '-':	yylval.T = allocateNode(0,SUB,'-',-1);
										break;
							case '*':	yylval.T = allocateNode(0,MUL,'*',-1);
										break;
							case '/':	yylval.T = allocateNode(0,DIV,'/',-1);
										break;
							case '=':	yylval.T = allocateNode(0,ASSGN,'=',-1);
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
struct Tnode* allocateNode(int value,int flg,char optr,int binding)
{
	struct Tnode *N;
	N = malloc(sizeof(struct Tnode));
	N->val = value;
	N->flag = flg;
	N->op = optr;
	N->binding = binding;
	N->l = N->r = NULL;
	N->m = NULL;
	return N;
}
