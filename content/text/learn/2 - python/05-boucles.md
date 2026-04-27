---
id: 5
title: Boucles
summary: Dans ce module, j'explore les boucles en Python, notamment les boucles `for` et `while`. Ces structures de contrôle permettent d'exécuter un bloc de code plusieurs fois, facilitant ainsi la répétition d'actions et le traitement de collections de données.
tags: python, boucles, for, while, structures de contrôle

prism_needed: true

publish_date: 2025-07-28T18:30:00+01:00
---

## Boucles For

Les boucles `for` en Python sont utilisées pour répéter un bloc de code un nombre spécifique de fois ou pour itérer sur les éléments d'une collection. Par exemple, je vais reprendre mon exemple de pomodoro utilisé dans le module Swift, si je veux un pomodoro qui me permet de travailler pendant 15 minutes, puis de faire une pause de 5 minutes, le tout répété 4 fois, je peux le coder comme suit :

```python
for session in range(1, 5):
    print(f"Session {session} : 15 minutes ...")
    print("Pause de 5 minutes ...")
```

Maintenant, j'ai une liste de films, je veux afficher chaque film de la liste. Voici comment je peux le faire :

```python
lord_of_the_ring_trilogy = [
    "La Communauté de l'Anneau",
    "Les Deux Tours",
    "Le Retour du Roi"
]
```

Je veux afficher chaque film de la liste :

```python
for film in lord_of_the_ring_trilogy:
    print(film)
```

Si je n'ai pas besoin de la valeur de l'élément, je peux utiliser un underscore `_` :

```python
for _ in range(1, 5):
    print("Session 15 minutes ...")
    print("Pause de 5 minutes ...")
```

## Boucles While

Les boucles `while` en Python permettent d'exécuter un bloc de code tant qu'une condition est vraie. Voici un exemple simple :

```python
compteur = 1
while compteur <= 5:
    print(f"Session {compteur} : 15 minutes ...")
    print("Pause de 5 minutes ...")
    compteur += 1
```

Dans cet exemple, la boucle continue tant que `compteur` est inférieur ou égal à 5. À chaque itération, nous incrémentons `compteur` de 1.

On peut voir aussi que pour cet exemple, la boucle `while` n'est pas la plus adaptée, car on doit gérer manuellement l'incrémentation de `compteur`. Pour des itérations simples sur une séquence, la boucle `for` est généralement plus concise et plus facile à lire.

## Sortir d'une boucle

Pour sortir d'une boucle avant qu'elle ne se termine naturellement, on peut utiliser l'instruction `break`. Par exemple, si je veux arrêter la boucle après 3 sessions :

```python
nombre = 1

while nombre <= 5:
    print(nombre)
    
    if nombre > 3:
        break

    nombre += 1
```

Ce code affichera les nombres de 1 à 3, puis sortira de la boucle.

## Ignorer une itération

Pour ignorer une itération spécifique d'une boucle, on peut utiliser l'instruction `continue`. Par exemple, si je veux afficher les nombres de 1 à 5, mais ignorer les nombres pairs :

```python
for nombre in range(1, 6):

    if nombre % 2 == 0:
        continue
    
    print(nombre)
```

Ce code affichera uniquement les nombres impairs : 1, 3, 5.

## Boucles imbriquées

Il est possible d'imbriquer des boucles pour traiter des structures de données plus complexes. Par exemple, si j'ai une liste de listes et que je veux afficher chaque élément :

```python
matrice = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]

for ligne in matrice:
    for element in ligne:
        print(element)
```

Ce code affichera chaque élément de la matrice, un par un, ligne par ligne.

## Boucles Infinies

La boucle infinie ne se termine jamais, car la condition est toujours vraie. Exemple : 

```python
while True:
    print("Cette boucle ne s'arrêtera jamais !")
```

Pour éviter cela, on peut utiliser `break` pour sortir de la boucle à un moment donné : 

```python
while True:
    reponse = input("Voulez-vous continuer ? (y/n) ")
    if reponse.lower() != "y":
        break
```
