%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tokens.h"
%}

DIGITO      [0-9]
LETRA       [a-zA-Z_]
IDTOKEN     {LETRA}({LETRA}|{DIGITO})*
NUMERO      {DIGITO}+(\.{DIGITO}+)?

%%

"sin"           { return SIN; }
"cos"           { return COS; }
"tan"           { return TAN; }
"abs"           { return ABS; }

{NUMERO}        {
                    numeroActual = atof(yytext);
                    return NUM;
                }

{IDTOKEN}       {
                    strcpy(textoActual, yytext);
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

[ \t\r\n]+      {
                    /* Se ignoran espacios y saltos de linea */
                }

.               {
                    printf("Error lexico: caracter no valido '%s'\n", yytext);
                }

%%

int yywrap()
{
    return 1;
}