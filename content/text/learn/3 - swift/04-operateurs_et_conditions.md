---
id: 4
title: Opérateurs et conditions
summary: "Les opérateurs vous permettent de manipuler des données et de prendre des décisions dans votre code."
tags: swift, opérateurs, conditions, if, else, switch, range, comparaison, arithmétique, assignation, ternaire, booléens, switch, opérateurs de plages, swift playground, xcode

prism_needed: true

publish_date: 2024-11-20T18:15:00+01:00
---

## Opérateurs Arithmetiques

Comme dans tous les langages de programmation, on a besoin de faire des calculs. Swift propose les opérateurs arithmétiques suivants :

- Addition `+`

```swift
let a = 5
let b = 3
var c = a + b // c = 8
```

- Soustraction `-`

```swift
var c = a - b // c = 2
```

- Multiplication `*`

```swift
var c = a * b // c = 15
```

- Division `/`

```swift
var c = a / b // c = 1
```

- Modulo `%` : le reste de la division

```swift
var c = a % b // c = 2
```

Le résultat est 2, parce que 5 divisé par 3 donne 1 avec un reste de 2.

## Assignation composée

Swift donne une syntaxe plus rapide pour les opérations d'assignation. Exemple, on veut ajouter 5 à une variable `a` :

```swift
var a = 5
a += 5 // a = 10
```

Cela fonctionne avec d'autres types, exemple avec une string :

```swift
var maChaine = "Hello"
maChaine += " World" // maChaine = "Hello World"
```

## Opérateurs de comparaison

Swift propose les opérateurs de comparaison suivants :

- Égalité `==`

```swift
let a = 5
let b = 3
let c = 5

a == b // false
a == c // true
```

- Différence `!=`

```swift
a != b // true
a != c // false
```

- Supérieur `>`

```swift
a > b // true
a > c // false
```

- Inférieur `<`

```swift
a < b // false
a < c // false
```

- Supérieur ou égal `>=`

```swift
a >= b // true
a >= c // true
```

- Inférieur ou égal `<=`

```swift
a <= b // false
a <= c // true
```

Ces opérateurs peuvent aussi être utilisés sur des strings :

```swift
let chaine1 = "Hello"
let chaine2 = "World"

chaine1 == chaine2 // false
chaine1 != chaine2 // true
chaine1 < chaine2 // true
chaine1 > chaine2 // false
```

Parce que swift compare les strings en fonction de leur ordre alphabétique.

## Conditions

Les conditions permettent de prendre des décisions dans votre code. Swift propose les conditions suivantes :

- `if`

```swift
let a = 5
let b = 3

if a > b {
    print("a est supérieur à b")
}
```

- `else`

```swift
if a > b {
    print("a est supérieur à b")
} else {
    print("a est inférieur ou égal à b")
}
```

- `else if` : Permet d'enchainer avec une condition supplémentaire.

```swift
if a > b {
    print("a est supérieur à b")
} else if a < b {
    print("a est inférieur à b")
} else {
    print("a est égal à b")
}
```

## Combinaison d'opérateurs

Parfois, on a besoin de combiner plusieurs conditions. Swift propose les opérateurs suivants :

- `&&` : ET

```swift
let workoutIntensityLowLimit: Int = 0
let workoutIntensityHighLimit: Int = 10
var workoutIntensity: Int = 5

if workoutIntensity >= workoutIntensityLowLimit && workoutIntensity <= workoutIntensityHighLimit {
    print("Valeur correcte")
}
```

- `||` : OU

```swift
var workoutIntensity: Int = 15

if workoutIntensity < workoutIntensityLowLimit || workoutIntensity > workoutIntensityHighLimit {
    print("Valeur incorrecte")
}
```

- `!` : NON

```swift
var isFound = true

if !isFound {
    print("Non trouvé")
}
```

## L'opérateur ternaire

L'opérateur ternaire est un opérateur qui fonctionne en trois parties. Il est souvent utilisé pour affecter une valeur en fonction d'une condition.

```swift
let a = 5
let b = 3

let c = a > b ? "a est supérieur à b" : "a est inférieur ou égal à b"
```

Ce qu'on peut traduire par :

```swift
if a > b {
    c = "a est supérieur à b"
} else {
    c = "a est inférieur ou égal à b"
}
```

## Instructions switch

Le `switch` permet d'éviter de chainer de multiples conditions `if/else`. Il est souvent utilisé pour comparer une variable à plusieurs valeurs.

```swift
let fruit = "pomme"

switch fruit {
case "banane":
    print("C'est une banane")
case "fraise":
    print("C'est une fraise")
case "pomme":
    print("C'est une pomme")
default:
    print("Je ne sais pas quel fruit c'est")
}

// Affiche : C'est une pomme
```

## Opérateurs de plage

Swift propose des opérateurs de plage pour créer des intervalles de valeurs.

- `a...b` : Crée un intervalle de valeurs de `a` à `b` inclus.

```swift
for i in 1...5 {
    print(i)
}

// Affiche : 1 2 3 4 5
```

- `a..<b` : Crée un intervalle de valeurs de `a` à `b` exclu.

```swift
for i in 1..<5 {
    print(i)
}

// Affiche : 1 2 3 4
```
