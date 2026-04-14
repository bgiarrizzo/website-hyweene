---
id: 6
title: Fonctions
summary: Les fonctions sont des blocs de code réutilisables qui permettent d'organiser et de simplifier le code. Elles peuvent prendre des paramètres et retourner des valeurs.
tags: python, fonctions, programmation

prism_needed: true

publish_date: 2025-07-31T15:30:00+01:00
---

## Ecrire une fonction

Ecrire une fonction est une façon de recycler du code, pour effectuer une tâche spécifique. Un exemple simple de fonction qui affiche un message :

```python
def dire_bonjour():
    print("Bonjour !")
```

Une fonction se définit avec le mot-clé `def`, suivi du nom de la fonction et de parenthèses. Le code à exécuter est indenté sous la définition de la fonction.

Pour appeler la fonction, utilisez son nom suivi de parenthèses :

```python
dire_bonjour()  # Affiche "Bonjour !"
```

## Différents types de fonctions

On peut distinguer plusieurs types de fonctions :

- Fonctions qui retournent des valeurs
- Fonctions qui ne retournent pas de valeurs (aussi appelées procédures)

### Fonctions qui retournent des valeurs

Les fonctions peuvent retourner des valeurs, ce qui est utile pour effectuer des calculs ou manipuler des données. Voici un exemple :

```python
def calculer_carre(nombre):
    return nombre * nombre

carre = calculer_carre(5)
print(carre)  # Affiche "25"
```

### Fonctions qui ne retournent pas de valeurs

Les fonctions qui ne retournent pas de valeurs effectuent une action mais ne renvoient pas de résultat. Voici un exemple :

```python
def afficher_message():
    print("Ceci est un message.")

afficher_message()  # Affiche "Ceci est un message."
```

## Sous-catégories des fonctions

Ces fonctions peuvent se subdiviser en sous catégories :

- Fonctions sans paramètres
- Fonctions avec paramètres
- Fonctions avec paramètres par défaut
- Fonctions avec paramètres variables
- Fonctions avec paramètres nommés

### Fonctions sans paramètres

Les fonctions sans paramètres ne prennent pas d'arguments lors de leur appel. Elles sont utiles lorsque vous souhaitez encapsuler un comportement qui ne dépend pas des données d'entrée. Voici un exemple :

```python
def afficher_message():
    print("Ceci est un message.")

afficher_message()  # Affiche "Ceci est un message."
```

### Fonctions avec paramètres

Les fonctions avec paramètres permettent de passer des valeurs à la fonction pour qu'elle puisse les utiliser. Voici un exemple :

```python
def dis_bonsoir(prenom: str):
    print(f"Bonsoir, {prenom} !")

dis_bonsoir("Kevin")  # Affiche "Bonsoir, Kevin !"
```

(Et une petite ref années 90s, ca fait pas de mal :-D )

### Fonctions avec paramètres par défaut

Les fonctions peuvent avoir des paramètres avec des valeurs par défaut. Cela permet de les appeler sans fournir tous les arguments. Voici un exemple :

```python
def saluer(prenom: str = "Inconnu"):
    print(f"Bonjour, {prenom} !")

saluer()  # Affiche "Bonjour, Inconnu !"
saluer("Alice")  # Affiche "Bonjour, Alice !"
```

### Fonctions avec paramètres variables

Les fonctions avec paramètres variables permettent de passer un nombre variable d'arguments. Cela est utile lorsque vous ne savez pas à l'avance combien d'arguments seront passés. Voici un exemple :

```python
def afficher_nombres(*nombres: int):
    for nombre in nombres:
        print(nombre)

afficher_nombres(1, 2, 3)  # Affiche 1, 2, 3
afficher_nombres(4, 5, 6, 7, 8)  # Affiche 4, 5, 6, 7, 8
```

### Fonctions avec paramètres nommés

Les fonctions avec paramètres nommés permettent de spécifier les arguments par leur nom lors de l'appel. Cela rend le code plus lisible et permet de passer les arguments dans n'importe quel ordre. Voici un exemple :

```python
def saluer(nom: str, age: int):
    print(f"Bonjour, {nom} ! Tu as {age} ans.")
    
saluer(nom="Alice", age=30)  # Affiche "Bonjour, Alice ! Tu as 30 ans."
saluer(age=25, nom="Bob")  # Affiche "Bonjour, Bob ! Tu as 25 ans."
```

## Variables

Lorsqu’une fonction est appelée, Python réserve pour elle (dans la mémoire de l’ordinateur) un espace de noms.

Ces variables peuvent être globales ou locales.

### Variables locales

Ces variables sont définies à l'interieur d'une fonction et ne peuvent être accessibles qu'à l'interieur de celles ci.

Voici un exemple :

```python
def ma_fonction():
    variable_locale: str = "Je suis locale"
    print(variable_locale)

ma_fonction()  # Affiche "Je suis locale"
```

### Variables globales

Ces variables sont définies en dehors de toute fonction et peuvent être accessibles de n'importe où dans le code. Voici un exemple :

```python
variable_globale: str = "Je suis globale"

def ma_fonction():
    print(variable_globale)

ma_fonction()  # Affiche "Je suis globale"
```

On peut aussi modifier une variable globale à l'intérieur d'une fonction en utilisant le mot-clé `global` :

```python
variable_globale: str = "Je suis globale"

def ma_fonction():
    global variable_globale
    variable_globale = "Je suis une variable globale modifiée"
    print(variable_globale)

ma_fonction()  # Affiche "Je suis une variable globale modifiée"
print(variable_globale)  # Affiche "Je suis une variable globale modifiée"
```
