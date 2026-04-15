---
id: 7
title: Fonctions avancées
summary: Les fonctions avancées en Python permettent d'utiliser des concepts tels que les fonctions anonymes, les fonctions imbriquées et les décorateurs.
tags: python, fonctions, avancées, fonction avancées, programmation

prism_needed: true

publish_date: 2025-07-31T15:30:00+01:00
---

### Fonctions anonymes (lambda)

Les fonctions anonymes, ou fonctions lambda, sont des fonctions définies sans nom. Elles sont souvent utilisées pour des opérations simples et rapides. Voici un exemple :

```python
carre = lambda x: x * x
print(carre(5))  # Affiche "25"
```

### Fonctions imbriquées

Les fonctions imbriquées sont des fonctions définies à l'intérieur d'autres fonctions. Elles peuvent accéder aux variables de la fonction englobante.

```python
def exterieur(x: int):
    def interieur(y: int):
        return x + y
    
    return interieur

resultat = exterieur(10)

print(resultat(5))  # Affiche "15"
```

### Décorateurs

Les décorateurs sont une manière de modifier ou d'enrichir le comportement d'une fonction sans changer son code. Ils sont souvent utilisés pour ajouter des fonctionnalités comme la journalisation, la vérification des permissions, etc.

```python
def decorateur(fonction):
    def nouvelle_fonction(*args, **kwargs):
        print("Avant l'appel de la fonction")
        resultat = fonction(*args, **kwargs)
        print("Après l'appel de la fonction")

        return resultat
    
    return nouvelle_fonction

@decorateur
def dire_bonjour():
    print("Bonjour !")
```

Pour appeler la fonction décorée :

```python
dire_bonjour()

# Affiche :
# Avant l'appel de la fonction
# Bonjour !
# Après l'appel de la fonction
```
