[English](README.md) | [Español](README.es.md) | [Français](README.fr.md) | [Nederlands](README.nl.md) | [Português](README.pt.md) | [Русский](README.ru.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Bahasa Indonesia](README.id.md) | [Bahasa Melayu](README.ms.md)

<p align="center"><img src="assets/bibliofuse-logo.png" alt="BiblioFuse-logo" width="180"></p>

<h1 align="center">BiblioFuse NAS</h1>

<p align="center">Een privé, zelfgehoste ebook- en stripbibliotheek voor Docker en Synology NAS.<br><a href="https://bibliofuse.com">BiblioFuse-website</a></p>

## Gratis hosten en lezen in uw browser

BiblioFuse NAS is gratis te hosten in Docker of Synology Container Manager. De webbibliotheek en browserlezer zijn ook gratis; er is geen abonnement nodig voor de Docker-server of webinterface.

Deze openbare distributierepository bevat installatiebestanden en documentatie. De broncode van de BiblioFuse-server wordt afzonderlijk onderhouden en is hier niet opgenomen.

## Productstatus

| Host of client | Beschikbaarheid | Lees- en verbindingsondersteuning |
| --- | --- | --- |
| Docker / Synology Container Manager | Publieke bèta `0.1.10` | Gratis server, browserinterface en lokaal Wi-Fi native streamen |
| BiblioFuse-weblezer | Inbegrepen | CBZ, ZIP, CBR, RAR, EPUB, TXT, TEXT en Markdown |
| Uitgebrachte iOS-/visionOS-apps met Docker | Ondersteund op lokaal Wi-Fi | Bonjour-detectie en vastgezette HTTPS-streaming; Premium wordt door de native app afgedwongen |
| Synology Package Center-app (`.spk`) | Openbare x86-64-release | Niet-rootpakket met begeleide alleen-lezen-toegang tot bestaande DSM-gedeelde mappen |
| iOS-/visionOS-native streaming vanaf Synology-app | Ondersteund op lokaal Wi-Fi | Bonjour-detectie en vastgezette HTTPS-streaming; Premium wordt door de native app afgedwongen |
| BiblioFuse Mac-/PC-host | Afzonderlijk product | Aanbevolen wanneer de soepelste native streaming prioriteit heeft |

Docker en de browserlezer blijven gratis. Native streaming is een Premium-functie van de iOS-/visionOS-app op hetzelfde lokale Wi-Fi-netwerk.

## Browsertalen

De browserapp kan de systeemtaal volgen of in Instellingen worden ingesteld op Engels, Spaans, Frans, Nederlands, Portugees, Russisch, Vereenvoudigd Chinees, Japans, Koreaans, Indonesisch of Maleis. Deze keuze blijft in de browser en wijzigt geen serverconfiguratie, boekmetadata of native clients.

## Prestatieverwachtingen

Een altijd actieve NAS is handig, privé en energiezuinig, maar bereidt strip-/archiepagina's normaal niet zo snel voor als een moderne Mac of PC.

- **Mac- of PC-host:** beste keuze voor de soepelste native leeservaring.
- **NAS-host:** ideaal voor een altijd beschikbare persoonlijke bibliotheek, met enige vertraging bij bladeren of niet-gecachete pagina's.
- **NAS-CPU telt:** archiefindexering, decompressie, miniaturen en voorbereiding van de volgende pagina zijn CPU-werk.
- **HDD versus SSD/NVMe:** SSD of NVMe-cache kan koude en herhaalde lezingen verbeteren, maar maakt een lichte NAS-CPU geen moderne Mac of PC.
- **Doorlopende stripmodus:** pagina's laden geleidelijk; een korte pauze voor een volgende niet-gecachete pagina kan normaal zijn.

BiblioFuse cached voorbereide pagina's en bereidt volgende pagina's op de server voor. Het eerste bezoek aan een groot archief kan nog steeds trager zijn.

## Voordat u begint

U hebt nodig:

- een 64-bits Intel/AMD- of ARM64-host met Docker Compose, of een Synology-model met Container Manager;
- één persistente map voor BiblioFuse-configuratie;
- één wegwerpmap voor cache;
- een map met uw boeken;
- TCP-poort `7343` beschikbaar voor de webinterface.

Maak op Synology bijvoorbeeld:

```text
/volume1/docker/bibliofuse/config
/volume1/docker/bibliofuse/cache
/volume1/books
```

Uw paden mogen verschillen. BiblioFuse heeft nooit schrijftoegang tot de boekmap nodig.

## Installeren met Docker Compose

1. Download `docker/compose.yaml` en `docker/.env.example` uit deze repository.
2. Kopieer `.env.example` naar `.env`.
3. Bewerk `.env` en stel `CONFIG_PATH`, `CACHE_PATH`, `LIBRARY_PATH`, `PUID`, `PGID` en `BF_TIME_ZONE` in. `LIBRARY_PATH` is uw eigen hostmap.
4. Start BiblioFuse:

```sh
docker compose up -d
```

5. Open `http://<server-ip>:7343`.
6. Maak de eerste beheerdersaccount.
7. Open Instellingen → **Bibliotheek koppelen**, kies de getoonde **Bibliotheek**-locatie of een submap en selecteer **Vernieuwen**.

Compose maakt de gekozen `LIBRARY_PATH` beschikbaar als **Bibliotheek**. Een nieuwe installatie koppelt geen mappen automatisch; uw keuze in Instellingen bepaalt wat BiblioFuse indexeert. Een niet in Compose aangekoppelde hostmap kan de container niet vinden.

Zie de [Docker-installatiegids](docs/docker-install.nl.md) voor updates, back-ups, rechten, externe toegang en probleemoplossing.

## Installeren met Synology Container Manager

Gebruik `synology/compose.yaml` als Container Manager-project. Stel de projectvariabelen in op absolute Synology-paden, start het project en open:

```text
http://<nas-ip>:7343
```

Het Synology-project koppelt DSM `/volume1` alleen-lezen en toont automatisch de gedeelde mappen die de gekozen `PUID`/`PGID` kan lezen. Het koppelt niets totdat de beheerder een map kiest in Instellingen. Config- en cachemappen moeten schrijfbaar zijn voor die numerieke gebruiker/groep.

Bibliotheekmappen kunnen in Instellingen worden gewijzigd, uitgeschakeld of losgekoppeld. Loskoppelen, ook van de laatste map, wist BiblioFuse-catalogus, metadata en leesvoortgang van die root zonder boeken of mappen te verwijderen.

Zie de [Synology-handleiding](docs/synology-container-manager.nl.md) voor de volledige uitleg.

Gebruik het Docker-project en het native Synology-pakket niet tegelijk op dezelfde NAS. Beide gebruiken bewust poorten `7342` en `7343` voor dezelfde lokale Wi-Fi-service; kies één hostmethode per NAS.

## Status native Synology-pakket

Het generieke x86-64-pakket draait als het beperkte DSM-account `BiblioFuseNAS` en maakt, verplaatst of veronderstelt geen bibliotheekmap. Instellingen leggen uit hoe u dit account alleen-lezen-toegang geeft tot een bestaande gedeelde map. De mapkiezer toont alleen shares die het account echt kan lezen; Koppelen en Loskoppelen verwijderen nooit boekbestanden.

Zie de [native Synology-pakketgids](docs/synology-package.nl.md) voor installatie en machtigingen.

## Bibliotheek vernieuwen

**Vernieuwen** controleert de hele mapboom op toevoegingen, verwijderingen en hernoemingen, maar herindexeert alleen nieuwe of gewijzigde boeken. Gebruik dit gerust na het kopiëren van boeken naar de gekoppelde map.

Automatisch vernieuwen is standaard uitgeschakeld. Kies dagelijks op een tijdstip of wekelijks op een dag en tijdstip. Tijden hebben intervallen van 30 minuten en gebruiken de voor de container ingestelde `BF_TIME_ZONE`.

## Ondersteunde weblezerformaten

- Strips en afbeeldingsarchieven: CBZ, ZIP, CBR en RAR
- Herformatteerbare ebooks: EPUB
- Platte tekst: TXT, TEXT en Markdown

Striparchieven ondersteunen gepagineerd en doorlopend lezen. EPUB- en tekstpositie wordt door de webinterface opgeslagen. PDF is nu niet opgenomen in de Docker-weblezer.

## Wachtwoorden en beveiliging

Het eerste browserbeheerderswachtwoord moet minstens 12 tekens bevatten. Bewaar het in een wachtwoordmanager.

- Poort `7343` is de browserinterface; houd deze op een vertrouwd LAN of achter een vertrouwde HTTPS-reverse-proxy.
- Stel `7343` niet rechtstreeks bloot met routerportforwarding.
- Poort `7342` is de vastgezette native-client HTTPS-API. iOS en visionOS vinden deze op lokaal Wi-Fi via Bonjour.
- Poort `7341` is gereserveerd en mag nooit worden gepubliceerd.

Er is geen wachtwoordherstel per e-mail. Alleen de container opnieuw maken reset het Docker-wachtwoord niet omdat `/config` persistent is; gebruik na een back-up de gedocumenteerde expliciete fabrieksreset. Een Synology-pakket verwijderen en opnieuw installeren reset BiblioFuse-gegevens zonder de bibliotheek aan te raken.

## Back-ups en updates

- Maak een back-up van de hele persistente configmap.
- De cachemap is wegwerpbaar en hoeft niet te worden geback-upt.
- De bibliotheek blijft in uw eigen host-/NAS-map en staat nooit in de container.
- Download vóór een update een BiblioFuse-back-up in Instellingen en bewaar een kopie van de configmap.
- Update met:

```sh
docker compose pull
docker compose up -d
```

Container verwijderen of opnieuw maken verwijdert uw account of catalogus niet zolang dezelfde configmap gekoppeld blijft. Bibliotheek loskoppelen is anders: het wist catalogus, aantekeningen en leesvoortgang van die root, terwijl alleen-lezen-bibliotheekbestanden intact blijven.

## Downloads en releases

De bedoelde openbare releasekanalen zijn:

- **Docker-image:** `ghcr.io/mlt-solutions/bibliofuse-nas:0.1.10`
- **Docker- en Synology Container Manager-sjablonen:** deze repository
- **Versienotities en downloadbare assets:** GitHub Releases
- **Synology `.spk`:** GitHub Releases (`x86-64` DSM 7)
- **Productoverzicht en native apps:** [bibliofuse.com](https://bibliofuse.com)

De Docker-image is een publieke bèta. De native x86-64 `.spk` is beschikbaar voor DSM 7. Beide gebruiken lokale Wi-Fi-Bonjour-detectie voor native streaming; er is geen Docker Tailscale/handmatige native route.

## Hulp

Begin met:

- [Docker-installatie en gebruik](docs/docker-install.nl.md)
- [Synology Container Manager-handleiding](docs/synology-container-manager.nl.md)
- [Status native Synology-pakket](docs/synology-package.nl.md)
- [Prestatiegids](docs/performance.md)
- [Releasekanalen en native-appgrens](docs/releases-and-native-apps.md)

Vermeld bij hulpvragen NAS-/hostmodel, CPU-architectuur, Docker-versie, boekformaat en recente containerlogs. Plaats nooit wachtwoorden, privésleutels, gevoelige bibliotheekbestandsnamen of de inhoud van de configmap.
