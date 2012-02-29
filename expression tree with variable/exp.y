%{
	#include<stdio.h>
	#include<stdlib.h>
	#include "decl.h"
	FILE *yyin,*fp;
	struct Tnode* allocateNode(int,int,char,int);
%}

%union {	struct Tnode *T;
			}

%start prog
%token <T> DIGIT VAR READ WRITE BEGN ED
%type <T> expr st stlist
%right <T> '='
%left <T> '+' '-'
%left <T> '*' '/'
%%
prog	:	BEGN '\n' stlist ED
			{
				ex($3);
				printf("\n");
				}
		;
		
stlist	:	stlist st
			{
				$$ = allocateNode(0,STLIST,'\0',-1);
				$$->l = $1;
				$$->r = $2;
				}
		
		|	st
			{
				$$ = $1;
				}
		
		;
		
st		:	VAR '=' expr ';' '\n'
			{	
				$$ = $2;
				$$->l = $1;
				$$->r = $3;
				insertSymTable($1->binding,$3->val);
				}
		
		|	READ '(' VAR ')' ';' '\n'
			{
				$$ = $1;
				$$->l = $$->r = $3;
				}
		
		|	WRITE '(' expr ')' ';' '\n'
			{
				$$ = $1;
				$$->l = $$->r = $3;
				}
		;
		
expr	:	expr '+' expr
			{	$$ = $2;
				$$->l = $1;
				$$->r = $3;
				}
		
		|	expr '-' expr
			{	$$ = $2;
				$$->l = $1;
				$$->r = $3;
				}
		
		|	expr '*' expr
			{	$$ = $2;
				$$->l = $1;
				$$->r = $3;
				}
		
		|	expr '/' expr
			{	$$ = $2;
				$$->l = $1;
				$$->r = $3;
				}
		
		|	'(' expr ')'
			{	$$ = $2;
				}
		
		|	DIGIT
			{
				$$ = $1;
				}
		
		|	VAR
			{	
				$$ = $1;
				}
		
		;

%%
int main(int argc,char *argv[])
{
	yyin = fopen(argv[1],"r");
	yyparse();
	fclose(yyin);
	return 0;
}
void insertSymTable(int x,int val)
{
	sym[x] = val;
}
int ex(struct Tnode *root)
{
	if(!root)
		return 0;
	
	switch(root->flag)
	{
		case STLIST:	ex(root->l);
						ex(root->r);
						break;
		
		case RD:		;
						int b;
						scanf("%d",&b);
						insertSymTable((root->l)->binding,b);
						return 0;
		
		case WRT:		printf("%d\n",ex(root->l));
						return 0;
		
		case ASSGN:		return sym[(root->l)->binding] = ex(root->r);
		
		case ADD:		return ex(root->l) + ex (root->r);
		
		case SUB:		return ex(root->l) - ex (root->r);
		
		case MUL:		return ex(root->l) * ex (root->r);
		
		case DIV:		return ex(root->l) / ex (root->r);
		
		case VRBL:		return sym[root->binding];
		
		case NUM:		return root->val;
		
		default:		printf("How did flag get this value!");
	}
}
