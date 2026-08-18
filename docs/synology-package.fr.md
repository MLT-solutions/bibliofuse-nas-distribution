[English](synology-package.md) | [Español](synology-package.es.md) | [Français](synology-package.fr.md) | [Nederlands](synology-package.nl.md) | [Português](synology-package.pt.md) | [Русский](synology-package.ru.md) | [简体中文](synology-package.zh-CN.md) | [日本語](synology-package.ja.md) | [한국어](synology-package.ko.md) | [Bahasa Indonesia](synology-package.id.md) | [Bahasa Melayu](synology-package.ms.md)

# Paquet Synology natif

## État actuel

> **Important :** Installez `0.1.0-0056` uniquement avec [BiblioFuse pour iOS 2.1.8 (105) ou version ultérieure](https://appstoreconnect.apple.com/teams/94c57d4b-571f-4fc1-bee8-61d285a65029/apps/6758330093/testflight/visionos/768998c3-02f2-45e6-b22a-30599d0485ae).

Le paquet x86-64 `0.1.0-0056` est la version DSM 7. Il fournit un flux d'accès simple sans root :

- aucun nom de dossier partagé, adresse NAS ou chemin de bibliothèque n'est intégré au paquet ;
- les livres restent dans leurs dossiers partagés DSM existants ;
- BiblioFuse ne peut pas s'accorder d'accès ni modifier les permissions DSM ;
- Réglages explique comment accorder au compte de paquet restreint un accès en lecture seule ;
- Attacher et Détacher contrôlent seulement l'indexation et ne suppriment jamais les fichiers de bibliothèque.

Le paquet n'est pas un conteneur. Package Center gère le cycle de vie, l'icône du menu principal et le compte interne restreint.

## Langue du navigateur

Dans Réglages, choisissez **Langue** pour suivre la langue système ou sélectionner anglais, espagnol, français, néerlandais, portugais, russe, chinois simplifié, japonais, coréen, indonésien ou malais. La sélection est stockée uniquement dans ce navigateur et survit aux mises à niveau du paquet.

## Installer et accorder l'accès

1. Installez le `.spk` x86-64 via Package Center → Installation manuelle.
2. Ouvrez BiblioFuse NAS et créez un administrateur avec au moins 12 caractères.
3. Ouvrez Réglages → **Afficher les 6 étapes**, ou suivez-les ici :
   1. Ouvrez DSM **Panneau de configuration** → **Dossier partagé**.
   2. Sélectionnez le dossier partagé existant contenant vos livres et choisissez **Modifier**.
   3. Ouvrez **Permissions**.
   4. Modifiez la liste déroulante en **Utilisateur interne du système**.
   5. Trouvez `BiblioFuseNAS`, accordez **Lecture seule** et enregistrez.
   6. Revenez à BiblioFuse → **Attacher la bibliothèque** → **Actualiser l'accès**, puis choisissez le partage ou un sous-dossier de livres.
4. Sélectionnez **Actualiser les livres**.

Aucun chemin `/volume1/...` ou `/var/packages/...` ne doit être saisi. Aucun redémarrage de paquet n'est nécessaire après l'attribution de l'accès.

## Cycle de vie des données

- **Désactiver :** conserver le catalogue et permettre de réactiver l'attachement.
- **Détacher :** purger le catalogue BiblioFuse de cet attachement, ses métadonnées et sa progression de lecture.
- **Mettre le paquet à niveau :** conserver compte, identité de certificat, réglages, catalogue et cache.
- **Désinstaller le paquet :** effacer toutes les données BiblioFuse possédées : compte, mot de passe, identité, réglages, catalogue, journaux et cache.
- **Bibliothèque :** reste toujours hors des données du paquet BiblioFuse et n'est jamais supprimée.

Une mise à niveau depuis le paquet de test privé v8 migre son alias de partage de paquet vers le chemin de volume DSM normal en conservant l'identité de racine.

## Réseau et limites actuelles de prise en charge

- `7343/tcp` : bibliothèque et lecteur navigateur gratuits sur le LAN de confiance.
- `7342/tcp` : écouteur client natif HTTPS épinglé.
- `7341/tcp` : réservé et jamais utilisé.

Au démarrage, le paquet détermine l'adresse LAN privée active depuis DSM et annonce Bonjour directement depuis l'hôte NAS. Si DSM Tailscale est actif, l'adresse `tailscale0` est incluse comme suggestion facultative de connexion manuelle. Les grandes réponses JSON natives incluent `Content-Length` pour la compatibilité avec le transport épinglé Apple publié.

L'appairage Wi-Fi local avec les apps iOS/visionOS publiées est pris en charge via Bonjour et HTTPS épinglé. Le streaming natif reste soumis à la limite Premium de l'app native.

## Architecture

Le paquet initial prend en charge Synology x86-64. ARM64 reste non construit et non testé. Vérifiez l'architecture CPU de votre NAS avant de télécharger une version.
