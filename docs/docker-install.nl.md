[English](docker-install.md) | [Español](docker-install.es.md) | [Français](docker-install.fr.md) | [Nederlands](docker-install.nl.md) | [Português](docker-install.pt.md) | [Русский](docker-install.ru.md) | [简体中文](docker-install.zh-CN.md) | [日本語](docker-install.ja.md) | [한국어](docker-install.ko.md) | [Bahasa Indonesia](docker-install.id.md) | [Bahasa Melayu](docker-install.ms.md)

# Docker-installatie en gebruik

## Browsertalen

Open na de installatie Instellingen en kies **Taal**. De browser kan de systeemtaal volgen of Engels, Spaans, Frans, Nederlands, Portugees, Russisch, Vereenvoudigd Chinees, Japans, Koreaans, Indonesisch of Maleis gebruiken. De keuze wordt alleen in deze browser bewaard en heeft geen invloed op de container of bibliotheekmetadata.

## 1. Kies de mappen

BiblioFuse gebruikt drie hostmappen:

| Doel | Containerpad | Vereiste toegang | Back-up |
| --- | --- | --- | --- |
| Account, identiteit, catalogus en instellingen | `/config` | Lezen/schrijven | Ja |
| Voorbereide pagina's en miniaturen | `/cache` | Lezen/schrijven | Nee |
| Uw boekbibliotheek | `/library` | Alleen-lezen | Afzonderlijk back-uppen |

De containerpaden blijven gelijk. `CONFIG_PATH`, `CACHE_PATH` en `LIBRARY_PATH` kiezen de echte hostmappen. Docker kan een bibliotheekmap niet zelf vinden: koppel de map vóór de eerste start en kies daarna de te koppelen map in Instellingen.

## 2. Configureer Compose

Download de bestanden in `docker/`, kopieer `.env.example` naar `.env` en bewerk `.env`. Gebruik absolute paden voor een serverinstallatie.

Zoek onder Linux de numerieke gebruikers- en groeps-ID's met:

```sh
id
```

Stel `PUID` en `PGID` in op een identiteit die config/cache kan beschrijven en de bibliotheek kan lezen. BiblioFuse werkt zonder rootrechten.

## 3. Start en controleer

```sh
docker compose pull
docker compose up -d
docker compose ps
docker compose logs --tail=100 bibliofuse
```

Open `http://<server-ip>:7343`. Maak de beheerder en kies daarna **Bibliotheek koppelen** in Instellingen. De kiezer toont de geconfigureerde **Bibliotheek**-koppeling en submappen, maar een nieuwe installatie heeft geen gekoppelde root totdat u deze kiest en Vernieuwen selecteert.

Gebruik deze Docker-hostnetwerkservice niet naast het native Synology-pakket op dezelfde NAS: beide binden native HTTPS `7342` en browserinterface `7343`.

De eerste vernieuwing doorloopt de hele bibliotheek. Latere vernieuwingen controleren nog steeds de mapboom, maar hergebruiken ongewijzigde archiefmetadata.

## 4. Voeg een andere bibliotheekmap toe

Elke bibliotheekroot moet verwijzen naar een pad in de container. Voeg eerst een nieuwe alleen-lezen-koppeling toe aan `compose.yaml`, bijvoorbeeld:

```yaml
volumes:
  - "/srv/books:/library:ro"
  - "/srv/manga:/books/manga:ro"
environment:
  BF_LIBRARY_BROWSE_ROOTS: >-
    [{"name":"Library","path":"/library"},{"name":"Manga","path":"/books/manga"}]
```

Maak de container opnieuw en kies daarna Instellingen → Bibliotheek koppelen → **Manga**. Gebruikers typen noch `/books/manga` noch het hostpad `/srv/manga` in de webinterface.

Gebruik **Wijzigen** wanneer een gekoppelde map is hernoemd; BiblioFuse behoudt de catalogusidentiteit. **Uitschakelen** behoudt catalogusgegevens. **Loskoppelen** werkt ook voor de laatste root en wist catalogus, metadata en leesvoortgang van die root zonder bestanden of mappen te verwijderen.

## 5. Plan vernieuwen

Instellingen biedt Uitgeschakeld, Dagelijks en Wekelijks. Dagelijkse/wekelijkse tijden gebruiken intervallen van 30 minuten. Stel `BF_TIME_ZONE` in op een geldige IANA-tijdzone zoals `Asia/Kuala_Lumpur`.

## 6. Bijwerken

Gebruik bij voorkeur een genummerde imagetag voor gecontroleerde implementaties. Maak een back-up van `/config` en voer uit:

```sh
docker compose pull
docker compose up -d
docker image prune
```

`docker image prune` is optioneel en verwijdert ongebruikte imagegegevens, geen boeken.

## 7. Stoppen of verwijderen

```sh
docker compose down
```

Dit verwijdert de container en het netwerk, niet de hostmappen voor config, cache of bibliotheek.

Voor een expliciete fabrieksreset:

1. Voer `docker compose down` uit.
2. Maak een back-up van de hostmappen genoemd in `CONFIG_PATH` en `CACHE_PATH`.
3. Hernoem die twee mappen als bewaarde back-ups en maak nieuwe lege mappen met dezelfde oorspronkelijke namen en rechten.
4. Voer `docker compose up -d` uit en maak een nieuwe beheerder.

Hernoem, leeg of verwijder `LIBRARY_PATH` nooit. BiblioFuse koppelt deze alleen-lezen.

## Browserverbinding buiten het huis

Stuur poort `7343` niet rechtstreeks door vanaf een router. Gebruik een vertrouwde HTTPS-reverse-proxy met verificatie en een geldig certificaat, of open het LAN-adres via uw eigen VPN/Tailscale-netwerk.

Tailscale-browsertoegang gebruikt het Tailscale-adres van NAS/server gevolgd door `:7343`. Dit is browsertoegang; het voegt geen Docker-koppeling toe aan de momenteel uitgebrachte iOS- of visionOS-apps.

## Problemen oplossen

### De bibliotheekkiezer is leeg

- Controleer dat `LIBRARY_PATH` de echte hostmap is en vóór `docker compose up` is ingesteld.
- Voer `docker compose config` uit en controleer de `/library:ro`-koppeling.
- Controleer dat `PUID:PGID` de hostmap kan lezen.
- Maak de container opnieuw na een wijziging van een koppeling en open Instellingen opnieuw.

### Toegang geweigerd

De gekozen numerieke gebruiker/groep heeft geen toegang tot een gekoppelde map. Herstel de rechten van de hostmap of kies de juiste `PUID`/`PGID`; voer de container niet als root uit als eerste oplossing.

### Pagina's pauzeren tijdens lezen

Controleer CPU- en schijfactiviteit. Koude archiefpagina's moeten worden gedecomprimeerd en voorbereid. De server laadt volgende pagina's vooraf, maar zwakkere NAS-CPU's kunnen korte onderbrekingen tonen. Herhaald lezen profiteert van de persistente cache.

### Container start steeds opnieuw

```sh
docker compose ps
docker compose logs --tail=200 bibliofuse
```

Controleer ongeldige koppelingspaden, schrijfrechten voor config/cache, poortconflicten en een beschadigd of onvolledig `.env`.

### Beheerderswachtwoord verloren

Er is geen e-mailherstel. Alleen de container opnieuw maken reset het wachtwoord niet, omdat de verifier in `/config` staat. Gebruik bovenstaande expliciete fabrieksreset wanneer verlies van het bestaande BiblioFuse-account, de identiteit, catalogus en instellingen aanvaardbaar is; de bibliotheek zelf blijft intact.
