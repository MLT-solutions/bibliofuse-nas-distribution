[English](docker-install.md) | [Español](docker-install.es.md) | [Français](docker-install.fr.md) | [Nederlands](docker-install.nl.md) | [Português](docker-install.pt.md) | [Русский](docker-install.ru.md) | [简体中文](docker-install.zh-CN.md) | [日本語](docker-install.ja.md) | [한국어](docker-install.ko.md) | [Bahasa Indonesia](docker-install.id.md) | [Bahasa Melayu](docker-install.ms.md)

# Installation et opérations Docker

## Langue du navigateur

Après l'installation, ouvrez Réglages et choisissez **Langue**. Le navigateur peut suivre la langue système ou utiliser anglais, espagnol, français, néerlandais, portugais, russe, chinois simplifié, japonais, coréen, indonésien ou malais. Le choix est stocké uniquement dans ce navigateur et n'affecte pas le conteneur ni les métadonnées de la bibliothèque.

## 1. Choisir les dossiers

BiblioFuse utilise trois dossiers hôte :

| Objectif | Chemin du conteneur | Accès requis | Sauvegarde |
| --- | --- | --- | --- |
| Compte, identité, catalogue et réglages | `/config` | Lecture/écriture | Oui |
| Pages préparées et miniatures | `/cache` | Lecture/écriture | Non |
| Votre bibliothèque de livres | `/library` | Lecture seule | Sauvegarder séparément |

Les chemins du conteneur restent identiques. `CONFIG_PATH`, `CACHE_PATH` et `LIBRARY_PATH` sélectionnent les vrais dossiers de l'hôte. Docker ne peut pas localiser seul une bibliothèque : montez le dossier avant le premier lancement, puis choisissez le dossier à attacher dans Réglages.

## 2. Configurer Compose

Téléchargez les fichiers dans `docker/`, copiez `.env.example` vers `.env`, puis modifiez `.env`. Utilisez des chemins absolus pour une installation serveur.

Sous Linux, obtenez les identifiants numériques utilisateur et groupe avec :

```sh
id
```

Définissez `PUID` et `PGID` sur une identité qui peut écrire les dossiers config/cache et lire la bibliothèque. BiblioFuse fonctionne sans privilèges root.

## 3. Démarrer et vérifier

```sh
docker compose pull
docker compose up -d
docker compose ps
docker compose logs --tail=100 bibliofuse
```

Ouvrez `http://<server-ip>:7343`. Créez l'administrateur, puis choisissez **Attacher la bibliothèque** dans Réglages. Le sélecteur affiche le montage **Bibliothèque** configuré et ses sous-dossiers, mais une installation neuve n'a aucune racine attachée avant votre sélection puis Actualiser.

N'exécutez pas ce service Docker en réseau hôte à côté du paquet Synology natif sur le même NAS : les deux lient HTTPS natif `7342` et l'interface navigateur `7343`.

La première actualisation parcourt toute la bibliothèque. Les suivantes vérifient toujours l'arborescence, mais les métadonnées d'archive inchangées sont réutilisées.

## 4. Ajouter un autre dossier de bibliothèque

Chaque racine de bibliothèque doit pointer vers un chemin présent dans le conteneur. Ajoutez d'abord un nouveau montage en lecture seule à `compose.yaml`, par exemple :

```yaml
volumes:
  - "/srv/books:/library:ro"
  - "/srv/manga:/books/manga:ro"
environment:
  BF_LIBRARY_BROWSE_ROOTS: >-
    [{"name":"Library","path":"/library"},{"name":"Manga","path":"/books/manga"}]
```

Recréez le conteneur, puis utilisez Réglages → Attacher la bibliothèque et sélectionnez **Manga** dans le sélecteur. Les utilisateurs ne saisissent ni `/books/manga` ni le chemin hôte `/srv/manga` dans l'interface web.

Utilisez **Modifier** si un dossier monté a été renommé ; BiblioFuse conserve l'identité de catalogue de la racine. **Désactiver** conserve les données de catalogue. **Détacher** fonctionne aussi pour la dernière racine et purge le catalogue BiblioFuse de cette racine, ses métadonnées et sa progression de lecture sans supprimer fichiers ou dossiers.

## 5. Planifier l'actualisation

Réglages propose Désactivée, Quotidienne et Hebdomadaire. Les heures quotidienne/hebdomadaire utilisent des créneaux de 30 minutes. Définissez `BF_TIME_ZONE` sur un fuseau IANA valide tel que `Asia/Kuala_Lumpur`.

## 6. Mettre à jour

Préférez une étiquette d'image numérotée pour des déploiements contrôlés. Sauvegardez `/config`, puis :

```sh
docker compose pull
docker compose up -d
docker image prune
```

`docker image prune` est facultatif et supprime les données d'images inutilisées, pas les livres.

## 7. Arrêter ou désinstaller

```sh
docker compose down
```

Cela supprime le conteneur et le réseau. Cela ne supprime pas les dossiers hôte de configuration, cache ou bibliothèque.

Pour une réinitialisation usine explicite :

1. Exécutez `docker compose down`.
2. Sauvegardez les dossiers hôte nommés par `CONFIG_PATH` et `CACHE_PATH`.
3. Renommez ces deux dossiers en sauvegardes conservées et créez de nouveaux dossiers vides avec les mêmes noms d'origine et permissions.
4. Exécutez `docker compose up -d` et créez un nouvel administrateur.

Ne renommez, videz ou supprimez jamais `LIBRARY_PATH`. BiblioFuse le monte en lecture seule.

## Accès navigateur hors du domicile

Ne transférez pas directement le port `7343` depuis un routeur. Utilisez un proxy inverse HTTPS de confiance avec authentification et certificat valide, ou accédez à l'adresse LAN par votre propre réseau VPN/Tailscale.

L'accès Tailscale au navigateur utilise l'adresse Tailscale du NAS/serveur suivie de `:7343`. C'est un accès navigateur ; il n'ajoute pas d'appairage Docker aux apps iOS ou visionOS publiées actuellement.

## Dépannage

### Le sélecteur de bibliothèque est vide

- Vérifiez que `LIBRARY_PATH` est le vrai dossier hôte et qu'il est défini avant `docker compose up`.
- Exécutez `docker compose config` et vérifiez le montage `/library:ro`.
- Vérifiez que `PUID:PGID` peut lire le dossier hôte.
- Recréez le conteneur après un changement de montage, puis rouvrez Réglages.

### Permission refusée

L'utilisateur/groupe numérique sélectionné ne peut pas accéder à un dossier monté. Corrigez les permissions du dossier hôte ou choisissez le bon `PUID`/`PGID` ; ne lancez pas le conteneur en root comme première solution.

### Les pages s'arrêtent pendant la lecture

Vérifiez l'activité CPU et disque. Les pages d'archive à froid doivent être décompressées et préparées. Le serveur précharge les pages suivantes, mais les CPU NAS moins puissants peuvent encore montrer de courts écarts. Les lectures répétées devraient profiter du cache persistant.

### Le conteneur redémarre sans cesse

```sh
docker compose ps
docker compose logs --tail=200 bibliofuse
```

Vérifiez les chemins de montage invalides, l'autorisation d'écriture config/cache, les conflits de ports et un `.env` endommagé ou incomplet.

### Le mot de passe administrateur est perdu

Il n'y a pas de récupération par e-mail. Recréer uniquement le conteneur ne réinitialise pas le mot de passe car le vérificateur est stocké dans `/config`. Utilisez la procédure de réinitialisation usine explicite ci-dessus si la perte du compte BiblioFuse, identité, catalogue et réglages existants est acceptable ; la bibliothèque elle-même reste intacte.
