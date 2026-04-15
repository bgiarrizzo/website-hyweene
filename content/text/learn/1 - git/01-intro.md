---
id: 1
title: Intro
summary: "Introduction à Git, un système de contrôle de version distribué. Apprenez les bases de la gestion des versions, les types de VCS, et les concepts clés tels que les commits, les branches et les dépôts."
tags: git, système de contrôle de version, contrôle, version, versionning, vcs, distribué, linus torvalds, historique, repository, commit, branche, remote, merge, fusion

prism_needed: false

publish_date: 2024-09-09T09:30:00+01:00
update_date: 2024-10-31T16:45:00+01:00
---

## A Propos de la gestion des versions

Pourquoi se soucier de la gestion des versions ?

Un VCS (Version Control System) est un système qui enregistre les modifications apportées à un fichier ou à un ensemble de fichiers au fil du temps afin que vous puissiez revenir a un état antérieur d'un fichier si besoin.

En tant que développeur, utiliser un VCS est très sage. Cela permet de garder toutes les versions d'un fichier, à tout moment. Un VCS permet également de travailler en équipe sur un projet ou une fonctionnalité, de voir qui a introduit quelle ligne, à quel endroit, à quel moment.

Utiliser un VCS permet de rester serein, de ne pas avoir peur de casser quelque chose, de pouvoir revenir en arrière si besoin.

### Faire des copies

La première méthode, également la plus simple et la moins fiable, est de copier les fichiers manuellement.

Pour résumer, vous travaillez dans le dossier de travail "code" et vous copiez manuellement le dossier de travail dans un autre dossier pour conserver une version de sauvegarde (par exemple code-dateDuJour ou code-fonctionnaliteA)

Cela fonctionne, mais c'est très limité et peu fiable.

On a vite fait de se tromper de dossier, d'écraser le mauvais fichier, etc.

### Les VCS locaux

Ces VCS utilisent une base de données locale pour stocker les modifications apportées aux fichiers.

RCS (Revision Control System) est un exemple de VCS local.

Ce type de VCS stocke la copie complète d'un fichier, et ne garde que les changements réalisés entre les versions.

Exemple :

Nous avons un fichier `fichier.txt` de 150 lignes.

Si je modifie 10 lignes, le VCS local va stocker mon nouveau fichier de 160 lignes, et un journal des modifications, contenant les 10 lignes modifiées.

### Les VCS centralisés

Dans le cas d'un VCS centralisé, un serveur central regroupe toutes les sources et les versions de chaque fichier.

Les développeurs travaillent sur une copie locale des fichiers, et envoient leurs modifications au serveur central.

Exemple :

- SVN (Subversion)
- CVS (Concurrent Versions System)

### Les VCS distribués

Contrairement aux VCS centralisés, où un serveur central stocke toutes les versions de fichiers, avec un VCS distribué chaque contributeur possède une copie locale de l'ensemble du dépôt (ou des branches qui l'intéressent) sur son ordinateur.

Cela offre plusieurs avantages :

- Pas de dépendance à un serveur central
- Possibilité de travailler hors ligne
- Sauvegardes multiples
- Collaboration plus facile, grace a la gestion flexible des branches.

Exemple :

- Git
- Mercurial
- Bazaar

***

## Histoire de Git

Git a été créé par Linus Torvalds en 2005 pour le développement du noyau Linux.

Les développeurs du noyau Linux utilisaient BitKeeper, un VCS propriétaire, pour gérer le code source du noyau. En 2005, des désaccords entre la communauté Linux et BitKeeper ont conduit à la fin de l'utilisation de BitKeeper. L'équipe de développement du noyau avait donc besoin de toute urgence d'un nouveau VCS.

Linus a donc créé git, pour répondre à ce besoin.

***

## Concepts Clés

Git permet aux développeurs de suivre les modifications apportées au code source au fil du temps.

Il repose sur plusieurs concepts clés qui facilitent la collaboration et l'organisation du développement.

### Version

La notion de version fait référence à l’état spécifique du code à un moment donné, souvent associé à un commit ou une étiquette (tag) pour marquer des points importants, comme les versions stables du logiciel.

### Repository

Un dépôt est l’endroit où le code source et l’historique des modifications sont stockés. Il peut être local (sur votre machine) ou distant (sur un serveur).

### Commit

Un commit est un enregistrement des modifications apportées au code. Chaque commit est identifié de manière unique et contient un message décrivant les changements effectués.

### Branch

Les branches permettent de travailler sur différentes versions du projet simultanément. Elles facilitent le développement de nouvelles fonctionnalités ou la correction de bugs sans affecter la version principale.

### Remote

Un dépôt distant est une version du dépôt hébergée sur un serveur. Il permet aux développeurs de collaborer en partageant leurs modifications via des plateformes comme GitHub ou GitLab.

### Merge

La fusion (merge) est le processus de combinaison des modifications de deux branches différentes. Elle permet d’intégrer les changements apportés par une branche dans une autre.
