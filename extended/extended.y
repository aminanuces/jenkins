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
%token LABEL ENV POST SUCCESS FAILURE OPTIONS FOR INCR DEF NEQ

%type <str> agent_value expression

%start program

%%

program:
    /* empty */
  | program pipeline
  ;

pipeline:
    PIPELINE '{' pipeline_body '}' { printf("[OK] pipeline parsed\n"); }
  ;

pipeline_body:
    agent_opt pipeline_items
  ;

agent_opt:
    /* empty */
  | AGENT agent_value { printf("[INFO] agent: %s\n", $2); free($2); }
  | AGENT '{' agent_block '}' { /* handled in agent_block */ }
  ;

agent_block:
    LABEL STRING { printf("[INFO] agent.label %s\n", $2); free($2); }
  ;

agent_value:
    ANY { $$ = strdup("any"); }
  | STRING { $$ = $1; }
  ;

pipeline_items:
    pipeline_items pipeline_item
  | pipeline_item
  ;

pipeline_item:
    stages
  | environment
  | options
  | post
  ;

options:
    OPTIONS '{' option_list '}'
  ;

option_list:
    /* empty */
  | option_list option
  ;

option:
    IDENTIFIER '(' named_arg_list ')' { free($1); }
  | IDENTIFIER '(' NUMBER ')' { free($1); }
  | IDENTIFIER { free($1); }
  ;

environment:
    ENV '{' assignment_list '}' { /* environment block (assignments handled by assignment actions) */ }
  ;

assignment_list:
    assignment_list assignment
  | assignment
  ;

/* reuse assignment from base grammar */

post:
    POST '{' post_blocks '}'
  ;

post_blocks:
    post_blocks post_block
  | post_block
  ;

post_block:
    SUCCESS '{' step_list '}' { /* print minimal */ printf("[POST] success\n"); }
  | FAILURE '{' step_list '}' { printf("[POST] failure\n"); }
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
  | IDENTIFIER '(' named_arg_list ')' { printf("[CALL] %s(...named-args...)\n", $1); free($1); }
  | IDENTIFIER named_arg_seq { printf("[CALL] %s(...named-args...)\n", $1); free($1); }
  | IDENTIFIER STRING { printf("[CALL] %s %s\n", $1, $2); free($1); free($2); }
  ;

named_arg_list:
    named_arg_list ',' named_arg
  | named_arg
  ;

named_arg_seq:
    named_arg_seq named_arg
  | named_arg
  ;

named_arg:
    IDENTIFIER ':' expression { /* ignore values, free */ free($1); if ($3) free($3); }
  | SCRIPT ':' expression { /* script can appear as a named-arg name; treat as literal "script" */ if ($3) free($3); }
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
  | for_statement
  | call_statement
  ;

call_statement:
    ECHO STRING { printf("[STEP] echo \"%s\"\n", $2); free($2); }
  | SH STRING   { printf("[STEP] sh \"%s\"\n", $2); free($2); }
  | IDENTIFIER '(' named_arg_list ')' { printf("[CALL] %s(...named-args...)\n", $1); free($1); }
  | IDENTIFIER named_arg_seq { printf("[CALL] %s(...named-args...)\n", $1); free($1); }
  | IDENTIFIER STRING { printf("[CALL] %s %s\n", $1, $2); free($1); free($2); }
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
  | DEF IDENTIFIER '=' expression
    { printf("[SCRIPT] assign %s = %s\n", $2, $4); free($2); free($4); }
  ;

opt_type:
    /* empty */
  | IDENTIFIER { free($1); }
  ;

for_statement:
    FOR '(' opt_type IDENTIFIER '=' expression ';' expression ';' IDENTIFIER INCR ')' '{' statement_list '}'
      { printf("[SCRIPT] for-loop\n"); }
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
  | expression NEQ expression {
      size_t n = strlen($1) + strlen($3) + 4;
      char *s = malloc(n);
      if (!s) exit(1);
      snprintf(s, n, "%s!=%s", $1, $3);
      free($1); free($3);
      $$ = s;
    }
  | expression '<' expression {
      size_t n = strlen($1) + strlen($3) + 4;
      char *s = malloc(n);
      if (!s) exit(1);
      snprintf(s, n, "%s<%s", $1, $3);
      free($1); free($3);
      $$ = s;
    }
  | IDENTIFIER '(' named_arg_list ')' { char *s = strdup($1); free($1); $$ = s; }
  | IDENTIFIER named_arg_seq { char *s = strdup($1); free($1); $$ = s; }
  | IDENTIFIER STRING { char *s = strdup($1); free($1); free($2); $$ = s; }
  | SH '(' named_arg_list ')' { $$ = strdup("sh"); }
  | SH STRING { $$ = strdup("sh"); }
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
