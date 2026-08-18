[English](README.md) | [Español](README.es.md) | [Français](README.fr.md) | [Nederlands](README.nl.md) | [Português](README.pt.md) | [Русский](README.ru.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Bahasa Indonesia](README.id.md) | [Bahasa Melayu](README.ms.md)

<p align="center">
  <img src="assets/bibliofuse-logo.png" alt="Logo BiblioFuse" width="180">
</p>

<h1 align="center">BiblioFuse NAS</h1>

<p align="center">
  Une bibliothèque privée de livres électroniques et BD, auto-hébergée avec Docker et Synology NAS.
  <br>
  <a href="https://bibliofuse.com">Site web BiblioFuse</a>
</p>

## Hébergement et lecture gratuits dans le navigateur

BiblioFuse NAS est gratuit à héberger dans Docker ou Synology Container Manager. Sa bibliothèque web et son lecteur navigateur sont également gratuits. Aucun abonnement n'est nécessaire pour le serveur Docker ou l'interface web.

Ce dépôt public de distribution contient les fichiers d'installation et la documentation. Le code source du serveur BiblioFuse est maintenu séparément et n'est pas inclus ici.

## État du produit

| Hôte ou client | Disponibilité | Lecture et connexion |
| --- | --- | --- |
| Docker / Synology Container Manager | Bêta publique `0.1.11` | Serveur, interface navigateur et streaming natif Wi-Fi local gratuits |
| Lecteur web BiblioFuse | Inclus | CBZ, ZIP, CBR, RAR, EPUB, TXT, TEXT et Markdown |
| Apps iOS / visionOS publiées avec Docker | Pris en charge sur le Wi-Fi local | Découverte Bonjour et streaming HTTPS épinglé ; Premium est appliqué par l'app native |
| App Synology Package Center (`.spk`) | Version publique x86-64 | Paquet non-root avec accès guidé en lecture seule aux dossiers partagés DSM existants |
| Streaming iOS / visionOS depuis l'app Synology | Pris en charge sur le Wi-Fi local | Découverte Bonjour et streaming HTTPS épinglé ; Premium est appliqué par l'app native |
| Hôte BiblioFuse Mac / PC | Produit distinct | Recommandé lorsque les meilleures performances de streaming natif sont prioritaires |

Docker et le lecteur navigateur restent gratuits. Le streaming natif est une fonction Premium de l'app iOS/visionOS et fonctionne sur le même réseau Wi-Fi local.

## Langues du navigateur

L'app navigateur peut suivre la langue système ou être définie dans Réglages sur anglais, espagnol, français, néerlandais, portugais, russe, chinois simplifié, japonais, coréen, indonésien ou malais. Ce choix reste dans le navigateur et ne modifie pas la configuration serveur, les métadonnées des livres ni les clients natifs.

## Attentes de performances

Un NAS toujours actif est pratique, privé et économe en énergie, mais il n'est normalement pas aussi rapide qu'un Mac ou PC moderne pour préparer les pages de BD et d'archives.

- **Hôte Mac ou PC :** meilleur choix pour une lecture native plus fluide.
- **Hôte NAS :** idéal pour une bibliothèque personnelle toujours disponible, avec un peu de latence attendue pendant la navigation ou l'ouverture de pages non mises en cache.
- **Le CPU du NAS compte :** indexation d'archives, décompression, miniatures et préparation de la page suivante utilisent le processeur. Un processeur de bureau puissant fait souvent une plus grande différence que le remplacement d'un HDD seul.
- **HDD contre SSD/NVMe :** un SSD ou cache NVMe peut améliorer les lectures à froid et répétées, mais ne transforme pas un CPU NAS faible en Mac ou PC récent.
- **Mode BD continu :** les pages se chargent progressivement. Un court intervalle lors de la préparation d'une prochaine page non mise en cache peut être normal sur un NAS.

BiblioFuse met les pages préparées en cache et commence à préparer les pages suivantes sur le serveur. La première visite d'une grande archive peut néanmoins être plus lente que les suivantes.

## Avant de commencer

Vous avez besoin :

- d'un hôte Intel/AMD 64 bits ou ARM64 avec Docker Compose, ou d'un modèle Synology avec Container Manager ;
- d'un dossier persistant pour la configuration BiblioFuse ;
- d'un dossier jetable pour le cache ;
- d'un dossier contenant vos livres ;
- du port TCP `7343` disponible pour l'interface web.

Sur Synology, créez des dossiers similaires à :

```text
/volume1/docker/bibliofuse/config
/volume1/docker/bibliofuse/cache
/volume1/books
```

Vos chemins peuvent être différents. BiblioFuse n'a jamais besoin d'accès en écriture au dossier de livres.

## Installer avec Docker Compose

1. Téléchargez `docker/compose.yaml` et `docker/.env.example` depuis ce dépôt.
2. Copiez `.env.example` vers `.env`.
3. Modifiez `.env` et définissez `CONFIG_PATH`, `CACHE_PATH`, `LIBRARY_PATH`, `PUID`, `PGID` et `BF_TIME_ZONE`. `LIBRARY_PATH` est votre propre dossier hôte ; BiblioFuse ne suppose jamais un nom ni chemin personnel.
4. Démarrez BiblioFuse :

```sh
docker compose up -d
```

5. Ouvrez `http://<server-ip>:7343`.
6. Créez le premier compte administrateur.
7. Ouvrez Réglages → **Attacher la bibliothèque**, choisissez l'emplacement **Bibliothèque** affiché ou un sous-dossier, puis sélectionnez **Actualiser**.

Le fichier Compose rend votre `LIBRARY_PATH` disponible sous le nom convivial **Bibliothèque**. Une installation neuve n'attache aucun dossier automatiquement : le choix d'un dossier dans Réglages contrôle ce que BiblioFuse indexe. Le conteneur ne peut pas trouver un dossier hôte qui n'a pas été monté dans Compose.

Consultez le [guide d'installation Docker](docs/docker-install.fr.md) pour les mises à jour, sauvegardes, autorisations, accès distant et dépannage.

## Installer avec Synology Container Manager

Utilisez `synology/compose.yaml` comme projet Container Manager. Définissez les variables du projet sur des chemins Synology absolus, puis démarrez le projet et ouvrez :

```text
http://<nas-ip>:7343
```

Le projet Synology monte DSM `/volume1` en lecture seule et liste automatiquement les vrais dossiers partagés que le `PUID`/`PGID` choisi peut lire. Il n'attache aucun dossier tant que l'administrateur n'en choisit pas un dans Réglages. Les dossiers de configuration et cache doivent être accessibles en écriture par cet utilisateur/groupe numérique.

Les dossiers de bibliothèque peuvent être modifiés, désactivés ou détachés dans Réglages. Détacher un dossier, même le dernier, efface le catalogue BiblioFuse de cette racine, ses métadonnées et sa progression de lecture sans supprimer les livres ou dossiers.

Consultez le [tutoriel Synology](docs/synology-container-manager.fr.md) pour une procédure complète.

N'exécutez pas le projet Docker et le paquet Synology natif sur le même NAS en même temps. Les deux utilisent intentionnellement les ports `7342` et `7343` pour le même service Wi-Fi local ; choisissez une seule méthode d'hébergement par NAS.

## État du paquet Synology natif

Le paquet générique x86-64 s'exécute avec le compte DSM restreint `BiblioFuseNAS` et ne crée, ne déplace ni ne suppose aucun dossier de bibliothèque. Un guide Réglages explique comment accorder à ce compte un accès en lecture seule à un dossier partagé existant. Le sélecteur de dossiers ne liste alors que les partages que le compte peut réellement lire ; Attacher et Détacher ne suppriment jamais de fichiers de livres.

Consultez le [guide du paquet Synology natif](docs/synology-package.fr.md) pour l'installation et les permissions.

## Actualisation de la bibliothèque

**Actualiser** vérifie tout l'arborescence pour les ajouts, suppressions et renommages, tout en réindexant seulement les livres nouveaux ou modifiés. Il peut être utilisé après la copie de nouveaux livres dans le dossier monté.

Dans Réglages, l'actualisation automatique est désactivée par défaut. Vous pouvez choisir :

- quotidienne à une heure choisie ; ou
- hebdomadaire à un jour et une heure choisis.

Les heures sont disponibles par intervalles de 30 minutes et utilisent `BF_TIME_ZONE` configuré pour le conteneur.

## Formats pris en charge par le lecteur web

- BD et archives d'images : CBZ, ZIP, CBR et RAR
- Livres réadaptables : EPUB
- Texte brut : TXT, TEXT et Markdown

Les archives de BD prennent en charge les modes paginé et défilement continu. La position de lecture EPUB et texte est stockée par l'interface web. Le PDF n'est pas actuellement inclus dans le lecteur web Docker.

## Mots de passe et sécurité

Le premier mot de passe administrateur navigateur doit comporter au moins 12 caractères. Conservez-le dans un gestionnaire de mots de passe.

- Le port `7343` est l'interface navigateur. Gardez-le sur un LAN de confiance ou derrière un proxy inverse HTTPS de confiance.
- N'exposez pas `7343` directement par redirection de port du routeur.
- Le port `7342` est l'API HTTPS épinglée du serveur pour client natif. Sur le Wi-Fi local, iOS et visionOS le découvrent via Bonjour.
- Le port `7341` est réservé et ne doit jamais être publié.

Il n'existe pas de récupération de mot de passe par e-mail. Pour Docker, recréer uniquement le conteneur ne réinitialise pas le mot de passe car `/config` est persistant ; utilisez la réinitialisation usine explicite documentée après avoir effectué une sauvegarde. Pour le paquet Synology, désinstaller et réinstaller réinitialise toutes les données BiblioFuse sans toucher à la bibliothèque.

## Sauvegardes et mises à jour

- Sauvegardez l'intégralité du dossier de configuration persistant.
- Le dossier de cache est jetable et n'a pas besoin de sauvegarde.
- La bibliothèque reste dans votre propre dossier hôte/NAS et n'est jamais stockée dans le conteneur.
- Avant toute mise à jour, utilisez Réglages pour télécharger une sauvegarde BiblioFuse et conservez une copie du dossier de configuration.
- Mettez à jour avec :

```sh
docker compose pull
docker compose up -d
```

Supprimer ou recréer le conteneur ne supprime pas votre compte ni catalogue tant que le même dossier de configuration reste monté.

Détacher une bibliothèque est différent : cela purge le catalogue BiblioFuse de cette racine, ses annotations et sa progression de lecture tout en laissant intacts les fichiers de bibliothèque en lecture seule.

## Téléchargements et versions

Les canaux de diffusion publics prévus sont :

- **Image Docker :** `ghcr.io/mlt-solutions/bibliofuse-nas:0.1.11`
- **Modèles Docker et Synology Container Manager :** ce dépôt
- **Notes de version et ressources téléchargeables :** GitHub Releases
- **Synology `.spk` :** GitHub Releases (`x86-64` DSM 7)
- **Présentation du produit et apps natives :** [bibliofuse.com](https://bibliofuse.com)

L'image Docker est une bêta publique. Le `.spk` x86-64 natif est disponible pour DSM 7. Les deux utilisent la découverte Bonjour du Wi-Fi local pour le streaming natif ; aucune route native Docker Tailscale/manuelle n'est fournie.

## Aide

Commencez par :

- [Installation et opérations Docker](docs/docker-install.fr.md)
- [Tutoriel Synology Container Manager](docs/synology-container-manager.fr.md)
- [État du paquet Synology natif](docs/synology-package.fr.md)
- [Guide des performances](docs/performance.md)
- [Canaux de publication et limites des apps natives](docs/releases-and-native-apps.md)

Lorsque vous demandez de l'aide, indiquez le modèle NAS/hôte, l'architecture CPU, la version Docker, le format de livre et les journaux récents du conteneur. Ne publiez jamais mots de passe, clés privées, noms de fichiers de bibliothèque que vous considérez sensibles, ni le contenu du dossier de configuration.
