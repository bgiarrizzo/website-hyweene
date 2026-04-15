---
id: 3
title: Types complexes
summary: Dans ce module, j'explore les types de données complexes en Python, notamment les listes, les tuples, les ensembles et les dictionnaires. Ces types de données permettent de stocker des collections d'éléments et offrent une grande flexibilité pour la manipulation des données.
tags: python, types, types complexes, listes, tuples, ensembles, dictionnaires

prism_needed: true

publish_date: 2025-07-28T09:30:00+01:00
---

## Listes, Sets, Tuples et Dictionnaires

### Listes

Les listes sont des collections ordonnées, ou non, d'éléments qui peuvent être de différents types. Elles sont définies en utilisant des crochets `[]`.

```python
ma_liste = [1, 2, 3, 4, 5]
ma_liste_de_courses = ["pain", "lait", "œufs"]
```

Les listes sont dynamiques, ce qui signifie que vous pouvez ajouter, supprimer ou modifier des éléments après leur création.

```python
ma_liste.append(6)  # Ajoute 6 à la fin de la liste
print(ma_liste)  # [1, 2, 3, 4, 5, 6]

ma_liste[0] = 10  # Modifie le premier élément de la liste
print(ma_liste)  # [10, 2, 3, 4, 5, 6]

ma_liste_de_courses.remove("lait")  # Supprime "lait" de la liste
print(ma_liste_de_courses)  # ["pain", "œufs"]
```

### Sets

Les sets sont des collections non ordonnées d'éléments uniques. Ils sont définis en utilisant des accolades `{}`.

```python
mon_set = {1, 2, 3, 4, 5}
mon_set_de_couleurs = {"rouge", "vert", "bleu"}
```

Les sets ne permettent pas les doublons, donc si vous essayez d'ajouter un élément déjà présent, il sera ignoré.

```python
mon_set.add(3)  # Ne fera rien, car 3 est déjà dans le set
print(mon_set)  # {1, 2, 3, 4, 5}
```

### Tuples

Les tuples sont des collections ordonnées d'éléments qui peuvent être de différents types, mais contrairement aux listes, ils sont immuables, ce qui signifie que vous ne pouvez pas modifier leurs éléments après leur création. Ils sont définis en utilisant des parenthèses `()`.

```python
mon_tuple = (1, 2, 3, 4, 5)
mon_tuple_de_couleurs = ("rouge", "vert", "bleu")
```

Les tuples sont souvent utilisés pour regrouper des données qui sont liées entre elles.

```python
coordonnees = (10.0, 20.0)  # Un tuple représentant des coordonnées (x, y)
print(coordonnees)  # (10.0, 20.0)
```

### Dictionnaires

Les dictionnaires sont des collections non ordonnées de paires clé-valeur. Ils sont définis en utilisant des accolades `{}` avec des deux-points `:` pour séparer les clés et les valeurs.

```python
mon_dictionnaire = {
    "nom": "Alice",
    "age": 30,
    "ville": "Paris"
}
```

Les dictionnaires sont très flexibles et permettent de stocker des données de manière structurée.

```python
print(mon_dictionnaire["nom"])  # Alice
mon_dictionnaire["age"] = 31  # Met à jour l'âge
print(mon_dictionnaire)  # {'nom': 'Alice', 'age': 31, 'ville': 'Paris'}
mon_dictionnaire["profession"] = "Ingénieur"  # Ajoute une nouvelle clé-valeur
print(mon_dictionnaire)  # {'nom': 'Alice', 'age': 31, 'ville': 'Paris', 'profession': 'Ingénieur'}
```

Un sous-dictionnaire peut également être créé en utilisant des dictionnaires imbriqués.

```python
mon_dictionnaire = {
    "nom": "Alice",
    "age": 30,
    "adresse": {
        "rue": "123 Rue de Paris",
        "ville": "Paris",
        "code_postal": "75000"
    }
}
print(mon_dictionnaire["adresse"]["ville"])  # Paris
```

## Différences entre les types complexes

Les listes, les sets, les tuples et les dictionnaires sont des types de données complexes en Python, chacun ayant ses propres caractéristiques :

- **Listes** : Collections ordonnées (ou non), mutables, pouvant contenir des doublons.
- **Sets** : Collections non ordonnées, mutables, ne contenant pas de doublons.
- **Tuples** : Collections ordonnées, immuables, pouvant contenir des doublons.
- **Dictionnaires** : Collections non ordonnées de paires clé-valeur, mutables, les clés doivent être uniques.
