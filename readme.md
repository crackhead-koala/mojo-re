# Simple Regular Expression Interpreter in Mojo

## What is This

Inspired by [Russ Cox's series of articles](https://swtch.com/~rsc/regexp/) on regular expressions.

## NFA Diagrams for Basic Blocks of Regular Expressions

### $a$ (Any Literal Character)

```mermaid
stateDiagram
    direction LR

    start: ...
    end: ...

    start --> end: a
```

### $e_ie_j$ (Expression Concatenacion)

```mermaid
stateDiagram
    direction LR

    start: ...
    ei: e<sub><i>i</i></sub>
    ej: e<sub><i>j</i></sub>
    end: ...

    start --> ei
    ei --> ej
    ej --> end
```

### $e_i|e_j$ (Expression Alteration)

```mermaid
stateDiagram
    direction LR

    start: ...
    ei: e<sub><i>i</i></sub>
    ej: e<sub><i>j</i></sub>
    end1: ...
    end2: ...

    start --> ei
    start --> ej
    ei --> end1
    ej --> end2
```

### $e?$ (Repetition Zero or One Time)

```mermaid
stateDiagram
    direction LR

    start: ...
    ei: e<sub><i>i</i></sub>
    end1: ...
    end2: ...

    start --> ei
    ei --> end1
    start --> end2
```

### $e*$ (Repetition Zero or More Times)

```mermaid
stateDiagram
    direction LR

    start: ...
    ei: e<sub><i>i</i></sub>
    end: ...

    start --> ei
    ei --> start
    start --> end
```

### $e+$ (Repetition One or More Times)

```mermaid
stateDiagram
    direction LR

    start: ...
    ei: e<sub><i>i</i></sub>
    end: ...

    start --> ei
    ei --> end
    end --> ei
```
