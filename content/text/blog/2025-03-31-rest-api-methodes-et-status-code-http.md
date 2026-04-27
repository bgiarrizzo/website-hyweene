---
title: "REST : Méthodes et Status Code HTTP"
summary: "Un tableau récapitulatif des principales méthodes HTTP utilisées dans une API REST, accompagnés des codes de statut HTTP les plus fréquemment associés."
publish_date: 2025-03-31T12:15:00+02:00
update_date: 2025-03-31T12:15:00+02:00
category: "Pense-bête"
tags: ["REST", "HTTP", "Status Code", "Méthode"]
---

Bon, j'en avais assez de chercher sur les internets après les codes de statut HTTP, alors j'ai décidé de faire un tableau récapitulatif des principaux méthodes HTTP utilisés dans une API REST, accompagnés des codes de statut HTTP les plus fréquemment associés.

Ça m'évitera de devoir retrouver le lien à chaque fois que je code et que j'ai un trou de mémoire :-D

## Le tableau

| **Verbe HTTP**  | **Codes de statut courants**                                         |
|-----------------|----------------------------------------------------------------------|
| **GET**         | 200 (OK), 404 (Not Found), 401 (Unauthorized)                        |
| **POST**        | 201 (Created), 400 (Bad Request), 401 (Unauthorized), 409 (Conflict) |
| **PUT**         | 200 (OK), 204 (No Content), 400 (Bad Request), 404 (Not Found)       |
| **PATCH**       | 200 (OK), 204 (No Content), 400 (Bad Request), 404 (Not Found)       |
| **DELETE**      | 200 (OK), 204 (No Content), 404 (Not Found)                          |
| **HEAD**        | 200 (OK), 404 (Not Found)                                            |
| **OPTIONS**     | 200 (OK)                                                             |

## Détails des méthodes HTTP

- **GET** :
  - Utilisé pour lire des données sans modification.
  - Le code 200 indique un succès,
  - Le code 404 signale que la ressource est introuvable.
- **POST** :
  - Sert à créer une ressource.
  - Le code 201 confirme la création
  - Le code 409 peut indiquer un conflit, par exemple si la ressource existe déjà.
- **PUT** :
  - Remplace ou met à jour une ressource.
  - Le code 204 est souvent utilisé lorsqu'aucune réponse n'est nécessaire.
- **PATCH** :
  - Permet des modifications partielles. Similaire à PUT mais plus ciblé.
- **DELETE** :
  - Supprime une ressource.
  - Le code 204 indique que la suppression a réussi sans contenu à renvoyer.
- **HEAD** :
  - Semblable à GET, mais ne retourne que les en-têtes de réponse.
- **OPTIONS** :
  - Fournit des informations sur les méthodes disponibles pour une ressource.
