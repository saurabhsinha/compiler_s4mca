%{
#include<stdio.h>
#include<stdlib.h>
#define add 1
#define sub 2
#define mul 3
#define div 4
struct Tnode
{
	int NODETYPE;
	int VALUE;
	struct Tnode *left,*right;
};
void prefix(struct Tnode*);
void postfix(struct Tnode*);
%}

%union
{
	struct Tnode *n;
}

%token NUM '+' '-' '*' '/'
%type<n> start expr '+' '-' '*' '/' NUM
%left '+' '-'//'+' '-'
%left '*' '/' //'*' '/'
%left '('

%%

start: expr'\n'		{
					printf("\nPrefix expression\t:\t");prefix($1);
					printf("\nPostfix expression\t:\t");postfix($1);
					printf("\nEval expression\t\t:\t%d\n\n",eval($1));
					return(0);
				};

expr	:	expr '+' expr	{
				
					$$=$2;
					$$->left=$1;
					$$->right=$3;
				}
	|	expr '-' expr	{
					$$=$2;
					$$->left=$1;
					$$->right=$3;
				}
	|	expr '*' expr	{
					$$=$2;
					$$->left=$1;
					$$->right=$3;
				}
	|	expr '/' expr	{
					$$=$2;
					$$->left=$1;
					$$->right=$3;
				}
	|	'('expr')'	{	$$=$2; }
	|	NUM		{	$$=$1; }
	;
%%

int main (void)
{
	printf("Enter the Calculation :");
	return yyparse();
}

void prefix(struct Tnode* root)
{
	if(root==NULL) {
		return;
	} else {
		switch(root->NODETYPE ) {
			case 0 :
				printf("%d",root->VALUE);
				break;
			case add :
				printf("%c",'+');
				break;
			case sub :
				printf("%c",'-');
				break;
			case mul :
				printf("%c",'*');
				break;
			case div :
				printf("%c",'/');
				break;
		}
		prefix(root->left);
		prefix(root->right);
	}
}


void postfix(struct Tnode* root)
{
	if(root==NULL) {
		return;
	} else {
		postfix(root->left);
		postfix(root->right);
		switch(root->NODETYPE ) {
			case 0 :
				printf("%d",root->VALUE);
				break;
			case add :
				printf("%c",'+');
				break;
			case sub :
				printf("%c",'-');
				break;
			case mul :
				printf("%c",'*');
				break;
			case div :
				printf("%c",'/');
				break;
		}
	}
}

int eval(struct Tnode* root)
{
	if(root==NULL) {
		return;
	} else {
		switch(root->NODETYPE ) {
			case 0 :
				return(root->VALUE);
				break;
			case 1 :
				return (eval(root->left) + eval(root->right));
				break;
			case 2 :
				return (eval(root->left) - eval(root->right));
				break;
			case 3 :
				return (eval(root->left) * eval(root->right));
				break;
			case 4 :
				return (eval(root->left) / eval(root->right));
				break;
		}


	}
}

int yyerror (char *msg)
{
	return fprintf (stderr, "YACC: %s\n", msg);
}

