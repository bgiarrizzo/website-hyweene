---
id: 5
title: Boucles
summary: "Les boucles vous permettent de répéter un bloc de code un nombre spécifique de fois ou tant qu'une condition est vraie."
tags: swift, swift playground, xcode, boucles, for, while, repeat, loop control, break, continue, boucles infinies, étiquettes, labels, sortir de boucles, ignorer des éléments

prism_needed: true

publish_date: 2024-11-21T22:15:00+01:00
---

## Boucles For

Les boucles `for` sont utilisées pour répéter un bloc de code un nombre spécifique de fois. Par exemple, je veux coder un système de timer pomodoro qui me permet de travailler pendant 15 minutes, puis une pause de 5 minutes, le tout répété 4 fois.

Je peux le coder de la sorte :

```swift
let nombreDeSessions = 1...4

for sessionId in nombreDeSessions {
    print("Session \(sessionId) 15 minutes ...")
    print("Pause de 5 minutes ...")
}
```

Bon, ok, c'est très rudimentaire ! Mais le principe est là !

Maintenant, admettons que nous avons une liste de films, on va reprendre notre liste de films du chapitre précédent :

```swift
let films: [String] = [
    "La Menace Fantôme", 
    "L'Attaque des Clones", 
    "La Revanche des Sith", 
    "Un Nouvel Espoir", 
    "L'Empire Contre-Attaque", 
    "Le Retour du Jedi"
]
```

Je veux afficher chaque film de la liste, je peux le faire de la sorte :

```swift
for film in films {
    print(film)
}
```

Et si on n'a pas besoin de la valeur de l'élément, on peut utiliser un underscore `_` :

```swift
let nombreDeSessions = 1...4

for _ in nombreDeSessions {
    print("Session 15 minutes ...")
    print("Pause de 5 minutes ...")
}
```

## Boucles While

Les boucles `while` sont utilisées pour répéter un bloc de code tant qu'une condition est vraie. Par exemple, je veux afficher les nombres de 1 à 5 :

```swift
var nombre = 1

while nombre <= 5 {
    print(nombre)
    nombre += 1
}
```

## Boucles Repeat

Les boucles `repeat` ont le même effet que les boucles `do { ... } while` du C par exemple.

```swift
var nombre = 1

repeat {
    print(nombre)
    nombre += 1
} while nombre <= 5
```

Elle ressemble également au `while`, mais la différence est que le code à l'intérieur de la boucle `repeat` est exécuté au moins une fois avant que la condition ne soit testée.

Du coup, on pourrait se retrouver avec un code comme celui-ci :

```swift
repeat {
    print("ca marche !")
} while false
```

Et ce code affichera `"ca marche !"` une fois.

Tandis que le code suivant ne marchera pas:

```swift
while false {
    print("ca marche !")
}
```

Parce que la condition est fausse dès le départ.

## Sortir d'une boucle

Pour sortir d'une boucle, on peut utiliser l'instruction `break`. Par exemple, je veux afficher les nombres de 1 à 5, mais je veux sortir de la boucle si le nombre est égal à 3 :

```swift
var nombre = 1

while nombre <= 5 {
    print(nombre)
    if nombre == 3 {
        break
    }
    nombre += 1
}
```

## Sortir de plusieurs boucles

Pour sortir de plusieurs boucles imbriquées, on peut utiliser des étiquettes (`label`). Par exemple, je parcours la liste des pokémons, triés par générations, et je veux tout arrêter si je trouve le pokémon que je cherche :

```swift
let generations: [String] = ["gen1", "gen2", "gen3"]
let pokemons: [String] = ["pokemon1", "pokemon2", "pokemon3"]

generationLoop: for generation in generations {
    for pokemon in pokemons {
        if pokemon == "pokemon2" {
            print("Trouvé !")
            break generationLoop
        }
    }
}
```

Sans l'étiquette, le `break` ne sortirait que de la boucle interne. Avec celle-ci, on sort également de la boucle externe.

## Ignorer des éléments

Pour ignorer un élément et passer au suivant, on peut utiliser `continue`. Exemple, je veux une pizza, mais je ne veux pas de champignons :

```swift
let ingredients: [String] = ["tomate", "fromage", "champignons", "jambon"]

for ingredient in ingredients {
    if ingredient == "champignons" {
        continue
    }
    print("Ajout de \(ingredient) ...")
}
```

## Les boucles infinies

Une boucle infinie peut être très utile dans certaines situations. Exemple, on lance une boucle, et on attend qu'un événement se produise et remplisse une condition, qui permettra de sortir de la boucle.

Le classique `while true` :

```swift
while true {
    print("Je suis une boucle (presque) infinie !")
    if condition {
        break
    }
}
```

Cet exemple est simpliste, mais on peut imaginer un capteur qui envoie un event, un user qui appuie sur un bouton, etc.
