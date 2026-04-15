---
id: 2
title: Types simples
summary: "Swift propose des types simples tels que les entiers, les chaînes de caractères, les doubles et les booléens, qui sont fondamentaux pour la manipulation des données. Le langage privilégie la sécurité des types en encourageant l'utilisation de constantes avec 'let' et permet des annotations de type pour une meilleure clarté. De plus, des fonctionnalités comme l'interpolation de chaînes et les chaînes multi-lignes simplifient la gestion du texte."
tags: swift, types, types simples, variables, constantes, entiers, floats, doubles, booléens, strings, interpolation, multi-line strings, swift playground, xcode

prism_needed: true

publish_date: 2024-11-08T19:00:00+01:00
update_date: 2024-11-11T22:30:00+01:00
---

## Variables

Avec swift, pour créer une nouvelle variable, il faut utiliser le mot clé `var` suivi du nom de la variable.

```swift
var chaine = "Bonjour !"
```

Ceci créer une variable nommée `chaine` qui contient la valeur `Bonjour !`.

Swift est un langage fortement typé, ce qui signifie que chaque variable doit avoir un type. Dans l'exemple ci-dessus, le type de la variable est inféré par le compilateur. Cependant, il est possible de spécifier le type de la variable de manière plus explicite, en utilisant une annotation de type.

```swift
var chaine: String = "Bonjour !"
```

Pour mettre à jour cette variable, il suffit pour ceci de réassigner une nouvelle valeur.

```swift
chaine = "Au revoir !"
```

Le mot clé `var` est ici inutile, puisqu'il sert à créer la variable, il n'est pas nécessaire pour la mettre à jour.

## Constantes

On a vu, dans les exemples précédents, que pour créer une variable, on utilise le mot clé `var`. Pour créer une constante, on utilise le mot clé `let`.

```swift
let chaineQuiNeChangeraPas = "1,2,3 ... Soleil !"
```

Si vous voulez mettre à jour cette constante, le compilateur renverra une erreur. C'est une forme de sécurité, une fois qu'une constante est créée, elle ne peut être modifiée.

## Entiers, Floats, Doubles et booléens

Swift propose plusieurs types de données simples pour les entiers, les doubles et les booléens.

### Les entiers (Integers)

Les entiers sont des nombres entiers positifs ou négatifs. Swift propose plusieurs types d'entiers :

| Type       | Description              | Intervalle                          |
| ---------- | ------------------------ | ----------------------------------- |
| Int8       | Entier signé sur 8 bits  | -128 à 127                          |
| Int16      | Entier signé sur 16 bits | -2^15 à 2^15-1                      |
| Int32      | Entier signé sur 32 bits | -2^31 à 2^31-1                      |
| Int64      | Entier signé sur 64 bits | -2^63 à 2^63-1                      |
| UInt       | Entier non signé         | 0 à 2^32 (32-bit) 0 à 2^64 (64-bit) |

```swift
let taille: Int = 170
```

Parfois, on peut manipuler de grands nombres, et il peut être difficile de les lire, swift nous propose une syntaxe pour nous simplifer la lecture :

```swift
let populationDeLaTerre: Int = 8_500_000_000
```

### Les nombres à virgule flottante (Floats and Doubles)

Les nombres à virgule flottante peuvent être représentés par deux types de données :

| Type       | Description                            |
| ---------- | -------------------------------------- |
| Float      | Nombre à virgule flottante sur 32 bits |
| Double     | Nombre à virgule flottante sur 64 bits |

#### Floats

Les floats sont codés sur 32 bits et représente 6 à 8 décimales.

```swift
let poids: Float = 75.55
```

#### Doubles

Les doubles sont codés sur 64 bits et représentent 15 à 17 décimales.

```swift
let constanteGravitationnelle: Double = 6.67430e-11
```

### Booléens

Les booléens sont des valeurs binaires qui peuvent être `true` ou `false`.

```swift
let estMajeur: Bool = true
```

## Strings et Multi-line strings

Les chaînes de caractères sont des séquences de caractères. Swift propose plusieurs fonctionnalités pour les manipuler.

### Strings

Les chaînes de caractères peuvent être créées en utilisant des guillemets doubles.

```swift
let prenom: String = "Jean"
```

### Multi-line strings

Comme en Python, les chaînes de caractères multi-lignes peuvent être créées en utilisant trois guillemets doubles.

```swift
let declarationDesDroitsDeLHomme: String = """
Article Premier
Les hommes naissent et demeurent libres et égaux en droits.
Les distinctions sociales ne peuvent être fondées que sur l'utilité commune.
"""
```

## String interpolation

Il peut être utile de combiner une chaine de caractères fixe avec une variable. On peut procéder de cette façon :

```swift
let prenom: String = "Jean"
let age: Int = 25
let message: String = "Bonjour, je m'appelle \(prenom) et j'ai \(age) ans."
```

Dans cet exemple, `prenom` et `age` sont insérés dans la chaîne de caractères `message` en utilisant la syntaxe `\(variable)`, ce qui donnera comme résultat :

```swift
"Bonjour, je m'appelle Jean et j'ai 25 ans."
```
