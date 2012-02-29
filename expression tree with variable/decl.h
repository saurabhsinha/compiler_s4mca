#define ADD 1
#define SUB 2
#define MUL 3
#define DIV 4
#define ASSGN 5
#define NUM 6
#define VRBL 7
#define RD 8
#define WRT 9
#define STLIST 10

struct Tnode
{
	int val;
	char op;
	int flag;
	int binding;
	struct Tnode *l,*r;
};


int ex(struct Tnode *);
void insertSymTable(int,int);
int sym[26];

