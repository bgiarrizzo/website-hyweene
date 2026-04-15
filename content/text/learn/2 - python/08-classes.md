---
id: 8
title: Classes
summary: Les classes, comme la documentation python l'indique, sont un moyen de réunir données et fonctionnalités. Une classe est comme un constructeur d'objets, ou un moyen de créer des objets.
tags: python, fonctions, avancées, fonction avancées, programmation

prism_needed: true

publish_date: 2025-10-20T18:00:00+01:00
---

## Définition d’une classe

Pour définir une classe basique, en python, c'est très simple : 

```python
class Personne:
    nom = "Hyweene"

personneA = Personne()
personneB = Personne()
```

Dans cet exemple, je déclare une classe avec un attribut de classe qui a une valeur par défaut, ici `Hyweene`.

Je l'instancie deux fois : 

```python
print(personneA) # <__main__.Personne object at 0x732dd6b33650>
print(personneB) # <__main__.Personne object at 0x732dd6b33aa0>

print(personneA.nom) # Affiche "Hyweene"
print(personneB.nom) # Affiche "Hyweene"
```

Une fois la classe instanciée, on peut créer ou modifier un attribut sur une instance précise. Cela n’affecte pas l’attribut de classe lui-même, mais crée un attribut d’instance qui masque la valeur par défaut. Chaque instance peut donc avoir sa propre valeur :

```python
personneA.nom = "Michel"
personneB.nom = "JeanLuc"
```

Sans pour autant modifier la valeur dans la seconde instance :

```python
print(personneA.nom) # Affiche "Michel"
print(personneB.nom) # Affiche "JeanLuc"
```

Pour pouvoir définir la valeur de l'attribut à l'instanciation (à la création de l'objet), il vaudra mieux passer par un constructeur (`__init__`).

## Constructeur (init) et attributs d’instance

```python
class Personne:
    def __init__(self, nom, age):
        self.nom = nom
        self.age = age

personne = Personne(nom="Hyweene", age=36)
```

Ici, j'ai défini un constructeur qui me permettra d'attribuer une valeur voulue tout de suite à l'instanciation.

Voici le résultat :

```python
print(personne) # Affiche <__main__.Personne object at 0x732dd6f8f380>
print(personne.nom) # Affiche "Hyweene"
print(personne.age) # Affiche 36
```

Si par erreur j'oubliais de définir une valeur pour l'attribut `nom` ou `age`, l'interpreteur python me renverrait une erreur :

```python
class Personne:
    def __init__(self, nom, age):
        self.nom = nom
        self.age = age

personne = Personne()

Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: Personne.__init__() missing 1 required positional argument: 'nom'
```

## Méthodes d’instance, de classe, statiques

Pour définir les différentes méthodes, je vais réutiliser ma classe `Personne` : 

### Méthodes d'instance

Une méthode d'instance est utilisée le plus fréquemment pour manipuler des données de l'objet instancié.

L'argument `self` représente l'instance qui appelle la méthode, on y fait référence pour utiliser les différents attributs.

```python
class Personne:
    def __init__(self, nom, age):
        self.nom = nom
        self.age = age

    def presentation(self):
        print(f"Bonjour, Je m'appelle {self.nom}, j'ai {self.age} ans.")
```

Ici, je définis mon objet `Personne`, son nom et age, puis une fonction qui permettra de présenter cette personne : 

```python
personne = Personne(nom="Hyweene", age=36)
personne.presentation() # Affiche "Je m'appelle Hyweene, j'ai 36 ans."
```

### Méthodes de classe

Une méthode de classe est utilisée pour des méthodes qui doivent accéder ou modifier des données partagées entre toutes les instances d'une même classe.

Par exemple : 

```python
class Personne:
    nombre_de_personnes = 0

    def __init__(self, nom, age):
        self.nom = nom
        self.age = age
        Personne.nombre_de_personnes += 1

    @classmethod
    def compteur_personnes(cls):
        return cls.nombre_de_personnes
```

Je définis un compteur de population (on imaginera que le nombre d'instance = population) : 

```python
personne1 = Personne(nom="machin", age=25)
personne2 = Personne(nom="truc", age=32)
personne3 = Personne(nom="bidule", age=10)
personne4 = Personne(nom="chose", age=54)
personne5 = Personne(nom="bob", age=38)
personne6 = Personne(nom="alice", age=63)
```

On a bien créé 6 instances de personne, et si on appelle la méthode `compteur_personnes()`, dans n'importe quelle instance, on aura toujours le même nombre : 

```python
Personne.compteur_personnes() # Affiche 6
```

Si, par contre, on appelle `compteur_personnes()` juste après chaque instanciation de la classe, on verra `nombre_de_personnes` s'incrémenter à chaques étapes : 

```python
personne1 = Personne(nom="machin", age=25)
print(Personne.compteur_personnes()) # Affiche 1
personne2 = Personne(nom="truc", age=32)
print(Personne.compteur_personnes()) # Affiche 2
personne3 = Personne(nom="bidule", age=10)
print(Personne.compteur_personnes()) # Affiche 3
personne4 = Personne(nom="chose", age=54)
print(Personne.compteur_personnes()) # Affiche 4
personne5 = Personne(nom="bob", age=38)
print(Personne.compteur_personnes()) # Affiche 5
personne6 = Personne(nom="alice", age=63)
print(Personne.compteur_personnes()) # Affiche 6
```

### Méthodes Statiques

Une méthode statique ne reçoit ni `self`, ni `cls`. Elle appartient au namespace de la classe, mais ne travaille pas sur la classe ou sur une instance.

Elle est utile pour écrire des utilitaires.

Exemple :

```python
class Math:
    @staticmethod
    def addition(a, b):
        return a + b

print(Math.addition(1,2)) # Affiche 3
```

## Encapsulation : attributs privés et protégés

L'encapsulation est un concept en POO qui vise à cacher les détails internes d'une classe pour proteger ses données et contrôler l'accès.

Ca permet d'éviter des erreurs et faciliter la maintenance du code.

### Pourquoi encapsuler ?

Admettons qu'une classe est une boite. Les attributs sont dedans et seules quelques méthodes permettent d'y acceder. Via l'encapsulation, on peut :

- Protéger les données d'une utilisation incorrecte.
- Controler la modification par des méthodes spécifiques.
- Faciliter la maintenance en limitant les points d'accès aux données.

### Niveaux de visibilité

- Public : accessible de partout.

Exemple : 

```python
class Personne:
    def __init__(self, nom):
        self.nom = nom  # Attribut public
    
personne = Personne("Hyweene")
print(personne.nom)  # Accès direct à l'attribut public
```

- Protégé : préfixé par un underscore `_`, indique que l'attribut ou la méthode est destiné à être utilisé uniquement à l'intérieur de la classe et de ses sous-classes.

```python
class Personne:
    def __init__(self, nom):
        self._nom = nom  # Attribut protégé
    
personne = Personne("Hyweene")
print(personne._nom)  # Accès direct à l'attribut protégé (possible mais déconseillé)
```

- Privé : préfixé par deux underscores `__`, indique que l'attribut ou la méthode est destiné à être utilisé uniquement à l'intérieur de la classe elle-même.

```python
class Personne:
    def __init__(self, nom):
        self.__nom = nom  # Attribut privé  
    
personne = Personne("Hyweene")
print(personne.__nom) 

...

AttributeError: 'Personne' object has no attribute '__nom'
```

On obtient une erreur car l'attribut est privé.

On peut corriger en ajoutant une méthode publique pour accéder à l'attribut privé :

```python
class Personne:
    def __init__(self, nom):
        self.__nom = nom  # Attribut privé

    def get_nom(self):
        return self.__nom  # Méthode publique pour accéder à l'attribut privé  

personne = Personne("Hyweene")
print(personne.get_nom())  # Affiche "Hyweene"
```

## Héritage simple et surcharge de méthodes

L'héritage est un concept fondamental en POO qui permet de créer une nouvelle classe (classe dérivée ou sous-classe) basée sur une classe existante. 

La sous-classe hérite des attributs et des méthodes de la super-classe. On peut facilement réutiliser ce code, et créer des hiérarchies de classes.

### Exemple d'héritage simple

```python
class Animal:
    def parler(self):
        return "L'animal fait un bruit."

class Chien(Animal):
    def parler(self):
        return "Le chien aboie."

class Chat(Animal):
    def parler(self):
        return "Le chat miaule."
```

Ici, j'ai une classe mère : `Animal` avec une méthode `parler()`.

Quand je créé les classes filles `Chien` et `Chat`, elles héritent de la méthode `parler()`.
Je peux les surcharger pour qu'elles aient un comportement spécifique.

```python
animal = Animal()
chien = Chien()
chat = Chat()

print(animal.parler())  # Affiche "L'animal fait un bruit."
print(chien.parler())   # Affiche "Le chien aboie."
print(chat.parler())    # Affiche "Le chat miaule."
```

## Introduction à la composition

La composition permet de construire des objets complexes en combinant des objets plus simples.

```python
class Moteur:
    def demarrer(self):
        return "Moteur démarré."
    
class Voiture:
    def __init__(self):
        self.moteur = Moteur()
    
    def demarrer_voiture(self):
        return self.moteur.demarrer()
```

Ici, j'ai une classe `Moteur` avec une méthode `demarrer()`.

La classe `Voiture` contient une instance de `Moteur` comme attribut.

```python
voiture = Voiture()
print(voiture.demarrer_voiture())  # Affiche "Moteur démarré."
```

## Représentation d’objets (str, repr)

Pour personnaliser la représentation en chaîne de caractères d'un objet, on peut définir les méthodes spéciales `__str__` et `__repr__` dans une classe.

```python
class Personne:
    def __init__(self, nom, age):
        self.nom = nom
        self.age = age

    def __str__(self):
        return f"{self.nom}, {self.age} ans"

    def __repr__(self):
        return f"Personne(nom='{self.nom}', age={self.age})"
```

Ici, j'ai défini une classe `Personne` avec un constructeur, puis j'ai ajouté les méthodes `__str__` et `__repr__`.

```python
personne = Personne("Hyweene", 36)
print(str(personne))  # Affiche "Hyweene, 36 ans"
print(repr(personne)) # Affiche "Personne(nom='Hyweene', age=36)"
```
