
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     DO = 258,
     ENDWHILE = 259,
     DIGIT = 260,
     VAR = 261,
     READ = 262,
     WRITE = 263,
     BEGN = 264,
     ED = 265,
     IF = 266,
     THEN = 267,
     ELSE = 268,
     ENDIF = 269,
     GE = 270,
     LE = 271,
     EQ = 272,
     NE = 273,
     GT = 274,
     WHILE = 275,
     DECL = 276,
     ENDDECL = 277,
     INTEGER = 278,
     BOOLEAN = 279
   };
#endif
/* Tokens.  */
#define DO 258
#define ENDWHILE 259
#define DIGIT 260
#define VAR 261
#define READ 262
#define WRITE 263
#define BEGN 264
#define ED 265
#define IF 266
#define THEN 267
#define ELSE 268
#define ENDIF 269
#define GE 270
#define LE 271
#define EQ 272
#define NE 273
#define GT 274
#define WHILE 275
#define DECL 276
#define ENDDECL 277
#define INTEGER 278
#define BOOLEAN 279




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 18 "exp.y"
	struct Tnode *T;
			


/* Line 1676 of yacc.c  */
#line 105 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


