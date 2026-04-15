---
title: "Tipiak : J'ai monté mon Hyweene Video et Hyweene Music perso"
summary: Yo-ho yo-ho, a pirate's life for me !
publish_date: 2024-10-29T23:00:00+01:00
update_date: 2024-10-29T23:00:00+01:00
cover: "2024-10-29.png"
cover_alt: "couverture hyweeneflix"
category: "Retour d'expérience"
tags: [radarr, sonarr, lidarr, prowlarr, jellyfin, seedbox]
---

L'année dernière, Léo Duff sortait une vidéo : [J'ai monté mon Netflix perso](https://www.youtube.com/watch?v=J8KcJL9gylA).

J'ai trouvé l'idée super interessante, et j'ai décidé de la reproduire chez moi.

Ceux qui en 2014 ont connu [Popcorn Time](https://fr.wikipedia.org/wiki/Popcorn_Time) connaissent la folie que c'était. Un soft qui permettait de streamer des films et séries en torrent, avec une interface super simple et intuitive. C'était le Netflix du piratage.

## Pour commencer

Je n'avais pas très envie de prendre un VPS chez un hoster, et monter un serveur chez moi est le plus safe pour moi. Mes données sont chez moi, et je peux les protéger comme je veux.

J'avais une petite machine chez moi, un Lenovo ThinkCentre M900 Tiny, avec un i7-6700T, 8Go de RAM, et un SSD de 256Go. Ce n'est pas énorme, surtout pour une machine qui va servir à stocker films, séries, musiques et autres, donc je décide d'upgrade tout ça.

Je passe à 32Go de ram, et je rajoute un SSD NVMe de 2To pour stocker mes films et séries.

## Les services hébergés

De quoi on a besoin quand on veut monter une seedbox à la maison, et automatisée ?

- Un client torrent
- Un paquet de Grabbers
- Un indexer manager
- Un serveur de media (type Plex ou Jellyfin)

### Le client torrent

[Transmission](https://transmissionbt.com/), fidèle au poste. Léger, stable, aucun problème avec lui depuis 2014. Je n'utilise quasiment jamais l'interface web, les différents grabbers ont une interface de monitoring des téléchargements, et je n'ai pas besoin de plus.

### Les grabbers

Ceux qui avaient leur seedbox en 2012 connaissent [SickBeard](https://github.com/midgetspy/Sick-Beard) et [CouchPotato](https://github.com/CouchPotato/CouchPotatoServer/), qui permettaient de récupérer automatiquement les films et series, via torrent ou usenet.

Aujourd'hui, on a [Radarr](https://github.com/Radarr/Radarr), [Sonarr](https://github.com/Sonarr/Sonarr), mais aussi tous leurs petits cousins :

- [Readarr](https://github.com/Readarr/Readarr) : Avec lequel je récupère mes ebooks
- [Lidarr](https://github.com/Lidarr/Lidarr) : Qui gère mes musiques
- [Prowlarr](https://github.com/Prowlarr/Prowlarr) : Qui permet de gérer toute la partie Indexers.

On a maintenant également [Bazarr](https://github.com/morpheus65535/bazarr), un grabber de sous-titres.

Chose très utile, puisqu'avant, je gérais mes sous titres via [Subliminal](https://github.com/Diaoul/subliminal), qui est une CLI, c'est mignon, mais c'est pas user-friendly. Et étant une cli, ce n'est pas automatisable, obligé de monter une crontab, qui va se lancer toutes les heures, et qui va vérifier l'entièreté de ma bibliothèque, inutilement, parce que je n'ai besoin que du dernier sub du dernier film ou dernier épisode rajouté. pas besoin de tout rescan, enfin BREF, je m'égare !!

### L'indexer manager

[Prowlarr](https://github.com/Prowlarr/Prowlarr) est devenu mon nouveau copain !

Je ne compte plus le temps que j'ai pu passer du temps de sickbeard et couchpotato à chercher des indexers, à les ajouter, à les tester, gérer les configuration, vérifier si l'indexer n'avait pas été fermé par les autorités, etc.

Prowlarr fait tout ceci pour moi, et il le fait très bien !

### Le serveur de media

Mon choix s'est porté sur [Plex](https://www.plex.tv/), pour une raison simple : Jellyfin a de gros soucis sur AppleTV ... et j'ai une AppleTV. Donc même si j'aime jellyfin d'amour, il est léger, gratuit, et son algo de transcodage est très économe, mais pragmatiquement, je dois rester sur plex pour le moment.

## Les services tiers

Radarr et Sonarr sont syncronisés avec [Trakt](https://trakt.tv/), c'est un tracker de films et série, qui permet de gérer sa watchlist, de voir les films et séries que l'on a vu, de voir les films et séries que l'on est en train de voir, etc.

Quand j'ajoute un film ou une serie à ma watchlist, Radarr ou Sonarr interrogent les trackers pour voir si le film ou la serie est disponible.

## Un petit résumé

Toute cette petite équipe a besoin d'interconnexions pour fonctionner et que l'automatisation soit parfaite, voici à quoi ressemble la stack :

<figure>
  <a href="/media/images/blog/illustration/2024-10-29/stack.png" target="_blank">
    <img src="/media/images/blog/illustration/2024-10-29/stack.png" alt="stack" />
  </a>
</figure>

Volontairement, Plex ou Jellyfin ne sont pas présents, parce qu'un peu à part, ils n'ont pas besoin de communiquer avec les autres services, ils ont juste besoin de récupérer les médias, dans un dossier qui leur est propre.

## Un Cas d'utilisation

Je suis au cinéma, je vois une bande annonce d'un film qui m'intéresse, je sors mon téléphone, je vais sur l'application de trakt, je cherche le film, je l'ajoute à ma watchlist.

Radarr interroge trakt, voit qu'un nouveau film est ajouté à la watchlist, va ajouter ce film à sa bibliotèque, puis va commencer à interroger les trackers.

Quelques semaines plus tard, le film va apparaitre sur les trackers torrents, en 720p, Radarr va le télécharger, le renommer, le déplacer dans le dossier de Plex, et Plex va le scanner, et le rendre disponible sur l'application Plex de mon AppleTV.

Si entre temps, une nouvelle version du film, en 1080p voire en 4K a été détectée sur les trackers torrent par Radarr, il va télécharger la nouvelle version, et supprimer l'ancienne.

Une fois le téléchargement terminé, Radarr va envoyer une notification à Bazarr, qui va chercher les sous-titres, dans les langues que j'aurai précisé, et les ajouter au dossier du film.

Ce même processus est valable pour les séries, les musiques, les ebooks, etc. modulo le téléchargement des sous titres.

## Conclusion

J'ai monté mon Hyweene Video et Hyweene Music perso, et je suis très content du résultat. C'est super simple à maintenir, et ça me permet de regarder mes films et séries en toute tranquilité.

Le seul soucis que j'ai maintenant, c'est l'espace disque qui commence à manquer ... Je vais devoir commencer à étudier l'achat d'un NAS avec quelques dizaines de To de stockage, mais ça, c'est une autre histoire !
