%{
#include "y.tab.h"
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
	struct node *left,*right;
};

struct Tnode* buildtree(int nodetype1,int value1)
{
	struct Tnode* temp=malloc(sizeof(struct Tnode));
	if(nodetype1==0)
	{

		temp->NODETYPE=nodetype1;
		temp->VALUE=value1;
		temp->left=NULL;
		temp->right=NULL;

	}
	else if(nodetype1==1||nodetype1==2||nodetype1==3||nodetype1==4)
	{
		
		temp->NODETYPE=nodetype1;
		temp->left=NULL;
		temp->right=NULL;
	}
	return temp;
}


int yywrap(void) {
	return 1;
}


%}



%%
[0-9]+	{	yylval.n=buildtree(0,atoi(yytext));
			return NUM;
		}

[+]		{	yylval.n=buildtree(add,0);
			return '+';}

[-]		{	yylval.n=buildtree(sub,0);
			return '-';}

[*]		{	yylval.n=buildtree(mul,0);
			return '*';}

[/]		{	yylval.n=buildtree(div,0);
			return '/';}

[\n]		{	return *yytext;}

%%

