# Gramatica LL(1)

Esta actividad implementa una gramatica LL(1) capaz de procesar expresiones matematicas, asignacion de variables y funciones como sin, cos, tan y abs.

El proyecto incluye las partes:

- Analisis lexico
- Analisis sintactico
- Analisis semantico
- Conjuntos PRIMEROS
- Conjuntos SIGUIENTES
- Conjuntos de PREDICCION
- Pruebas de implementacion

## Hecho por

- Johan Galeano

## Funcionalidades

La gramatica permite trabajar con:

```text
+
-
*
/
%
```

Tambien permite las funciones:

```text
sin
cos
tan
abs
```

Se pueden realizar asignaciones de variables como:

```text
x = 10;
```

Tambien se pueden utilizar expresiones:

```text
resultado = 10 + 5 * 2;
```

Y funciones matematicas:

```text
angulo = sin(30);
valor = abs(5 - 20);
```

## Estructura del proyecto

```text
GramaticaLL1/
│
├── docs/
│   ├── gramatica.md
│   ├── primeros.md
│   ├── siguientes.md
│   └── prediccion.md
│
├── src/
│   ├── scanner.l
│   └── parser.y
│
├── evidencias/
│   ├── pruebas_validas.png
│   └── pruebas_errores.png
│
└── README.md
```

## Gramatica utilizada

```text
inicio -> linea inicio
        | epsilon

linea -> ID = expr ;

expr -> elemento sumaResta

sumaResta -> + elemento sumaResta
           | - elemento sumaResta
           | epsilon

elemento -> valor multDiv

multDiv -> * valor multDiv
         | / valor multDiv
         | % valor multDiv
         | epsilon

valor -> NUM
       | ID
       | ( expr )
       | operacion ( expr )

operacion -> sin
           | cos
           | tan
           | abs
```

## Analisis lexico

El analisis lexico se encuentra en:

```text
src/scanner.l
```

Este archivo reconoce:

- Numeros
- Identificadores
- Operadores
- Parentesis
- Asignaciones
- Funciones matematicas

Algunos tokens utilizados son:

```text
NUM
ID
SIN
COS
TAN
ABS
MAS
MENOS
MULT
DIV
MOD
IGUAL
PUNTOCOMA
PAR_IZQ
PAR_DER
```

## Analisis sintactico

El analisis sintactico se encuentra en:

```text
src/parser.y
```

El parser verifica que las expresiones cumplan con la estructura definida en la gramatica.

Por ejemplo:

```text
x = 10 + 5;
```

es una expresion valida.

Mientras que:

```text
x = + 5;
```

genera un error sintactico.

## Analisis semantico

La parte semantica permite:

- Guardar variables
- Consultar variables
- Actualizar valores
- Realizar operaciones matematicas
- Detectar variables no definidas
- Detectar division por cero
- Detectar modulo por cero

Ejemplo:

```text
x = 10;
y = x + 5;
```

Resultado:

```text
x = 10.00
y = 15.00
```

Si se utiliza una variable que no existe:

```text
dato = variableNoExiste + 2;
```

se genera:

```text
Error semantico: variable variableNoExiste no definida
```

## PRIMEROS

Los conjuntos PRIMEROS se encuentran explicados en:

```text
docs/primeros.md
```

Resumen:

```text
PRIMERO(inicio)     = { ID, epsilon }

PRIMERO(linea)      = { ID }

PRIMERO(expr)       = { NUM, ID, (, sin, cos, tan, abs }

PRIMERO(sumaResta)  = { +, -, epsilon }

PRIMERO(elemento)   = { NUM, ID, (, sin, cos, tan, abs }

PRIMERO(multDiv)    = { *, /, %, epsilon }

PRIMERO(valor)      = { NUM, ID, (, sin, cos, tan, abs }

PRIMERO(operacion)  = { sin, cos, tan, abs }
```

## SIGUIENTES

Los conjuntos SIGUIENTES se encuentran en:

```text
docs/siguientes.md
```

Resumen:

```text
SIGUIENTE(inicio)      = { $ }

SIGUIENTE(linea)       = { ID, $ }

SIGUIENTE(expr)        = { ;, ) }

SIGUIENTE(sumaResta)   = { ;, ) }

SIGUIENTE(elemento)    = { +, -, ;, ) }

SIGUIENTE(multDiv)     = { +, -, ;, ) }

SIGUIENTE(valor)       = { *, /, %, +, -, ;, ) }

SIGUIENTE(operacion)   = { ( }
```

## PREDICCION

Los conjuntos de prediccion se encuentran en:

```text
docs/prediccion.md
```

Estos conjuntos permiten determinar que produccion utilizar observando un solo token de entrada.

Esto permite verificar que la gramatica cumple con la condicion LL(1).

## Compilacion

Para generar el parser:

```bash
bison -d parser.y
```

Para generar el scanner:

```bash
flex scanner.l
```

Para compilar el programa:

```bash
gcc parser.tab.c lex.yy.c -o analizador -lm
```

Para ejecutar:

```bash
./analizador
```

## Pruebas validas

Se realizaron las siguientes pruebas:

```text
x = 10 + 5 * 2;
y = x / 4;
z = abs(5 - 20);
a = 20 / 5 / 2;
b = 20 % 6;
```

Resultados:

```text
x = 20.00
y = 5.00
z = 15.00
a = 2.00
b = 2.00
```

### Evidencia

![Pruebas validas](evidencias/pruebas_validas.png)

## Pruebas de errores

Se probaron errores sintacticos como:

```text
x = + 5;
resultado = 5 * ;
```

Tambien errores semanticos como:

```text
dato = variableNoExiste + 2;
division = 10 / 0;
```

El programa detecta correctamente estos casos.

### Evidencia

![Pruebas de errores](evidencias/pruebas_errores.png)

## Conclusion

Con este proyecto se implemento una gramatica LL(1) para procesar expresiones matematicas y asignaciones de variables.

Tambien se implementaron las etapas lexica, sintactica y semantica, ademas de los conjuntos PRIMEROS, SIGUIENTES y PREDICCION.

Las pruebas realizadas permitieron comprobar que la gramatica acepta expresiones validas y tambien detecta errores en las entradas incorrectas.