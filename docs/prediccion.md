# Conjuntos de PREDICCION

Los conjuntos de prediccion indican con que simbolos se puede elegir cada produccion de la gramatica.

La regla general es:

```text
Si una produccion no genera epsilon:
PREDICCION = PRIMERO(produccion)

Si una produccion genera epsilon:
PREDICCION = SIGUIENTE(no terminal)
```

## Producciones de inicio

```text
inicio -> linea inicio
inicio -> epsilon
```

Para:

```text
inicio -> linea inicio
```

se tiene:

```text
PREDICCION = { ID }
```

Para:

```text
inicio -> epsilon
```

se usa SIGUIENTE(inicio):

```text
PREDICCION = { $ }
```

## Produccion de linea

```text
linea -> ID = expr ;
```

Como empieza con `ID`:

```text
PREDICCION = { ID }
```

## Produccion de expr

```text
expr -> elemento sumaResta
```

Como `elemento` puede comenzar con:

```text
NUM
ID
(
sin
cos
tan
abs
```

entonces:

```text
PREDICCION = { NUM, ID, (, sin, cos, tan, abs }
```

## Producciones de sumaResta

```text
sumaResta -> + elemento sumaResta
sumaResta -> - elemento sumaResta
sumaResta -> epsilon
```

Para:

```text
sumaResta -> + elemento sumaResta
```

se tiene:

```text
PREDICCION = { + }
```

Para:

```text
sumaResta -> - elemento sumaResta
```

se tiene:

```text
PREDICCION = { - }
```

Para:

```text
sumaResta -> epsilon
```

se usa SIGUIENTE(sumaResta):

```text
PREDICCION = { ;, ) }
```

## Produccion de elemento

```text
elemento -> valor multDiv
```

Como `valor` puede comenzar con:

```text
NUM
ID
(
sin
cos
tan
abs
```

entonces:

```text
PREDICCION = { NUM, ID, (, sin, cos, tan, abs }
```

## Producciones de multDiv

```text
multDiv -> * valor multDiv
multDiv -> / valor multDiv
multDiv -> % valor multDiv
multDiv -> epsilon
```

Para:

```text
multDiv -> * valor multDiv
```

se tiene:

```text
PREDICCION = { * }
```

Para:

```text
multDiv -> / valor multDiv
```

se tiene:

```text
PREDICCION = { / }
```

Para:

```text
multDiv -> % valor multDiv
```

se tiene:

```text
PREDICCION = { % }
```

Para:

```text
multDiv -> epsilon
```

se usa SIGUIENTE(multDiv):

```text
PREDICCION = { +, -, ;, ) }
```

## Producciones de valor

```text
valor -> NUM
valor -> ID
valor -> ( expr )
valor -> operacion ( expr )
```

Para:

```text
valor -> NUM
```

se tiene:

```text
PREDICCION = { NUM }
```

Para:

```text
valor -> ID
```

se tiene:

```text
PREDICCION = { ID }
```

Para:

```text
valor -> ( expr )
```

se tiene:

```text
PREDICCION = { ( }
```

Para:

```text
valor -> operacion ( expr )
```

se tiene:

```text
PREDICCION = { sin, cos, tan, abs }
```

## Producciones de operacion

```text
operacion -> sin
operacion -> cos
operacion -> tan
operacion -> abs
```

Los conjuntos de prediccion son:

```text
PREDICCION(operacion -> sin) = { sin }

PREDICCION(operacion -> cos) = { cos }

PREDICCION(operacion -> tan) = { tan }

PREDICCION(operacion -> abs) = { abs }
```

## Resumen

```text
inicio -> linea inicio
{ ID }

inicio -> epsilon
{ $ }

linea -> ID = expr ;
{ ID }

expr -> elemento sumaResta
{ NUM, ID, (, sin, cos, tan, abs }

sumaResta -> + elemento sumaResta
{ + }

sumaResta -> - elemento sumaResta
{ - }

sumaResta -> epsilon
{ ;, ) }

elemento -> valor multDiv
{ NUM, ID, (, sin, cos, tan, abs }

multDiv -> * valor multDiv
{ * }

multDiv -> / valor multDiv
{ / }

multDiv -> % valor multDiv
{ % }

multDiv -> epsilon
{ +, -, ;, ) }

valor -> NUM
{ NUM }

valor -> ID
{ ID }

valor -> ( expr )
{ ( }

valor -> operacion ( expr )
{ sin, cos, tan, abs }

operacion -> sin
{ sin }

operacion -> cos
{ cos }

operacion -> tan
{ tan }

operacion -> abs
{ abs }
```

## Verificacion LL(1)

Los conjuntos de prediccion de las producciones alternativas no se cruzan entre si.

Por esta razon, el parser puede decidir que produccion utilizar observando un solo token de entrada.

Por lo tanto, la gramatica cumple con la condicion LL(1).