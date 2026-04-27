---
title: "Docker : Modifier un fichier dans un container stoppé"
summary: "Modifier un fichier dans un container Docker stoppé"
publish_date: 2025-09-26T14:00:00+01:00
update_date: 2025-09-26T14:00:00+01:00
category: "Pense-bête"
tags: [docker, container, fichier, modification]

prism_needed: true
---

Dernièrement, j'ai modifié un fichier de conf apache2 directement dans un container docker. Au redémarrage, le container redemarrait en boucle, car la conf était foireuse.

Je me suis donc retrouvé coincé avec uncontainer stoppé, et je n'avais pas accès à la méthode de déploiement, pour faire repartir le process.

Donc petit tuyau trouvé sur les internets : 

Dans le container en restart loop, on identifie son nom ou son ID : 

```bash
docker ps -a
```

Une fois son nom ou ID récupéré, on peut faire une copie locale du fichier à modifier : 

```bash
docker cp <container_id_ou_nom>:/chemin/vers/fichier/a/modifier . 
```

Une fois la modification terminée, on peut remettre le fichier dans le container : 

```bash
docker cp ./fichier/a/modifier <container_id_ou_nom>:/chemin/vers/fichier/a/modifier
```

Une fois terminé, on peut redémarrer :

```bash
docker start <container_id_ou_nom>
```

Et voilà, le container redémarre avec la bonne conf.
