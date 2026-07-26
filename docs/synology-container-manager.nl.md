# Handleiding Synology Container Manager

[English](synology-container-manager.md) | [Español](synology-container-manager.es.md) | [Français](synology-container-manager.fr.md) | [Nederlands](synology-container-manager.nl.md) | [Português](synology-container-manager.pt.md) | [Русский](synology-container-manager.ru.md) | [简体中文](synology-container-manager.zh-CN.md) | [日本語](synology-container-manager.ja.md) | [한국어](synology-container-manager.ko.md) | [Bahasa Indonesia](synology-container-manager.id.md) | [Bahasa Melayu](synology-container-manager.ms.md)

Deze handleiding installeert de gratis Docker-server en webinterface via Container Manager. Zie voor het afzonderlijk geteste native DSM-pakket de [Synology-pakkethandleiding](synology-package.nl.md).

## Vereisten

- DSM 7 met Container Manager
- Een 64-bits Intel/AMD- of ARM64-model dat door de gepubliceerde image wordt ondersteund
- Toestemming om gedeelde mappen en Container Manager-projecten te maken

## 1. Mappen maken

Maak in File Station het volgende:

```text
docker/bibliofuse/config
docker/bibliofuse/cache
```

Het project koppelt DSM `/volume1` alleen-lezen. Instellingen toont de daadwerkelijke gedeelde mappen die het geconfigureerde DSM-account kan lezen; geen daarvan wordt automatisch gekoppeld.

## 2. De containergebruiker kiezen

De container moet naar config/cache kunnen schrijven en de bibliotheek kunnen lezen. Gebruik de numerieke UID en GID van een speciaal DSM-account met die rechten. Via SSH:

```sh
id <username>
```

De standaardwaarden `1026:100` zijn slechts voorbeelden en komen mogelijk niet overeen met uw NAS.

## 3. Het project maken

1. Download `synology/compose.yaml`.
2. Open Container Manager → Project → Create.
3. Kies een projectnaam, zoals `bibliofuse`.
4. Upload of plak het Compose-bestand.
5. Stel in:
   - `CONFIG_PATH`, bijvoorbeeld `/volume1/docker/bibliofuse/config`
   - `CACHE_PATH`, bijvoorbeeld `/volume1/docker/bibliofuse/cache`
   - `PUID` en `PGID`
   - `BF_TIME_ZONE`, bijvoorbeeld `Asia/Kuala_Lumpur`
6. Bouw/start het project.

## 4. Eerste configuratie

Open:

```text
http://<nas-ip>:7343
```

Maak een beheerderswachtwoord van ten minste 12 tekens. Kies in Instellingen **Attach library**, selecteer een weergegeven gedeelde DSM-map of submap met boeken en kies vervolgens Refresh. U hoeft geen DSM- of containerpad in te voeren. De kiezer sluit onleesbare shares uit op basis van de gekozen container-UID/GID.

Roots kunnen worden gewijzigd, uitgeschakeld of verwijderd. Uitschakelen behoudt catalogusgegevens. Verwijderen wist de BiblioFuse-catalogus, metadata en leesvoortgang van die root zonder bestanden of mappen te verwijderen; het verwijderen van de laatste root laat een geldige lege bibliotheek achter.

## 5. Lezen en vernieuwen

Refresh controleert de volledige gekoppelde boom en indexeert nieuwe, gewijzigde, hernoemde of verwijderde boeken. Automatisch vernieuwen is standaard uitgeschakeld; Instellingen kan een dagelijkse of wekelijkse vernieuwing plannen.

De doorlopende stripmodus laadt pagina's geleidelijk. Op een DS923+ of vergelijkbare NAS kan er nog steeds een korte laadvertraging optreden voor niet-gecachete archiefpagina's. Een Mac- of pc-host biedt doorgaans vloeiender native streamen omdat de CPU pagina's sneller kan decomprimeren en voorbereiden.

## 6. Back-up en upgrade

- Neem de configuratiemap op in Hyper Backup.
- De cache kan worden uitgesloten.
- Download vóór de upgrade een BiblioFuse-back-up in Instellingen.
- Bewaar de vorige configuratieback-up, omdat databasemigraties mogelijk alleen voorwaarts zijn.
- Haal de nieuwe image op en maak het project opnieuw zonder mapkoppelingen te wijzigen.

Kies nooit een verwijderoptie die de gekoppelde configuratie- of bibliotheekmappen wist.

Voor een fabrieksreset van Container Manager stopt u het project, maakt u een back-up van en hernoemt u de geconfigureerde config- en cachemappen, maakt u nieuwe lege mappen met de oorspronkelijke namen en rechten, en start u vervolgens opnieuw. Neem de bibliotheekmap nooit op in deze opschoning.

## 7. Netwerkgrens

- `7343`: gratis browserinterface op een vertrouwd LAN
- `7342`: vastgezette HTTPS-API voor native clients, via Bonjour ontdekt op lokale Wi-Fi
- `7341`: niet publiceren

Container Manager en de native `.spk` koppelen via Bonjour op lokale Wi-Fi met uitgebrachte iOS/visionOS-apps. Native streamen blijft onderworpen aan de Premium-functiegrens van de native app; Docker biedt geen handmatige/Tailscale-route voor native clients.

Voer dit Container Manager-project niet naast het native BiblioFuse Synology-pakket op dezelfde NAS uit. Beide services binden `7342` en `7343`; kies één installatiemethode.
