%{
	#include<stdio.h>

	FILE *yyin,*fp;
	#include "decl.h"
	#include<stdlib.h>
	struct Tnode* allocateNode(int,int,char,int);
	int reg_count=0;
%}

%union {	struct Tnode *T;
			}

%start prog
%token DO ENDWHILE 
%token <T> DIGIT VAR READ WRITE BEGN ED IF THEN ELSE ENDIF GE LE EQ NE GT WHILE
%type <T> expr st stlist
%right <T> '='
%left <T> '>'
%left <T> '+' '-'
%left <T> '*' '/'
%%
prog	:	BEGN  stlist ED
			{
				ex($2);
				fp=fopen("code","w");
				evaluate($2);
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
		
st		:IF '(' expr ')' THEN stlist ELSE stlist ENDIF 
		{ 
			$$= allocateNode(0,DECISION,'\0',-1);
			$$->l = $3;
			$$->m = $6;
			$$->r = $8;
		}
		
		|WHILE '('expr ')' DO stlist ENDWHILE ';'
		{
			$$=allocateNode(0,LOOP,'\0',-1);
			$$->l = $3;
			$$->r = $6;
			$$->m = NULL;
		}
		|VAR '=' expr ';' 
			{	
				$$ = $2;
				$$->l = $1;
				$$->r = $3;
				insertSymTable($1->binding,$3->val);
				}
		
		|	READ '(' VAR ')' ';' 
			{ 
				$$ = $1;
				$$->l = $$->r = $3;
				}
		
		|	WRITE '(' expr ')' ';' 
			{
				$$ = $1;
				$$->l = $3;
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
		
		|	expr GT expr
			{
				$$ = $2;
				$$->l=$1;
				$$->r=$3;
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
	int b;
	switch(root->flag)
	{
		case STLIST:	ex(root->l);
						ex(root->r);
						break;
		
		case RD:		
						
						scanf("%d",&b);
						insertSymTable((root->l)->binding,b);
						return 0;
		
		case WRT:		printf("%d\n",ex(root->l));
						return 0;

		case greaterthen:
						if ( ex(root->l) > ex(root->r))
							{return 1;}
						else
							{return 0;}
		
		case ASSGN:		return sym[(root->l)->binding] = ex(root->r);
		
		case ADD:		return ex(root->l) + ex (root->r);
		
		case SUB:		return ex(root->l) - ex (root->r);
		
		case MUL:		return ex(root->l) * ex (root->r);
		
		case DIV:		return ex(root->l) / ex (root->r);
		
		case VRBL:		return sym[root->binding];
		
		case NUM:		return root->val;
		case DECISION:	if(ex(root->l))
								{ex(root->m);}
							else
								{ex(root->r);}
								break;
		case LOOP:		while(ex(root->l))
									ex(root->r);
							break;
		
		default:		printf("How did flag get this value!");
	}
}
int evaluate(struct Tnode *Root)
{
	int loc,r;
	switch(Root->flag)
	{
		case STLIST:
			evaluate(Root->l);
			evaluate(Root->r);
			break;
		case RD:
			loc = (Root->l)->binding;
			r = getreg();
			fprintf(fp,"IN R%d\n",r);
			fprintf(fp,"MOV [%d] R%d\n",loc,r);
			freereg();
			return -1;
		case WRT:
			r = evaluate(Root->l);
			fprintf(fp,"\nOUT R%d\n",r);
			freereg();
			return -1;
		case ADD:
			r=evaluate(Root->l);
			evaluate(Root->r);
			fprintf(fp,"\nADD R%d R%d",r,r+1);
			freereg();
			return r;
		case SUB:
			r=evaluate(Root->l);
			evaluate(Root->r);
			fprintf(fp,"\nSUB R%d R%d",r,r+1);
			freereg();
			return r;
		case MUL:
			r=evaluate(Root->l);
			evaluate(Root->r);
			fprintf(fp,"\nMUL R%d R%d",r,r+1);
			freereg();
			return r;
		case DIV:
			r=evaluate(Root->l);
			evaluate(Root->r);
			fprintf(fp,"\nDIV R%d R%d",r,r+1);
			freereg();
			return r;
		case VRBL:
			r=getreg();
			loc=Root->binding;
			fprintf(fp,"MOV R%d [%d]",r,loc);
			return r;
	}
}
int getreg()
{
	return reg_count++;
}
freereg()
{
	reg_count--;
}

