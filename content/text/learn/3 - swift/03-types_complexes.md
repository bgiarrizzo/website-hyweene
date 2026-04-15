---
id: 3
title: Types complexes
summary: "Swift propose des types complexes tels que les tableaux, les ensembles, les tuples et les dictionnaires pour stocker des données structurées. Ces types sont essentiels pour la manipulation des données et offrent des fonctionnalités avancées pour la gestion des collections."
tags: swift, types, types complexes, arrays, sets, tuples, dictionaries, collections, enums, swift playground, xcode

prism_needed: true

publish_date: 2024-11-20T17:10:00+01:00
---

## Arrays, Sets, Tuples, et Dictionnaires

### Arrays

Les arrays (ou listes) sont des collections de données qui sont stockées sous une seule variable. Les éléments d'un array sont ordonnés et peuvent être accédés par leur index.

Les arrays sont fortement typés avec swift, ce qui veut dire qu'on ne peut mélanger torchons et serviettes. A l'inverse de Python par exemple, si on créé un array, et que le type des éléments qu'il contiendra est de type `Int`, alors on ne pourra pas stocker autre choses que des `Int`.

Par exemple, en python :

```python
maListe = ["bonjour", 1, "au revoir", 5]
```

On voit que la liste contient, indifféremment des strings, des nombres à virgules, des entiers. On pourrait même y stocker un dictionnaire ou voire même, une sous liste.

Alors qu'en swift, les choses sont plus strictes :

```swift
let maListePleineDeNombresEntiers: [Int] = [1, 2, 3, 4]
```

Si on essaye de stocker autre chose qu'un `Int` dans cette liste, on aura une erreur.

### Sets

Les sets sont des collections non ordonnées de données uniques. Cela signifie que chaque élément d'un set est unique et ne peut pas être dupliqué.

Les sets, comme les arrays, sont fortement typés. Donc comme les listes, il n'est pas possible de mélanger les types.

```swift
let monSetPleinDeNombresEntiers: Set<Int> = Set([1, 2, 3, 4])
let monSetPleinDeStrings: Set<String> = Set(["bleu", "rouge", "vert"])
```

Si on essaye d'ajouter une valeur déjà présente dans le set, elle ne sera pas ajoutée.

```swift
let monSetPleinDeStrings: Set<String> = Set(["bleu", "rouge", "vert", "bleu"])
```

Dans cet exemple, le set ne contiendra que `["bleu", "rouge", "vert"]`.

### Tuples

Les tuples sont des collections de valeurs qui peuvent être de différents types. Les tuples sont utilisés pour regrouper des valeurs qui sont liées entre elles.

```swift
let personne = (prenom: "Bruno", pseudo: "Hyweene", age: 36)
```

On peut accéder aux valeurs d'un tuple en utilisant leur index ou leur nom.

```swift
print(personne.0) // Bruno
print(personne.1) // Hyweene
print(personne.2) // 36
```

Il est également possible d'accéder à la valeur en utilisant le nom de la propriété.

```swift
print(personne.prenom) // Bruno
print(personne.pseudo) // Hyweene
print(personne.age) // 36
```

### Différences entre les trois types

Les arrays, les sets et les tuples sont des types de collections en Swift, mais ils ont des caractéristiques différentes.

- Les arrays sont des collections ordonnées d'éléments qui peuvent être dupliqués.
- Les sets sont des collections non ordonnées d'éléments uniques.
- Les tuples sont des collections d'éléments qui peuvent être de différents types et qui sont utilisés pour regrouper des valeurs liées.

## Dictionnaires

Les dictionnaires (ou objets) sont des collections de données qui stockent des paires clé-valeur. Chaque élément d'un dictionnaire est associé à une clé unique qui permet d'accéder à sa valeur.

Les dictionnaires, comme les listes ou sets sont fortement typés, et la encore, on ne peut mélanger les types.

```swift
let taille: [String: Int] = [
    "Hyweene": 174, 
    "Poupinette": 160, 
    "Poupette": 115
]
```

Pour y accéder, comme en python, on utilise la clé :

```swift
print(taille["Hyweene"]) // 174
print(taille["Poupinette"]) // 160
print(taille["Poupette"]) // 115
```

### Valeurs par défaut

Il est possible de définir une valeur par défaut pour un dictionnaire si la clé n'existe pas.

```swift
let fruitPrefere: [String: String] = [
    "Hyweene": "Banane", 
    "Poupinette": "Fraise"
]
```

Ici, nous n'avons pas défini de valeur pour le fruit préféré de Poupette. Si nous essayons d'accéder à cette valeur, nous obtiendrons `nil`.

```swift
print(fruitPrefere["Poupette"]) // nil
```

Pour palier ceci, on peut définir une valeur par défaut.

```swift
print(fruitPrefere["Poupette", default: "Pomme"]) // Pomme
```

## Créer des collections vides

Il est possible de créer des Arrays, Sets ou Dictionnaires vides en utilisant la syntaxe suivante :

```swift
var arrayVideDeStrings = [String]()
var arrayVideDeNombres = Array<Int>()

var setVide = Set<String>()

var dictionnaireVide1 = [String: Int]()
var dictionnaireVide2 = Dictionary<String, Int>()
```

## Enumérations

Les énumérations (ou enums) sont des types de données qui permettent de définir un groupe de valeurs possibles. Les énumérations sont utiles pour définir des types de données qui ont un nombre fini de valeurs possibles.

Par exemple, si on veut représenter deux possibilités :

- Soit le résultat est `succès`
- Soit le résultat est `échec`

On serait tenté de l'écire comme ceci :

```swift
let resultat = "succès"
let resultat2 = "échec"
```

Ce sont deux strings, qui représentent les deux états possibles. Mais on pourrait se tromper en écrivant `fail` au lieu de `échec` par exemple.

Avec une énumération, on pourrait écrire :

```swift
enum Result {
    case success
    case failure
}
```

Et on pourrait l'utiliser comme ceci :

```swift
let resultat: Result = .success
```

Ou alors :

```swift
let resultat: Result.success
```

Ceci évite de se tromper dans les valeurs possibles, et améliore la lisibilité du code.

### Avec valeurs associées

Il est possible d'associer des valeurs à chaque cas d'une énumération.

Si on veut définir une séance d'entrainement, on pourrait écrire :

```swift
enum Workout {
    case running
    case cycling
    case weightlifting
}
```

Alors ok, on court, on roule à vélo, on soulève des poids, mais nous n'avons pas beaucoup plus de détails sur ces entrainements.

C'est la qu'on peut rajouter des valeurs à chaque cas de l'énumération.

```swift
enum Workout {
    case running(distance: Double)
    case cycling(speed: Double)
    case weightlifting(intensity: Int)
}
```

Maintenant, on est plus précis, on sait quelle disance on a couru, à quelle vitesse on a roulé, et on sait l'intensité de notre séance de muscu.

On peut maintenant créer une instance de notre énumération :

```swift
let weightliftIntensity: Workout = .weightlifting(intensity: 5)
```

### Avec valeurs brutes

Parfois, on peut vouloir associer une valeur à chaque cas de l'énum. Exemple, on veut classer les différents films de Star Wars :

```swift
enum StarWars: Int {
    case phantomMenace
    case attackOfTheClones
    case revengeOfTheSith
    case aNewHope
    case theEmpireStrikesBack
    case returnOfTheJedi
}
```

Swift doit attribuer automatiquement des valeurs a chaque cas en partant de 0. Mais on peut attribuer ce que l'on veut :

```swift
enum StarWars: Int {
    case aNewHope = 4
    case theEmpireStrikesBack = 5
    case returnOfTheJedi = 6
    case phantomMenace = 1
    case attackOfTheClones = 2
    case revengeOfTheSith = 3
}
```

Et si on veut récupérer la valeur d'un des films :

```swift
let swep4 = StarWars(rawValue: 4)
```

---

Dans notre énum de base, le premier film est `La Menace Fantôme`, sa valeur brute sera 0, mais on ne dit pas `Star Wars Episode 0: La Menace Fantôme`, donc on lui attribuera la valeur 1.

```swift
enum StarWars: Int {
    case phantomMenace = 1
    case attackOfTheClones
    case revengeOfTheSith
    case aNewHope
    case theEmpireStrikesBack
    case returnOfTheJedi
}
```

Ensuite, swift fera le travail pour nous et attribuera les bonnes valeurs aux autres films en partant de celle attribuée à la menace fantôme.
