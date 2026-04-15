---
id: 8
title: Structures
summary: 

tags: swift, swift playground, xcode, structures, struct

prism_needed: true

publish_date: 2025-11-25T12:00:00+01:00

disabled: true
---

## Créer vos propres structures

Swift permet de créer ses propres types, le plus fréquent est la structure (ou struct).

Elles peuvent contenir leur propres variables, ou constantes, leur propres fonction.

On va prendre comme exemple une attraction dans un Disneyland par exemple : 

```swift
struct Attraction {
    var name: String
}
```

Ce code défini la struct, et nous allons maintenant l'instancier : 

```swift 
var space_mountain = Attraction(name: "Space Mountain")
print(space_mountain.name)
```

On a écrit `name` et `space_mountain` comme des variables, on peut donc les modifier à l'envie : 

```swift
space_mountain.name = "Space Mountain : Mission 2"
```

Les propriétés d'une struct peuvent avoir des valeurs par défaut, comme une variable classique, et on peut compter sur l'inférence de type de Swift :)

## Propriétés calculées

## Observateurs de propriétés

## Méthodes

## Méthodes mutantes

## Propriétés et méthodes des chaînes de caractères

## Propriétés et méthodes des tableaux

## Initialiseurs

## Référence à l’instance courante

## Propriétés paresseuses

## Propriétés et méthodes statiques

## Contrôle d’accès

## Résumé sur les structures
