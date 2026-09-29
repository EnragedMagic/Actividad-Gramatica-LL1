# Gramatica LL(1)

Esta gramatica permite realizar asignaciones de variables y operaciones matematicas basicas.

Tambien permite utilizar las funciones:

- sin
- cos
- tan
- abs

## Gramatica

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

## Elementos del lenguaje

Los identificadores se representan mediante:

```text
ID
```

Ejemplos:

```text
x
numero
resultado
valor1
```

Los numeros se representan mediante:

```text
NUM
```

Ejemplos:

```text
5
10
3.14
25.5
```

## Operadores permitidos

```text
+
-
*
/
%
```

## Funciones permitidas

```text
sin
cos
tan
abs
```

## Asignacion de variables

Las variables se asignan utilizando el simbolo `=` y cada instruccion termina con `;`.

Ejemplo:

```text
x = 10;
```

Tambien se pueden asignar expresiones:

```text
resultado = 10 + 5 * 2;
```

## Ejemplos validos

```text
x = 5 + 3;
resultado = x * 2;
angulo = sin(30);
valor = abs(10 - 20);
total = (5 + 3) * 2;
resultado = abs(sin(30) + 5);
```

## Ejemplos invalidos

```text
x = + 5;
resultado = 5 * ;
sin();
= 10;
```

## Precedencia de operadores

La gramatica mantiene el orden de prioridad de las operaciones.

Primero se evaluan:

```text
*
/
%
```

Despues:

```text
+
-
```

Los parentesis permiten cambiar el orden normal de evaluacion.

Por ejemplo:

```text
x = 5 + 3 * 2;
```

Primero se realiza la multiplicacion.

Mientras que:

```text
x = (5 + 3) * 2;
```

Primero se realiza la operacion que se encuentra dentro de los parentesis.