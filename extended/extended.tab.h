/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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
     STRING = 258,
     IDENTIFIER = 259,
     NUMBER = 260,
     PIPELINE = 261,
     AGENT = 262,
     STAGES = 263,
     STAGE = 264,
     STEPS = 265,
     ECHO = 266,
     SH = 267,
     SCRIPT = 268,
     IF = 269,
     ELSE = 270,
     TRUE = 271,
     FALSE = 272,
     ANY = 273,
     LABEL = 274,
     ENV = 275,
     POST = 276,
     SUCCESS = 277,
     FAILURE = 278,
     OPTIONS = 279,
     FOR = 280,
     INCR = 281,
     DEF = 282,
     NEQ = 283
   };
#endif
/* Tokens.  */
#define STRING 258
#define IDENTIFIER 259
#define NUMBER 260
#define PIPELINE 261
#define AGENT 262
#define STAGES 263
#define STAGE 264
#define STEPS 265
#define ECHO 266
#define SH 267
#define SCRIPT 268
#define IF 269
#define ELSE 270
#define TRUE 271
#define FALSE 272
#define ANY 273
#define LABEL 274
#define ENV 275
#define POST 276
#define SUCCESS 277
#define FAILURE 278
#define OPTIONS 279
#define FOR 280
#define INCR 281
#define DEF 282
#define NEQ 283




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 12 "extended.y"
{
  char *str;
}
/* Line 1529 of yacc.c.  */
#line 109 "extended.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

