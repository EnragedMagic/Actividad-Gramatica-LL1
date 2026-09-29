# Conjuntos SIGUIENTES

Los conjuntos SIGUIENTES indican que simbolos pueden aparecer despues de un no terminal.

## SIGUIENTE(inicio)

```text
SIGUIENTE(inicio) = { $ }
```

Como `inicio` es el simbolo inicial de la gramatica, su conjunto SIGUIENTE contiene `$`.

## SIGUIENTE(linea)

```text
SIGUIENTE(linea) = { ID, $ }
```

La regla es:

```text
inicio -> linea inicio
```

Despues de `linea` aparece `inicio`.

Como:

```text
PRIMERO(inicio) = { ID, epsilon }
```

se agrega `ID`.

Como `inicio` tambien puede producir `epsilon`, se agrega tambien:

```text
SIGUIENTE(inicio) = { $ }
```

## SIGUIENTE(expr)

```text
SIGUIENTE(expr) = { ;, ) }
```

`expr` aparece en:

```text
linea -> ID = expr ;
```

Por eso se agrega `;`.

Tambien aparece en:

```text
valor -> ( expr )
```

y:

```text
valor -> operacion ( expr )
```

Por eso tambien se agrega `)`.

## SIGUIENTE(sumaResta)

```text
SIGUIENTE(sumaResta) = { ;, ) }
```

La regla es:

```text
expr -> elemento sumaResta
```

Como `sumaResta` aparece al final, toma el conjunto SIGUIENTE de `expr`.

## SIGUIENTE(elemento)

```text
SIGUIENTE(elemento) = { +, -, ;, ) }
```

En:

```text
expr -> elemento sumaResta
```

despues de `elemento` aparece `sumaResta`.

Como:

```text
PRIMERO(sumaResta) = { +, -, epsilon }
```

se agregan `+` y `-`.

Como `sumaResta` puede producir `epsilon`, tambien se agrega:

```text
SIGUIENTE(expr) = { ;, ) }
```

## SIGUIENTE(multDiv)

```text
SIGUIENTE(multDiv) = { +, -, ;, ) }
```

La regla es:

```text
elemento -> valor multDiv
```

Como `multDiv` aparece al final, toma el conjunto SIGUIENTE de `elemento`.

## SIGUIENTE(valor)

```text
SIGUIENTE(valor) = { *, /, %, +, -, ;, ) }
```

En:

```text
elemento -> valor multDiv
```

despues de `valor` aparece `multDiv`.

Como:

```text
PRIMERO(multDiv) = { *, /, %, epsilon }
```

se agregan:

```text
*
/
%
```

Como `multDiv` puede producir `epsilon`, tambien se agrega el conjunto SIGUIENTE de `elemento`.

## SIGUIENTE(operacion)

```text
SIGUIENTE(operacion) = { ( }
```

La regla es:

```text
valor -> operacion ( expr )
```

Despues de `operacion` siempre aparece `(`.

## Resumen

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