---
title: Mes projets
meta_title: Mes projets
permalink: projets
---

## Hyweene.fr - Ma maison sur les internets

Ce site est développé par moi-même. 

J'ai écrit ce petit générateur de site statique en utilisant [Python](https://www.python.org/) et [Jinja2](https://jinja.palletsprojects.com/).

Il a été pensé pour être léger, rapide, et utilisant le moins de dépendances possibles. Il n'est pas aussi complet, ni aussi bien écrit que des générateurs plus connus comme [Jekyll](https://jekyllrb.com/) ou [Hugo](https://gohugo.io/), mais il fait le travail qu'on lui demande.

Je suis toujours entrain de l'améliorer, j'avais commencé son développement courant de l'été 2024, le code avait une approche "développement fonctionnel", en utilisant des dictionnaires, plus ou moins pour tous les usages, mais j'ai décidé de le réécrire, en Octobre 2025, en utilisant la `POO` pour le rendre plus maintenable.

Vous pouvez retrouver le code source sur [GitHub](https://github.com/bgiarrizzo/website-hackwithhyweene).

## Webhook Servarr -> IRC

Ce projet est un petit serveur web en [Python](https://www.python.org/) qui écoute les webhooks envoyés par des applications comme [Radarr](https://radarr.video/), [Sonarr](https://sonarr.tv/), [Lidarr](https://lidarr.audio/) ou [Prowlarr](https://prowlarr.com/) et qui envoie des messages dans un canal IRC pour notifier les utilisateurs.

La aussi, le code n'est pas ce qu'il y a de mieux, mais ça fonctionne.

Le code source est disponible sur [GitHub](https://github.com/bgiarrizzo/webhook-servarr-irc).

## Webhook Fail2ban -> IRC

La aussi, sur la même base que le projet précédent, c'est un petit serveur web en [Python](https://www.python.org/) qui écoute les webhooks envoyés par [Fail2ban](https://www.fail2ban.org/) et qui envoie des messages dans un canal IRC pour notifier les utilisateurs.

Le code source est disponible sur [GitHub](https://github.com/bgiarrizzo/webhook-fail2ban-irc).
