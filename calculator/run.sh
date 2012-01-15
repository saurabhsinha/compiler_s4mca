lex cal.l
yacc -d cal.y
gcc lex.yy.c y.tab.c -ll
./a.out
