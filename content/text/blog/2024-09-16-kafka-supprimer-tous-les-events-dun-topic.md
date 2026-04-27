---
title: "Kafka : Supprimer tous les events d'un topic"
summary: "Un pense bête pour se rappeller comment supprimer tous les events d'un topic Kafka"
publish_date: 2024-09-16T11:30:00+01:00
update_date: 2024-09-16T11:30:00+01:00
category: "Pense-bête"
tags: [kafka, topic, event, supprimer]

prism_needed: true
---

Dans ma mission actuelle, je travaille avec Kafka. Je suis également en charge, avec d'autres personnes, du support utilisateur. Aujourd'hui, un utilisateur rencontrait un problème avec la suppression de ses messages dans un topic Kafka dédié à des tests automatisés.

A la fin de ses tests, il doit purger les messages créé pendant la session, mais rencontrait une erreur de timeout à l'execution de la requete.

Dans le cadre de ce pense bête, la cleanup.policy du topic est configurée à delete, ce qui signifie que les messages sont supprimés lorsqu'ils atteignent la rétention définie, la méthode est différente pour les topics configurés avec la rétention compact.

Pour supprimer tous les messages d'un topic Kafka, il faut utiliser la commande `kafka-delete-records` fournie par Kafka.

```bash
kafka-delete-records --bootstrap-server ${bootstrapServerAndPort} --topic ${topicName} --offset-json-file path/to/offsets.json
```

Le fichier `offsets.json` doit contenir les offsets des messages à supprimer. Par exemple, pour un topic à trois partitions, le fichier doit contenir trois objets, un par partition.

```json
{
  "partitions": [
    {
      "topic": "${topicName}",
      "partition": 0,
      "offset": ${offsetPartition0}
    },
    {
      "topic": "${topicName}",
      "partition": 1,
      "offset": ${offsetPartition1}
    },
    {
      "topic": "${topicName}",
      "partition": 2,
      "offset": ${offsetPartition2}
    }
  ],
  "version": 1
}
```

Dans cet exemple, tous les messages situés avant les offsets spécifié pour chaque partition seront supprimés.

Pour obtenir les offsets des messages à supprimer, il faut utiliser la commande `kafka-consumer-groups`.

```bash
kafka-consumer-groups --bootstrap-server ${bootstrapServerAndPort} --group ${consumerGroupName} --describe
```

Cette commande affiche les offsets des messages consommés par le groupe de consommateurs `${consumerGroupName}`. Il suffit de récupérer ces offsets pour les mettre dans le fichier `offsets.json`.

Le résultat est le suivant :

```bash
GROUP       TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID     HOST            CLIENT-ID
myTestApp   myTestTopic     0          3               3               0               -               -               -
myTestApp   myTestTopic     1          5               5               0               -               -               -
myTestApp   myTestTopic     2          6               6               0               -               -               -
```

Une fois le fichier `offsets.json` prêt, il suffit de lancer la commande `kafka-delete-records` pour supprimer les messages du topic `${topicName}`.

```bash
kafka-delete-records --bootstrap-server ${bootstrapServerAndPort} --topic ${topicName} --offset-json-file path/to/offsets.json
```

Dans notre cas, l'utilisateur rencontrait un problème de timeout, ce qui peut arriver si le nombre de messages à supprimer est très grand. Il faut alors augmenter le timeout de la commande `kafka-delete-records`.

Pour se faire, nous devons créer un fichier command-config avec le timeout souhaité :

```bash
request.timeout.ms=120000
```

Puis lancer la commande `kafka-delete-records` avec le fichier de configuration :

```bash
kafka-delete-records --bootstrap-server ${bootstrapServerAndPort} --topic ${topicName} --offset-json-file path/to/offsets.json --command-config path/to/command-config
```

Les messages du topic Kafka `${topicName}` ont été supprimés avec succès.

## Méthode Gros Bourrin

On peut également supprimer la totalité des events d'un topic en changeant la rétention du topic à 1ms, puis en la remettant à la valeur initiale.

Cette méthode a l'avantage de fonctionner également pour les topics compactés ! :D
