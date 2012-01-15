lex exp.l
yacc -d exp.y
gcc lex.yy.c y.tab.c -ll
./a.out
