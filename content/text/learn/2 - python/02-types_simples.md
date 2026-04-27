---
id: 2
title: Types simples
summary: Python, propose plusieurs types de données simples, chacun ayant ses propres caractéristiques et utilisations. Dans ce module, j'explore les types de données les plus courants en Python, notamment les entiers, les flottants, les chaînes de caractères et les booléens.
tags: python, types, types simples, variables, constantes, entiers, floats, doubles, booléens, strings, interpolation, multi-line strings

prism_needed: true

publish_date: 2025-07-28T09:30:00+01:00
---

## Variables

Avec Python, pour créer une nouvelle variable, il suffit d'assigner une valeur à un nom de variable.

```python
chaine = "Bonjour !"
```

Ceci crée une variable nommée `chaine` qui contient la valeur `Bonjour !`.

Python est un langage dynamiquement typé, ce qui signifie que le type de la variable est déterminé au moment de l'exécution. On peut vérifier le type d'une variable en utilisant la fonction `type()`.

```python
print(type(chaine))  # <class 'str'>
```

Cependant, il est possible de spécifier le type de la variable en utilisant des annotations de type.

```python
chaine: str = "Bonjour !"
```

Pour mettre à jour cette variable, il suffit de réassigner une nouvelle valeur.

```python
chaine = "Au revoir !"
```

## Constantes

En Python, il n'y a pas de mot clé spécifique pour déclarer une constante. Cependant, par convention, on utilise des noms de variables en majuscules pour indiquer qu'une variable ne doit pas être modifiée.

```python
PI = 3.14159
```

Si vous essayez de modifier cette variable, il n'y aura pas d'erreur, mais cela va à l'encontre des conventions de codage.

## Entiers, Flottants et Booléens

Python propose plusieurs types de données simples pour les entiers, les flottants et les booléens.

### Les entiers

Les entiers sont des nombres entiers, positifs ou négatifs. En Python, il n'y a pas de limite stricte à la taille des entiers, ils peuvent être aussi grands que la mémoire le permet.

```python
a = 42
b = -7
```

### Les flottants

Les flottants sont des nombres à virgule flottante, utilisés pour représenter des nombres réels.

```python
pi = 3.14159
e = 2.71828
poids_en_kilos = 65.5
```

### Les booléens

Les booléens sont des valeurs qui peuvent être soit `True` soit `False`. Ils sont souvent utilisés pour les conditions et les comparaisons.

```python
est_actif = True
est_admin = False
```

## Chaînes de caractères

Les chaînes de caractères (ou strings) sont utilisées pour représenter du texte. 

### Chaines simples

En Python, on peut créer une chaîne de caractères en utilisant des guillemets simples ou doubles.

```python
chaine = "Bonjour !"
chaine2 = 'Au revoir !'
```

### Chaines multi-lignes

On peut également créer des chaînes de caractères multi-lignes en utilisant trois guillemets simples ou doubles.

```python
chaine_multi_lignes = """Ceci est une chaîne
de caractères
multi-lignes."""
```

### Interpolation de chaînes

Plusieurs méthodes s'offrent à nous pour interpoler des variables dans une chaîne de caractères.

#### F-strings

On peut utiliser des f-strings (format strings) pour interpoler des variables dans une chaîne de caractères.

```python
nom = "Alice"
age = 30
chaine = f"Bonjour, je m'appelle {nom} et j'ai {age} ans."
# Bonjour, je m'appelle Alice et j'ai 30 ans.
```

#### .format()

On peut également utiliser la méthode `format()` pour interpoler des variables dans une chaîne de caractères.

```python
chaine = "Bonjour, je m'appelle {} et j'ai {} ans.".format(nom, age)
# Bonjour, je m'appelle Alice et j'ai 30 ans.
```

#### Opérateur %

Une autre méthode consiste à utiliser l'opérateur `%` pour formater des chaînes de caractères.

```python
chaine = "Bonjour, je m'appelle %s et j'ai %d ans." % (nom, age)
# Bonjour, je m'appelle Alice et j'ai 30 ans. 
```

Cette méthode est moins courante et moins recommandée, mais elle est encore utilisée dans certains cas.
