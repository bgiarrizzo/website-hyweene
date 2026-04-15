---
id: 4
title: Opérateurs et Conditions
summary: Dans ce module, j'explore les opérateurs et les structures de contrôle de flux en Python, notamment les instructions conditionnelles et les boucles. Ces concepts sont essentiels pour créer des programmes logiques et interactifs.
tags: python, opérateurs, conditions, boucles, structures de contrôle

prism_needed: true

publish_date: 2025-07-28T18:30:00+01:00
---

## Opérateurs Arithmétiques

Les opérateurs arithmétiques en Python vous permettent de réaliser des calculs mathématiques de base. Voici les principaux :

- Addition `+`

```python
a = 5
b = 3
c = a + b
print(c)  # Affiche 8
```

- Soustraction `-`

```python
c = a - b
print(c)  # Affiche 2
```

- Multiplication `*`

```python
c = a * b
print(c)  # Affiche 15
```

- Division `/`

```python
c = a / b
print(c)  # Affiche 1.6666666666666667
```

- Division entière `//`

```python
c = a // b
print(c)  # Affiche 1
```

- Modulo `%` : le reste de la division

```python
c = a % b # 5 divisé par 3 donne 1 avec un reste de 2
print(c)  # Affiche 2
```

Le résultat est 2, car 5 divisé par 3 donne 1 avec un reste de 2.

- Exponentiation `**` : élévation à la puissance

```python
c = a ** b # 5 * 5 = 25 * 5 = 125
print(c)  # Affiche 125
```

## Assignation composée

Comme avec Swift, par exemple, quand on veut faire une addition et assigner le résultat à une variable, on peut utiliser une syntaxe plus concise :

```python
a = 5
a += 5  # a = 10
print(a)  # Affiche 10
```

Ca fonctionne aussi avec d'autres types, par exemple avec une chaîne de caractères :

```python
ma_chaine = "Hello"
ma_chaine += " World"  # ma_chaine = "Hello World"
print(ma_chaine)  # Affiche "Hello World"
```

## Opérateurs de comparaison

Python propose les opérateurs de comparaison suivants :

- Égalité `==`

```python
a = 5
b = 3
c = 5
print(a == b)  # Affiche False
print(a == c)  # Affiche True
```

- Inégalité `!=`

```python
print(a != b)  # Affiche True
print(a != c)  # Affiche False
```

- Supérieur `>`

```python
print(a > b)  # Affiche True
print(a > c)  # Affiche False
```

- Inférieur `<`

```python
print(a < b)  # Affiche False
print(a < c)  # Affiche False
```

- Supérieur ou égal `>=`

```python
print(a >= b)  # Affiche True
print(a >= c)  # Affiche True
```

- Inférieur ou égal `<=`

```python
print(a <= b)  # Affiche False
print(a <= c)  # Affiche True
```

Ces opérateurs peuvent être utilisés également sur des chaînes de caractères :

```python
ma_chaine1 = "abc"
ma_chaine2 = "def"
print(ma_chaine1 == ma_chaine2)  # Affiche False
print(ma_chaine1 != ma_chaine2)  # Affiche True
print(ma_chaine1 < ma_chaine2)  # Affiche True (abc est avant def dans l'ordre alphabétique)
print(ma_chaine1 > ma_chaine2)  # Affiche False
print(ma_chaine1 <= ma_chaine2)  # Affiche True
print(ma_chaine1 >= ma_chaine2)  # Affiche False
```

Parce que Python, comme swift, compare les chaînes de caractères en fonction de leur ordre alphabétique.

## Conditions

Les conditions en Python sont utilisées pour exécuter du code en fonction de certaines conditions. Les structures de base de condition sont les suivantes :

- `if`

```python
if condition:
    # Code à exécuter si la condition est vraie
```

Exemple : 

```python
a = 5
b = 3
if a > b:
    print("a est supérieur à b")  # Affiche "a est supérieur à b"
```

- `else`

```python
if condition:
    # Code à exécuter si la condition est vraie
else:
    # Code à exécuter si la condition est fausse
```

- `elif` (else if)

```python
if condition1:
    # Code à exécuter si condition1 est vraie
elif condition2:
    # Code à exécuter si condition2 est vraie
else:
    # Code à exécuter si aucune des conditions n'est vraie
```

## Combinaison de conditions

On peut combiner plusieurs conditions en utilisant les opérateurs logiques `and`, `or` et `not`, entre autres.

- `and` : Les deux conditions doivent être vraies

```python
if a > b and a > c:
    print("a est le plus grand")
```

- `or` : Au moins une des conditions doit être vraie

```python
if a > b or a > c:
    print("a est supérieur à b ou c")
```

- `not` : Inverse la condition

```python
if not a < b:
    print("a n'est pas inférieur à b")
```

- `in` : Vérifie si une valeur est dans une séquence (comme une liste ou une chaîne de caractères)

```python
ma_liste = [1, 2, 3, 4, 5]
if 3 in ma_liste:
    print("3 est dans la liste")  # Affiche "3 est dans la liste"
```

## L'opérateur ternaire

L'opérateur ternaire est un opérateur qui fonctionne en trois parties. Il est souvent utilisé pour affecter une valeur en fonction d'une condition.

```python
a = 5
b = 3
c = "a est supérieur à b" if a > b else "a est inférieur ou égal à b"
print(c)  # Affiche "a est supérieur à b"
```

Ce qu'on peut traduire par :

```python
if a > b:
    c = "a est supérieur à b"
else:
    c = "a est inférieur ou égal à b"
```

## Instructions `match`

L'instruction `match` permet de faire des correspondances de motifs, similaire à l'instruction `switch` dans d'autres langages. Elle est utile pour comparer une variable à plusieurs valeurs.

```python
fruit = "pomme"
match fruit:
    case "banane":
        print("C'est une banane")
    case "fraise":
        print("C'est une fraise")
    case "pomme":
        print("C'est une pomme")
    case _:
        print("Je ne sais pas quel fruit c'est")
# Affiche : C'est une pomme
```
