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
#define DECISION 11
#define equalto 12
#define notequalto 13
#define greaterthenequalto 14
#define lessthenequalto 15
#define onlyif 16
#define greaterthen 17
#define LOOP 18
#define INT_TYPE 19
#define BOOLEAN_TYPE 20
#define VOID_TYPE 21
#define DUMMY_TYPE 22
#define integer 23
#define boolean 24





struct Tnode
{
	int val;
	char op;
	char *name;
	int type;
	int flag;
	struct Tnode *l,*r,*m;
};

struct Gsymbol {

	char *NAME;
	int TYPE;
	int SIZE;
	int *BINDING; 
	int location;
	struct Gsymbol *NEXT;
};

int ex(struct Tnode *);


