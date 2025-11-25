%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "jenkins.tab.h"
extern int yylineno;
/* yylval provided by bison */
extern YYSTYPE yylval;

static char *strip_quotes(const char *s) {
    size_t len = strlen(s);
    if (len >= 2) {
        char *out = (char*)malloc(len - 1);
        if (!out) return NULL;
        memcpy(out, s+1, len-2);
        out[len-2] = '\0';
        return out;
    }
    return strdup("");
}
%}

%%
[ \t\r\n]+            { /* skip whitespace */ }
"//".*                { /* skip single-line comments */ }
"/*"([^*]|\*+[^*/])*"*/"   { /* skip block comments (simple) */ }
"pipeline"            { return PIPELINE; }
"agent"               { return AGENT; }
"stages"              { return STAGES; }
"stage"               { return STAGE; }
"steps"               { return STEPS; }
"echo"                { return ECHO; }
"sh"                  { return SH; }
"script"              { return SCRIPT; }
"if"                  { return IF; }
"else"                { return ELSE; }
"true"                { yylval.str = strdup("true"); return TRUE; }
"false"               { yylval.str = strdup("false"); return FALSE; }
"any"                 { return ANY; }


"\'"([^'\\]|\\.)*"\'"   {
    yylval.str = strip_quotes(yytext);
    return STRING;
}
"\""([^"\\]|\\.)*"\""   {
    yylval.str = strip_quotes(yytext);
    return STRING;
}

[0-9]+(\.[0-9]+)?  {
    yylval.str = strdup(yytext);
    return NUMBER;
}

[A-Za-z][A-Za-z0-9]*  {
    yylval.str = strdup(yytext);
    return IDENTIFIER;
}

"{"           { return '{'; }
"}"           { return '}'; }
"("           { return '('; }
")"           { return ')'; }
"="           { return '='; }

.               { fprintf(stderr, "Unknown char '%c' at line %d\n", yytext[0], yylineno); }

%%

int yywrap() { return 1; }
