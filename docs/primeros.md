# Conjuntos PRIMEROS

Los conjuntos PRIMEROS indican con que simbolo puede comenzar una produccion.

## PRIMERO(inicio)

```text
PRIMERO(inicio) = { ID, epsilon }
```

Esto se debe a que `inicio` puede comenzar con una linea, y una linea comienza con `ID`.

Tambien puede producir vacio.

## PRIMERO(linea)

```text
PRIMERO(linea) = { ID }
```

La regla es:

```text
linea -> ID = expr ;
```

Por lo tanto siempre comienza con un identificador.

## PRIMERO(expr)

```text
PRIMERO(expr) = { NUM, ID, (, sin, cos, tan, abs }
```

La regla es:

```text
expr -> elemento sumaResta
```

Por lo tanto depende del conjunto PRIMERO de `elemento`.

## PRIMERO(sumaResta)

```text
PRIMERO(sumaResta) = { +, -, epsilon }
```

Segun:

```text
sumaResta -> + elemento sumaResta
           | - elemento sumaResta
           | epsilon
```

## PRIMERO(elemento)

```text
PRIMERO(elemento) = { NUM, ID, (, sin, cos, tan, abs }
```

La regla es:

```text
elemento -> valor multDiv
```

Por lo tanto depende del conjunto PRIMERO de `valor`.

## PRIMERO(multDiv)

```text
PRIMERO(multDiv) = { *, /, %, epsilon }
```

Segun:

```text
multDiv -> * valor multDiv
         | / valor multDiv
         | % valor multDiv
         | epsilon
```

## PRIMERO(valor)

```text
PRIMERO(valor) = { NUM, ID, (, sin, cos, tan, abs }
```

Esto se obtiene de:

```text
valor -> NUM
       | ID
       | ( expr )
       | operacion ( expr )
```

## PRIMERO(operacion)

```text
PRIMERO(operacion) = { sin, cos, tan, abs }
```

Segun:

```text
operacion -> sin
           | cos
           | tan
           | abs
```

## Resumen

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