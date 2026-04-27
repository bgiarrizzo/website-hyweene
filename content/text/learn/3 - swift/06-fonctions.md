---
id: 6
title: Fonctions
summary: "Les fonctions permettent de réutiliser du code en le regroupant dans une fonction. Cela permet de rendre le code plus lisible et plus facile à maintenir."
tags: swift, swift playground, xcode, fonctions, paramètres, valeurs de retour, étiquettes de paramètres, paramètres par défaut, paramètres variables, erreurs, paramètres inout, inout, throws, try, catch, do

prism_needed: true

publish_date: 2024-11-21T22:45:00+01:00
---

## Ecrire des fonctions

Les fonctions sont des blocs de code qui effectuent une tâche spécifique. Vous pouvez appeler une fonction pour exécuter le code qu'elle contient. Voici un exemple de fonction simple qui imprime un message :

```swift
func disBonjour() {
    print("Bonjour !")
}
```

Pour appeler la fonction, utilisez son nom suivi de parenthèses :

```swift
disBonjour() // Affiche "Bonjour !"
```

## Fonctions avec paramètres

Afin de personnaliser le comportement d'une fonction, on peut lui passer des parametres, voici un exemple :

```swift
func disBonsoir(prenom: String) {
    print("Bonsoir, \(prenom) !")
}
```

A l'execution cela donnera :

```swift
disBonsoir(prenom: "Kevin") // Affiche "Bonsoir, Kevin !"
```

(Et une petite ref années 90s, ca fait pas de mal :-D )

## Retourner des valeurs

Les fonctions peuvent retourner des valeurs, pratique si on veut faire un calcul par exemple :

```swift
func calculCarre(nombre: Int) -> Int {
    return nombre * nombre
}
```

Pour utiliser la valeur retournée, on peut l'assigner à une variable :

```swift
let carre = calculCarre(nombre: 5)

print(carre) // Affiche "25"
```

## Étiquettes de paramètres

Par défaut, les fonctions Swift nécessitent que les paramètres soient nommés lorsqu'ils sont appelés. Cela permet de rendre le code plus lisible.

Prenons une nouvelle fonction :

```swift
func saluer(nom: String) -> String {
    return "Bienvenue, \(nom) !"
}
```

Le parametre de la fonction s'appelle `chez`, et on peut utiliser `chez` pour utiliser sa valeur à l'interieur de la fonction.

Mais on peut également renommer le parametre à l'interieur de la fonction, ce qui permet de rendre le code plus explicite :

```swift
func saluer(personne nom: String) -> String {
    return "Bienvenue, \(nom) !"
}
```

A l'usage, cela donne :

```swift
let message = saluer(personne: "Jessica")

print(message) // Affiche "Bienvenue, Jessica !"
```

## Omettre les étiquettes de paramètres

Si on ne veut pas utiliser d'étiquettes de paramètres, on peut les omettre en utilisant `_` :

```swift
func saluer(_ nom: String) -> String {
    return "Bienvenue, \(nom) !"
}
```

A l'usage, cela donne :

```swift
let message = saluer("Jessica")

print(message) // Affiche "Bienvenue, Jessica !"
```

## Paramètres par défaut

On peut définir des valeurs par défaut pour les paramètres d'une fonction :

```swift
func saluer(personne nom: String, ignorer: Bool = True) {
    if ignorer {
        print("Bienvenue, \(nom) !")
    }
}
```

On peut l'appeller de deux façons :

```swift
saluer(personne: "Bruno") // N'affiche rien (pas très poli !)
saluer(personne: "Bruno", ignorer: false) // Affiche "Bienvenue, Bruno !" (ha, c'est mieux !)
```

## Fonction à nombre d'arguments variable

On peut définir une fonction qui prend un nombre variable d'arguments en utilisant `...` :

```swift
func addition(_ nombres: Int...) -> Int {
    var total = 0
    for nombre in nombres {
        total += nombre
    }
    return total
}
```

On peut appeller la fonction avec le nombre d'arguments qu'on veut :

```swift
let total = addition(1, 2, 3, 4, 5)

print(total) // Affiche "15"
```

## Fonctions qui retournent des erreurs

Les fonctions peuvent lancer des erreurs en utilisant le mot-clé `throws`. Voici un exemple de fonction qui lance une erreur si on lui passe un nombre négatif :

```swift
enum Erreur: Error {
    case nombreNegatif
}

func verifierNombre(_ nombre: Int) throws {
    if nombre < 0 {
        throw Erreur.nombreNegatif
    }
}
```

De la même façon qu'en Python où on va faire un `try`pour executer la fonction et un `except` pour gérer l'erreur, si erreur il y a, en Swift on va utiliser `do` et `catch` :

```swift
do {
    try verifierNombre(-1)
    print("Nombre valide")
} catch {
    print("Erreur : \(error)")
}
```

## Fonctions avec des paramètres inout

Les paramètres d'une fonction sont constants par défaut, ce qui signifie qu'on ne peut pas les modifier à l'intérieur de la fonction. Pour modifier un paramètre, on peut utiliser le mot-clé `inout` :

```swift
func passerAuCarre(_ nombre: inout Int) {
    nombre *= nombre
}
```

Ici, on veut modifier la valeur de `nombre` directement à l'interieur de la fonction. Pour cela, on doit passer la variable avec `&` :

```swift
var nombre = 5
passerAuCarre(&nombre)

print(nombre) // Affiche "25"
```
