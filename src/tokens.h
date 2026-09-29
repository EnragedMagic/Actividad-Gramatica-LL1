#ifndef TOKENS_H
#define TOKENS_H

enum Tokens {
    NUM = 256,
    ID,
    SIN,
    COS,
    TAN,
    ABS,
    MAS,
    MENOS,
    MULT,
    DIV,
    MOD,
    IGUAL,
    PUNTOCOMA,
    PAR_IZQ,
    PAR_DER
};

extern double numeroActual;
extern char textoActual[100];

#endif