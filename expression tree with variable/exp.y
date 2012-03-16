%{
	#include<stdio.h>

	FILE *yyin,*fp;
	#include "decl.h"
	#include<stdlib.h>
	struct Tnode* allocateNode(int,int,char,char *,int);
	int reg_count=0;
	struct Gsymbol *ghead = NULL;
	void Ginstall(char *,int,int);
	struct Gsymbol *Glookup(char *);
%}

%union {	struct Tnode *T;
			}

%start prog
%token DO ENDWHILE 
%token <T> DIGIT VAR READ WRITE BEGN ED IF THEN ELSE ENDIF GE LE EQ NE GT WHILE DECL ENDDECL INTEGER BOOLEAN
%type <T> expr st stlist  GDefblock GDefList IntName BoolName
%right <T> '='
%left <T> '>'
%left <T> '+' '-'
%left <T> '*' '/'
%%


prog	:	GDefblock BEGN  stlist ED
			{
				ex($3);
				fp=fopen("code","w");
				evaluate($3);
				printf("\n");
				}
		;
		
		
GDefblock :		DECL GDefList ENDDECL
		;
GDefList	:		GDefList INTEGER IntName ';'
		|		GDefList BOOLEAN BoolName ';' 
		|   {$$=NULL;}
IntName	:	IntName ',' VAR
			{ 
				Ginstall($3->name,integer,1);
				 }
		|VAR    { 
				Ginstall($1->name,integer,1);
				 }
BoolName	:	BoolName ',' VAR
			{ 
				Ginstall($3->name,boolean,1);
				 }
		|VAR    { 
				Ginstall($1->name,boolean,1);
				 }

		
stlist	:	stlist st
			{
				$$ = allocateNode(0,STLIST,'\0',NULL,DUMMY_TYPE);
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
			$$= allocateNode(0,DECISION,'\0',NULL,VOID_TYPE);
			$$->l = $3;
			$$->m = $6;
			$$->r = $8;
		}
		
		|WHILE '('expr ')' DO stlist ENDWHILE ';'
		{
			$$=allocateNode(0,LOOP,'\0',NULL,VOID_TYPE);
			$$->l = $3;
			$$->r = $6;
			$$->m = NULL;
		}
		|VAR '=' expr ';' 
			{	
				$$ = $2;
				$$->l = $1;
				$$->r = $3;
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


int ex(struct Tnode *root)
{
	struct Gsymbol *temp;
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
						temp=Glookup(root->l->name);
						if(temp)
							temp->BINDING[0]=b;
						break;
		
		case WRT:		printf("%d\n",ex(root->l));
						return 0;

		case greaterthen:
						if ( ex(root->l) > ex(root->r))
							{return 1;}
						else
							{return 0;}
		
		case ASSGN:		 if(temp=Glookup(root->l->name))
					{
						temp->BINDING[0] = ex(root->r);
					}
		
		case ADD:		return ex(root->l) + ex (root->r);
		
		case SUB:		return ex(root->l) - ex (root->r);
		
		case MUL:		return ex(root->l) * ex (root->r);
		
		case DIV:		return ex(root->l) / ex (root->r);
		
		case VRBL:		temp=Glookup(root->name);
					if(temp)
						return temp->BINDING[0];
					break;
		
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
			loc = Root->name - 'a';
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
			loc = Root->name - 'a';
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
struct Gsymbol *Glookup(char *name)	{
	struct Gsymbol *temp = ghead;
	while(temp)	{
		if(strcmp(name,temp->NAME)==0) 
			return temp;
		temp = temp->NEXT;
	}
	return NULL;
}

void Ginstall(char *name,int type,int size)	{
	struct Gsymbol *temp;
	temp = Glookup(name);
	if(temp)	{
		printf("You have already declared %s ",name);
		yyerror("");
	}
	else	{
		temp =malloc(sizeof(struct Gsymbol));
		temp->NAME = name;
		temp->TYPE = type;
		temp->SIZE = size;
		temp->BINDING = (int *)malloc(sizeof(int)*size);
		temp->NEXT = NULL;
		if(ghead==NULL)
			ghead =temp;
		else	{
			temp->NEXT = ghead;
			ghead=temp;
		}
	}
}
