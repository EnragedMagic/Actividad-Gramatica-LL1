#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "tokens.h"

/* Funcion generada por Flex */
int yylex();

/* Token actual que esta leyendo el parser */
int tokenActual;

/* Variables usadas por el scanner */
double numeroActual;
char textoActual[100];

/* Estructura para guardar variables */
typedef struct
{
    char nombre[50];
    double valor;
} Variable;

/* Tabla de variables */
Variable tabla[100];
int totalVariables = 0;

/* Permite saber si hubo error semantico */
int errorSemantico = 0;


/* Avanza al siguiente token */
void avanzar()
{
    tokenActual = yylex();
}


/* Muestra un error sintactico y termina */
void errorSintactico(const char *mensaje)
{
    printf("Error sintactico: %s\n", mensaje);
    exit(1);
}


/* Busca una variable en la tabla */
double buscarVariable(const char *nombre)
{
    int i;

    for (i = 0; i < totalVariables; i++)
    {
        if (strcmp(tabla[i].nombre, nombre) == 0)
        {
            return tabla[i].valor;
        }
    }

    printf("Error semantico: variable %s no definida\n", nombre);

    errorSemantico = 1;

    return 0;
}


/* Guarda una variable nueva o actualiza una existente */
void guardarVariable(const char *nombre, double valor)
{
    int i;

    for (i = 0; i < totalVariables; i++)
    {
        if (strcmp(tabla[i].nombre, nombre) == 0)
        {
            tabla[i].valor = valor;
            return;
        }
    }

    strcpy(tabla[totalVariables].nombre, nombre);
    tabla[totalVariables].valor = valor;

    totalVariables++;
}


/* Declaracion de las funciones del parser */
void inicio();
void linea();

double expr();
double elemento();
double valor();
double operacion();

double sumaResta(double acumulado);
double multDiv(double acumulado);


/*
    inicio -> linea inicio
            | epsilon
*/
void inicio()
{
    while (tokenActual != 0)
    {
        if (tokenActual == ID)
        {
            linea();
        }
        else
        {
            errorSintactico("se esperaba un identificador");
        }
    }
}


/*
    linea -> ID = expr ;
*/
void linea()
{
    char nombreVariable[100];
    double resultado;

    /* Guardamos el nombre de la variable */
    if (tokenActual == ID)
    {
        strcpy(nombreVariable, textoActual);
        avanzar();
    }
    else
    {
        errorSintactico("se esperaba un identificador");
    }

    /* Verificamos el simbolo = */
    if (tokenActual == IGUAL)
    {
        avanzar();
    }
    else
    {
        errorSintactico("se esperaba =");
    }

    /* Evaluamos la expresion */
    resultado = expr();

    /* La instruccion debe terminar en ; */
    if (tokenActual == PUNTOCOMA)
    {
        avanzar();
    }
    else
    {
        errorSintactico("se esperaba ;");
    }

    /* Solo guardamos si no hubo error semantico */
    if (!errorSemantico)
    {
        guardarVariable(nombreVariable, resultado);

        printf("%s = %.2f\n", nombreVariable, resultado);
    }

    /* Reiniciamos el estado para la siguiente linea */
    errorSemantico = 0;
}


/*
    expr -> elemento sumaResta
*/
double expr()
{
    double resultado;

    resultado = elemento();

    resultado = sumaResta(resultado);

    return resultado;
}


/*
    sumaResta -> + elemento sumaResta
               | - elemento sumaResta
               | epsilon
*/
double sumaResta(double acumulado)
{
    while (tokenActual == MAS || tokenActual == MENOS)
    {
        int operador = tokenActual;
        double siguienteValor;

        avanzar();

        siguienteValor = elemento();

        if (operador == MAS)
        {
            acumulado += siguienteValor;
        }
        else
        {
            acumulado -= siguienteValor;
        }
    }

    return acumulado;
}


/*
    elemento -> valor multDiv
*/
double elemento()
{
    double resultado;

    resultado = valor();

    resultado = multDiv(resultado);

    return resultado;
}


/*
    multDiv -> * valor multDiv
             | / valor multDiv
             | % valor multDiv
             | epsilon
*/
double multDiv(double acumulado)
{
    while (
        tokenActual == MULT ||
        tokenActual == DIV ||
        tokenActual == MOD
    )
    {
        int operador = tokenActual;
        double siguienteValor;

        avanzar();

        siguienteValor = valor();

        if (operador == MULT)
        {
            acumulado *= siguienteValor;
        }

        else if (operador == DIV)
        {
            if (siguienteValor == 0)
            {
                printf("Error semantico: division por cero\n");

                errorSemantico = 1;
            }
            else
            {
                acumulado /= siguienteValor;
            }
        }

        else if (operador == MOD)
        {
            if (siguienteValor == 0)
            {
                printf("Error semantico: modulo por cero\n");

                errorSemantico = 1;
            }
            else
            {
                acumulado = fmod(acumulado, siguienteValor);
            }
        }
    }

    return acumulado;
}


/*
    valor -> NUM
           | ID
           | ( expr )
           | operacion ( expr )
*/
double valor()
{
    double resultado;

    /* Numero */
    if (tokenActual == NUM)
    {
        resultado = numeroActual;

        avanzar();

        return resultado;
    }

    /* Variable */
    if (tokenActual == ID)
    {
        char nombre[100];

        strcpy(nombre, textoActual);

        avanzar();

        return buscarVariable(nombre);
    }

    /* Expresion entre parentesis */
    if (tokenActual == PAR_IZQ)
    {
        avanzar();

        resultado = expr();

        if (tokenActual == PAR_DER)
        {
            avanzar();
        }
        else
        {
            errorSintactico("se esperaba )");
        }

        return resultado;
    }

    /* Funciones sin, cos, tan y abs */
    if (
        tokenActual == SIN ||
        tokenActual == COS ||
        tokenActual == TAN ||
        tokenActual == ABS
    )
    {
        double tipoOperacion;
        double parametro;

        tipoOperacion = operacion();

        if (tokenActual == PAR_IZQ)
        {
            avanzar();
        }
        else
        {
            errorSintactico("se esperaba (");
        }

        parametro = expr();

        if (tokenActual == PAR_DER)
        {
            avanzar();
        }
        else
        {
            errorSintactico("se esperaba )");
        }

        if (tipoOperacion == 1)
        {
            return sin(parametro);
        }

        if (tipoOperacion == 2)
        {
            return cos(parametro);
        }

        if (tipoOperacion == 3)
        {
            return tan(parametro);
        }

        return fabs(parametro);
    }

    errorSintactico("se esperaba un valor");

    return 0;
}


/*
    operacion -> sin
               | cos
               | tan
               | abs
*/
double operacion()
{
    if (tokenActual == SIN)
    {
        avanzar();
        return 1;
    }

    if (tokenActual == COS)
    {
        avanzar();
        return 2;
    }

    if (tokenActual == TAN)
    {
        avanzar();
        return 3;
    }

    if (tokenActual == ABS)
    {
        avanzar();
        return 4;
    }

    errorSintactico("funcion no valida");

    return 0;
}


/* Inicio del programa */
int main()
{
    printf("Analizador LL(1)\n");
    printf("Ingrese las expresiones:\n\n");

    /* Se obtiene el primer token */
    avanzar();

    /* Comienza el analisis sintactico */
    inicio();

    return 0;
}