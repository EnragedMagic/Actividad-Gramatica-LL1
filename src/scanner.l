%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

DIGITO      [0-9]
LETRA       [a-zA-Z_]
ID          {LETRA}({LETRA}|{DIGITO})*
NUMERO      {DIGITO}+(\.{DIGITO}+)?

%%

"sin"           { return SIN; }
"cos"           { return COS; }
"tan"           { return TAN; }
"abs"           { return ABS; }

{NUMERO}        {
                    yylval.numero = atof(yytext);
                    return NUM;
                }

{ID}            {
                    yylval.texto = strdup(yytext);
                    return ID;
                }

"+"             { return MAS; }
"-"             { return MENOS; }
"*"             { return MULT; }
"/"             { return DIV; }
"%"             { return MOD; }

"="             { return IGUAL; }
";"             { return PUNTOCOMA; }

"("             { return PAR_IZQ; }
")"             { return PAR_DER; }

[ \t\r\n]+      { /* ignorar espacios */ }

.               {
                    return yytext[0];
                }

%%

int yywrap()
{
    return 1;
}