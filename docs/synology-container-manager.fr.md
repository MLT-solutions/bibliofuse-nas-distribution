# Tutoriel Synology Container Manager

[English](synology-container-manager.md) | [Español](synology-container-manager.es.md) | [Français](synology-container-manager.fr.md) | [Nederlands](synology-container-manager.nl.md) | [Português](synology-container-manager.pt.md) | [Русский](synology-container-manager.ru.md) | [简体中文](synology-container-manager.zh-CN.md) | [日本語](synology-container-manager.ja.md) | [한국어](synology-container-manager.ko.md) | [Bahasa Indonesia](synology-container-manager.id.md) | [Bahasa Melayu](synology-container-manager.ms.md)

Ce guide installe le serveur Docker gratuit et son interface web avec Container Manager. Pour le paquet DSM natif testé séparément, consultez le [guide du paquet Synology](synology-package.fr.md).

## Prérequis

- DSM 7 avec Container Manager
- Un modèle Intel/AMD 64 bits ou ARM64 pris en charge par l'image publiée
- Le droit de créer des dossiers partagés et des projets Container Manager

## 1. Créer les dossiers

Dans File Station, créez :

```text
docker/bibliofuse/config
docker/bibliofuse/cache
```

Le projet monte DSM `/volume1` en lecture seule. Réglages liste les dossiers partagés réellement lisibles par le compte DSM configuré ; aucun n'est automatiquement attaché.

## 2. Choisir l'utilisateur du conteneur

Le conteneur doit écrire la configuration/le cache et lire la bibliothèque. Utilisez l'UID et le GID numériques d'un compte DSM dédié disposant de ces droits. Via SSH :

```sh
id <username>
```

Les valeurs par défaut `1026:100` ne sont que des exemples et peuvent ne pas correspondre à votre NAS.

## 3. Créer le projet

1. Téléchargez `synology/compose.yaml`.
2. Ouvrez Container Manager → Project → Create.
3. Choisissez un nom de projet tel que `bibliofuse`.
4. Importez ou collez le fichier Compose.
5. Définissez :
   - `CONFIG_PATH`, par exemple `/volume1/docker/bibliofuse/config`
   - `CACHE_PATH`, par exemple `/volume1/docker/bibliofuse/cache`
   - `PUID` et `PGID`
   - `BF_TIME_ZONE`, par exemple `Asia/Kuala_Lumpur`
6. Construisez/démarrez le projet.

## 4. Première configuration

Ouvrez :

```text
http://<nas-ip>:7343
```

Créez un mot de passe administrateur d'au moins 12 caractères. Dans Réglages, choisissez **Attach library**, sélectionnez un dossier partagé DSM affiché ou un sous-dossier de livres, puis choisissez Refresh. Aucun chemin DSM ou de conteneur n'est à saisir. Le sélecteur exclut les partages illisibles selon l'UID/GID de conteneur choisi.

Les racines peuvent être modifiées, désactivées ou supprimées. Désactiver conserve les données du catalogue. Supprimer purge le catalogue, les métadonnées et la progression de lecture BiblioFuse de cette racine sans effacer fichiers ou dossiers ; supprimer la dernière racine laisse une bibliothèque vide valide.

## 5. Lecture et actualisation

Refresh examine tout l'arbre monté et indexe les livres nouveaux, modifiés, renommés ou supprimés. L'actualisation automatique est désactivée par défaut ; Réglages peut planifier une actualisation quotidienne ou hebdomadaire.

Le mode BD continu charge les pages progressivement. Sur un DS923+ ou NAS similaire, un bref délai de chargement peut persister pour des pages d'archives non mises en cache. Un Mac ou PC offrira généralement un streaming natif plus fluide, car son processeur peut décompresser et préparer les pages plus vite.

## 6. Sauvegarde et mise à niveau

- Incluez le dossier de configuration dans Hyper Backup.
- Le cache peut être exclu.
- Téléchargez une sauvegarde BiblioFuse dans Réglages avant la mise à niveau.
- Conservez la sauvegarde de configuration précédente, car les migrations de base de données peuvent être uniquement ascendantes.
- Téléchargez la nouvelle image et recréez le projet sans modifier les mappages de dossiers.

Ne sélectionnez jamais une désinstallation qui supprime les dossiers de configuration ou de bibliothèque mappés.

Pour une réinitialisation d'usine Container Manager, arrêtez le projet, sauvegardez et renommez les dossiers de configuration et de cache, créez de nouveaux dossiers vides avec les noms et permissions d'origine, puis redémarrez. N'incluez jamais le dossier de bibliothèque dans ce nettoyage.

## 7. Limite réseau

- `7343` : interface navigateur gratuite sur un LAN de confiance
- `7342` : API HTTPS épinglée des clients natifs, découverte en Wi-Fi local avec Bonjour
- `7341` : ne pas publier

Container Manager et le `.spk` natif s'appairent avec les applications iOS/visionOS publiées sur le Wi-Fi local via Bonjour. Le streaming natif reste soumis à la limite Premium de l'application native ; Docker ne fournit pas de route native manuelle/Tailscale.

N'exécutez pas ce projet Container Manager à côté du paquet Synology BiblioFuse natif sur le même NAS. Les deux services lient `7342` et `7343` ; choisissez une seule méthode d'installation.
