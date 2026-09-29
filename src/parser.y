%code requires {
    /* Estructura usada para guardar operadores y valores */
    typedef struct {
        int cantidad;
        int operadores[100];
        double valores[100];
    } ListaOperaciones;
}

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int yylex();
void yyerror(const char *s);

/* Estructura para guardar una variable */
typedef struct {
    char nombre[50];
    double valor;
} Variable;

/* Tabla donde se guardan las variables */
Variable tabla[100];
int totalVariables = 0;

/* Indica si ocurrio un error semantico */
int errorSemantico = 0;


/* Busca una variable dentro de la tabla */
double buscarVariable(char *nombre)
{
    int i;

    for (i = 0; i < totalVariables; i++)
    {
        if (strcmp(tabla[i].nombre, nombre) == 0)
        {
            return tabla[i].valor;
        }
    }

    /* Si la variable no existe se genera un error */
    printf("Error semantico: variable %s no definida\n", nombre);

    errorSemantico = 1;

    return 0;
}


/* Guarda una variable nueva o actualiza una existente */
void guardarVariable(char *nombre, double valor)
{
    int i;

    /* Primero revisamos si la variable ya existe */
    for (i = 0; i < totalVariables; i++)
    {
        if (strcmp(tabla[i].nombre, nombre) == 0)
        {
            tabla[i].valor = valor;
            return;
        }
    }

    /* Si no existe se agrega a la tabla */
    strcpy(tabla[totalVariables].nombre, nombre);
    tabla[totalVariables].valor = valor;

    totalVariables++;
}
%}


/* Tipos de datos que pueden manejar los tokens */
%union {
    double numero;
    char *texto;
    ListaOperaciones lista;
}


/* Tokens principales */
%token <numero> NUM
%token <texto> ID

/* Funciones matematicas */
%token SIN COS TAN ABS

/* Operadores */
%token MAS MENOS MULT DIV MOD

/* Simbolos de asignacion */
%token IGUAL PUNTOCOMA

/* Parentesis */
%token PAR_IZQ PAR_DER


/* Tipos usados por las reglas */
%type <numero> expr elemento valor operacion
%type <lista> sumaResta multDiv


/* Simbolo inicial */
%start inicio

%%


/* Permite procesar varias lineas */
inicio:
      linea inicio
    |
    ;


/* Asignacion de una expresion a una variable */
linea:
      ID IGUAL expr PUNTOCOMA
      {
          /*
             Solo se guarda el resultado si no hubo
             un error semantico durante la operacion
          */
          if (!errorSemantico)
          {
              guardarVariable($1, $3);

              printf("%s = %.2f\n", $1, $3);
          }

          /* Reiniciamos el estado para la siguiente linea */
          errorSemantico = 0;

          free($1);
      }
    ;


/* Procesa suma y resta */
expr:
      elemento sumaResta
      {
          double resultado = $1;
          int i;

          /*
             Se recorren las operaciones de suma y resta
             en el mismo orden en que fueron escritas
          */
          for (i = 0; i < $2.cantidad; i++)
          {
              if ($2.operadores[i] == 1)
              {
                  resultado += $2.valores[i];
              }
              else
              {
                  resultado -= $2.valores[i];
              }
          }

          $$ = resultado;
      }
    ;


/* Guarda las operaciones de suma y resta */
sumaResta:
      MAS elemento sumaResta
      {
          int i;

          $$.cantidad = $3.cantidad + 1;

          /* 1 representa suma */
          $$.operadores[0] = 1;
          $$.valores[0] = $2;

          /* Copiamos las operaciones que siguen */
          for (i = 0; i < $3.cantidad; i++)
          {
              $$.operadores[i + 1] = $3.operadores[i];
              $$.valores[i + 1] = $3.valores[i];
          }
      }

    | MENOS elemento sumaResta
      {
          int i;

          $$.cantidad = $3.cantidad + 1;

          /* 2 representa resta */
          $$.operadores[0] = 2;
          $$.valores[0] = $2;

          /* Copiamos las operaciones que siguen */
          for (i = 0; i < $3.cantidad; i++)
          {
              $$.operadores[i + 1] = $3.operadores[i];
              $$.valores[i + 1] = $3.valores[i];
          }
      }

    |
      {
          /* No hay mas sumas ni restas */
          $$.cantidad = 0;
      }
    ;


/* Procesa multiplicacion, division y modulo */
elemento:
      valor multDiv
      {
          double resultado = $1;
          int i;

          /*
             Se recorren las operaciones en orden
             para mantener la asociatividad correcta
          */
          for (i = 0; i < $2.cantidad; i++)
          {
              /* Multiplicacion */
              if ($2.operadores[i] == 1)
              {
                  resultado *= $2.valores[i];
              }

              /* Division */
              else if ($2.operadores[i] == 2)
              {
                  if ($2.valores[i] == 0)
                  {
                      printf("Error semantico: division por cero\n");

                      errorSemantico = 1;
                  }
                  else
                  {
                      resultado /= $2.valores[i];
                  }
              }

              /* Modulo */
              else if ($2.operadores[i] == 3)
              {
                  if ($2.valores[i] == 0)
                  {
                      printf("Error semantico: modulo por cero\n");

                      errorSemantico = 1;
                  }
                  else
                  {
                      resultado = fmod(resultado, $2.valores[i]);
                  }
              }
          }

          $$ = resultado;
      }
    ;


/* Guarda las operaciones de multiplicacion, division y modulo */
multDiv:
      MULT valor multDiv
      {
          int i;

          $$.cantidad = $3.cantidad + 1;

          /* 1 representa multiplicacion */
          $$.operadores[0] = 1;
          $$.valores[0] = $2;

          for (i = 0; i < $3.cantidad; i++)
          {
              $$.operadores[i + 1] = $3.operadores[i];
              $$.valores[i + 1] = $3.valores[i];
          }
      }

    | DIV valor multDiv
      {
          int i;

          $$.cantidad = $3.cantidad + 1;

          /* 2 representa division */
          $$.operadores[0] = 2;
          $$.valores[0] = $2;

          for (i = 0; i < $3.cantidad; i++)
          {
              $$.operadores[i + 1] = $3.operadores[i];
              $$.valores[i + 1] = $3.valores[i];
          }
      }

    | MOD valor multDiv
      {
          int i;

          $$.cantidad = $3.cantidad + 1;

          /* 3 representa modulo */
          $$.operadores[0] = 3;
          $$.valores[0] = $2;

          for (i = 0; i < $3.cantidad; i++)
          {
              $$.operadores[i + 1] = $3.operadores[i];
              $$.valores[i + 1] = $3.valores[i];
          }
      }

    |
      {
          /* No hay mas multiplicaciones o divisiones */
          $$.cantidad = 0;
      }
    ;


/* Valores que puede tener una expresion */
valor:
      NUM
      {
          $$ = $1;
      }

    | ID
      {
          /* Busca el valor de una variable */
          $$ = buscarVariable($1);

          free($1);
      }

    | PAR_IZQ expr PAR_DER
      {
          /* Devuelve el resultado dentro del parentesis */
          $$ = $2;
      }

    | operacion PAR_IZQ expr PAR_DER
      {
          /* Ejecuta la funcion correspondiente */
          if ($1 == 1)
          {
              $$ = sin($3);
          }

          else if ($1 == 2)
          {
              $$ = cos($3);
          }

          else if ($1 == 3)
          {
              $$ = tan($3);
          }

          else
          {
              $$ = fabs($3);
          }
      }
    ;


/* Identifica que funcion matematica se va a usar */
operacion:
      SIN
      {
          /* 1 representa sin */
          $$ = 1;
      }

    | COS
      {
          /* 2 representa cos */
          $$ = 2;
      }

    | TAN
      {
          /* 3 representa tan */
          $$ = 3;
      }

    | ABS
      {
          /* 4 representa abs */
          $$ = 4;
      }
    ;

%%


/* Se ejecuta cuando Bison encuentra un error sintactico */
void yyerror(const char *s)
{
    printf("Error sintactico: %s\n", s);
}


/* Inicio del programa */
int main()
{
    printf("Analizador de Gramatica LL(1)\n");
    printf("Ingrese las expresiones:\n\n");

    yyparse();

    return 0;
}