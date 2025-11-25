%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex(void);
extern int yylineno;
void yyerror(const char *s) {
    fprintf(stderr, "Parse error (line %d): %s\n", yylineno, s);
}
%}

%union {
  char *str;
}

%token <str> STRING IDENTIFIER NUMBER
%token PIPELINE AGENT STAGES STAGE STEPS ECHO SH SCRIPT IF ELSE TRUE FALSE ANY

%type <str> agent_value expression

%start program

%%

program:
    /* empty */
  | program pipeline
  ;

pipeline:
    PIPELINE '{' agent stages '}' { printf("[OK] pipeline parsed\n"); }
  ;

agent:
    AGENT agent_value { printf("[INFO] agent: %s\n", $2); free($2); }
  ;

agent_value:
    ANY { $$ = strdup("any"); }
  | STRING { $$ = $1; }
  ;

stages:
    STAGES '{' stage_list '}'
  ;

stage_list:
    stage_list stage
  | stage
  ;

stage:
    STAGE '(' STRING ')' '{' steps '}' { printf("[INFO] stage: %s\n", $3); free($3); }
  ;

steps:
    STEPS '{' step_list '}'
  ;

step_list:
    step_list step
  | step
  ;

step:
    ECHO STRING { printf("[STEP] echo \"%s\"\n", $2); free($2); }
  | SH STRING   { printf("[STEP] sh \"%s\"\n", $2); free($2); }
  | SCRIPT '{' script_body '}' { printf("[STEP] script block\n"); }
  ;

script_body:
    statement_list
  ;

statement_list:
    /* empty */
  | statement_list statement
  ;

statement:
    if_statement
  | assignment
  | expression_stmt
  ;

if_statement:
    IF '(' expression ')' '{' statement_list '}'
      { printf("[SCRIPT] if (expr) {...}\n"); }
  | IF '(' expression ')' '{' statement_list '}' ELSE '{' statement_list '}'
      { printf("[SCRIPT] if-else\n"); }
  ;

assignment:
    IDENTIFIER '=' expression
      { printf("[SCRIPT] assign %s = %s\n", $1, $3); free($1); free($3); }
  ;

expression_stmt:
    expression { if ($1) { printf("[SCRIPT] expr: %s\n", $1); free($1); } }
  ;

expression:
    IDENTIFIER { $$ = $1; }
  | STRING     { $$ = $1; }
  | NUMBER     { $$ = $1; }
  | TRUE       { $$ = strdup("true"); }
  | FALSE      { $$ = strdup("false"); }
  ;

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) { perror(argv[1]); return 2; }
        extern FILE *yyin;
        yyin = f;
    }
    if (yyparse() == 0) {
        return 0;
    }
    return 1;
}
