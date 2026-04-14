---
id: 7
title: Closures
summary: "Les closures sont des blocs de code qui peuvent être stockés et passés autour de votre code, puis exécutés ultérieurement. Elles sont similaires aux blocs en Objective-C et aux lambdas en d'autres langages de programmation."
tags: swift, swift playground, xcode, closures

prism_needed: true

publish_date: 2025-05-21T12:45:00+01:00
---

Une closure est un bloc de code qui peut être stocké dans une variable, et executé à l'appel de cette variable.

## Closure basique

Mettons que je veux créer une closure qui affiche "Hello, world!".

```swift
let sayHello = {
    print("Hello, world!")
}
```

Ceci créé une fonction sans nom, mais qui peut être appelée en utilisant la variable `sayHello`.

```swift
sayHello() // Affiche "Hello, world!"
```

## Closure avec paramètres

Les closures peuvent accepter des paramètres, tout comme les fonctions.

```swift
let salut = { (nom: String) in
    print("Salut, \(nom)!")
}
```

Pour appeler cette closure, vous devez passer un argument.

```swift
salut("Jean") // Affiche "Salut, Jean!"
```

## Closure retournant une valeur

Les closures peuvent aussi retourner des valeurs, pour ceci il faut placer la valeur retournée, dans la closure, en utilisant le mot clé `return`.

Reprenons notre exemple précédent :

```swift
let salut = { (nom: String) in
    print("Salut, \(nom)!")
}
```

Nous allons le modifier un peu :

```swift
let messageDeSalutation = { (nom: String) -> String in
    return "Salut, \(nom)!"
}
```

Maintenant, cette closure retourne une chaîne de caractères.

```swift
let message = messageDeSalutation("Jean")
print(message) // Affiche "Salut, Jean!"
```

## Closure utilisée comme paramètre

Étant donné que les closures peuvent être utilisées comme des strings, des integers, ou tout autre type de données, elles peuvent être passées en tant que paramètres à d'autres fonctions.

Ici, nouvel exemple, je suis en voyage, et je conduis ma voiture.:

```swift
let conduire = {
    print("Je conduis ...")
}
```

On créé une fonction `voyage` qui prend une closure comme paramètre.

```swift
func voyage(action: () -> Void) {
    print("Je démarre !")
    action()
    print("J'arrive !")
}
```

On peut maintenant appeller notre closure `conduire` dans la fonction `voyage`.

```swift

voyage(action: conduire)
// Affiche :
// Je démarre !
// Je conduis ...
// J'arrive !
```

## Syntaxe de fermeture

Le dernier parametre d'une fonction peut être écrit en dehors des parenthèses de la fonction. Cela est particulièrement utile lorsque vous avez une closure comme dernier paramètre.

```swift
voyage() {
    conduire()
}
// Affiche :
// Je démarre !
// Je conduis ...
// J'arrive !
```

Et étant donné que la closure est le dernier paramètre, on peut omettre les parenthèses.

```swift
voyage {
    conduire()
}
// Affiche :
// Je démarre !
// Je conduis ...
// J'arrive !
```

## Utiliser une closure acceptant des paramètres

Nous reprenons notre exemple de voyage, mais cette fois-ci, nous allons passer un paramètre à la closure, pour y indiquer la destination.

On utilisait `() -> Void` pour indiquer que la closure ne prenait pas de paramètres, mais on va maintenant lui indiquer qu'elle prend un paramètre de type `String`, en modifiant la signature de la fonction `voyage` : `(String) -> Void`

```swift
func voyage(action: (String) -> Void) {
    print("Je démarre !")
    action("Disneyland")
    print("J'arrive !")
}
```

Dans cet exemple, on utilise un parametre de type `String` mais on pourrait utiliser n'importe quel type de données.

Maintenant, quand on appelle la fonction `voyage`, on doit lui passer une closure qui prend un paramètre de type `String`.

```swift
voyage { (destination: String) in
    print("Je vais à \(destination) !")
}
// Affiche :
// Je démarre !
// Je vais à Disneyland !
// J'arrive !
```

## Utiliser une closure retournant une valeur

Jusqu'ici nous avons vu des closures qui ne retournent pas de valeur, mais nous pouvons aussi créer des closures qui retournent une valeur.

En gros, on passe de `(String) -> Void` à `(String) -> String`.

```swift
func voyage(action: (String) -> String) {
    print("Je démarre !")
    // J'appelle la closure et je stock le résultat dans une variable
    let destination = action("Disneyland")
    // J'affiche le résultat
    print(destination)
    print("J'arrive !")
}
```

Maintenant, quand on appelle la fonction `voyage`, on doit lui passer une closure qui prend un paramètre de type `String` et retourne une valeur de type `String`.

```swift
voyage { (destination: String) -> String in
    return "Je vais à \(destination) !"
}
```

## Noms de paramètres abrégés ou Noms d'arguments raccourcis

Swift permet d'utiliser des noms de paramètres abrégés pour les closures. Par défaut, Swift fournit des noms d'arguments raccourcis pour les closures, ce qui vous permet d'accéder aux paramètres sans avoir à les nommer explicitement.

Dans l'exemple précédent, on a notre fonction `voyage` qui accepte une closure en tant que paramètre, qui lui même est une closure qui accepte un paramètre (mindfuck) qui retourne une valeur.

Petit rappel du code : 

```swift
func voyage(action: (String) -> String) {
    print("Je démarre !")
    let destination = action("Disneyland")
    print(destination)
    print("J'arrive !")
}
```

Et on l'appelle comme ceci :

```swift
voyage { (destination: String) -> String in
    return "Je vais à \(destination) !"
}
```

Par chance, swift SAIT que le paramètre d'entrée de la closure est de type `String`, donc on peut omettre le type de paramètre et le nom du paramètre.

```swift
voyage { destination -> String in
    return "Je vais à \(destination) !"
}
```

On peut même faire encore plus concis, en omettant le type de retour de la closure, car Swift SAIT le déduire automatiquement (c'est beau !).

```swift
voyage { destination in
    return "Je vais à \(destination) !"
}
```

On peut même aller plus loin, en retirant le mot clé `return`, car Swift SAIT que c'est la dernière instruction de la closure.

```swift
voyage { destination in
    "Je vais à \(destination) !"
}
```

Et c'est pas encore fini ! On peut même éviter d'utiliser le nom de la closure, en utilisant `$0`, qui représente le premier paramètre de la closure.

```swift
voyage {
    "Je vais à \($0) !"
}
```

## Closures avec plusieurs paramètres

Les closures peuvent accepter plusieurs paramètres, tout comme les fonctions.

En améliorant un peu notre exemple de voyage, on va créer une closure qui accepte deux paramètres : la destination et le moyen de transport.

```swift
func voyage(action: (String, String) -> String) {
    print("Je démarre !")
    let destination = action("Disneyland", "voiture")
    print(destination)
    print("J'arrive !")
}
```

Ici, la closure accepte deux paramètres : un pour la destination et un pour le moyen de transport.
On peut l'appeler comme ceci :

```swift
voyage { destination, moyenDeTransport in
    "Je vais à \(destination) en \(moyenDeTransport) !"
}
```

Ou en utilisant les noms de paramètres abrégés :

```swift
voyage {
    "Je vais à \($0) en \($1) !"
}
```

## Retourner des closures depuis une fonction

On a vu qu'on pouvait passer des closures en tant que paramètres à une fonction, mais on peut aussi retourner des closures depuis une fonction.

Ici, on va créer une fonction qui retourne une closure.

```swift
func voyage() -> (String) -> Void {
    return {
        print("Je vais à \($0) !")
    }
}
````

Ici la fonction `voyage` retourne une closure qui prend un paramètre de type `String` et ne retourne rien.

La syntaxe est déroutante, on a un double retour `-> (String) -> Void` qui indique que la fonction retourne une closure qui prend un paramètre de type `String` et ne retourne rien.

On peut l'utiliser comme ceci :

```swift
let go_to = voyage()
go_to("Disneyland") // Affiche "Je vais à Disneyland !"
```

Ou en utilisant les noms de paramètres abrégés, sans utiliser de variable intermédiaire :

```swift
voyage()("Disneyland") // Affiche "Je vais à Disneyland !"
```

C'est plus concis, mais moins lisible.

## Capturer des valeurs

En utilisant des variables dans une closure, Swift peut les capturer, les stocker pour pouvoir les utiliser plus tard.

Pour l'instant, on a la fonction `voyage` qui ne fait que retourner une closure, et cette closure n'accepte qu'un parametre, et ne retourne rien, mais on va l'améliorer un peu.

J'ai rajouté un compteur de voyage, qui va compter le nombre de voyages effectués.

```swift
func voyage() -> (String) -> Void {
    var compteur = 1
    return {
        print("Je vais à \($0), \(compteur) fois !")
        compteur += 1
    }
}
```

Ici, la closure capture la variable `compteur`, et l'incrémente à chaque fois qu'on l'appelle.

On peut l'utiliser comme ceci :

```swift
let go_to = voyage()
go_to("Disneyland") // Affiche "Je vais à Disneyland, 1 fois !"
go_to("Disneyland") // Affiche "Je vais à Disneyland, 2 fois !"
go_to("Disneyland") // Affiche "Je vais à Disneyland, 3 fois !"
go_to("Disneyland") // Affiche "Je vais à Disneyland, 4 fois !"
```

