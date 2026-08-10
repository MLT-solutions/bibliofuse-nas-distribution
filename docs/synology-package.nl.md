[English](synology-package.md) | [Español](synology-package.es.md) | [Français](synology-package.fr.md) | [Nederlands](synology-package.nl.md) | [Português](synology-package.pt.md) | [Русский](synology-package.ru.md) | [简体中文](synology-package.zh-CN.md) | [日本語](synology-package.ja.md) | [한국어](synology-package.ko.md) | [Bahasa Indonesia](synology-package.id.md) | [Bahasa Melayu](synology-package.ms.md)

# Native Synology-pakket

## Huidige status

> **Belangrijk:** Installeer `0.1.0-0050` alleen met [BiblioFuse voor iOS 2.1.8 (105) of nieuwer](https://appstoreconnect.apple.com/teams/94c57d4b-571f-4fc1-bee8-61d285a65029/apps/6758330093/testflight/visionos/768998c3-02f2-45e6-b22a-30599d0485ae).

Het x86-64-pakket `0.1.0-0050` is de DSM 7-release. Het biedt een eenvoudige toegangsstroom zonder root:

- geen naam van gedeelde map, NAS-adres of bibliotheekpad is in het pakket ingebouwd;
- boeken blijven in hun bestaande DSM-gedeelde mappen;
- BiblioFuse kan zichzelf geen toegang geven en DSM-machtigingen niet wijzigen;
- Instellingen leggen uit hoe u het beperkte pakketaccount alleen-lezen-toegang geeft;
- Koppelen en Loskoppelen regelen alleen indexering en verwijderen nooit bibliotheekbestanden.

Het pakket is geen container. Package Center beheert de levenscyclus, het hoofdmenupictogram en het beperkte interne account.

## Browsertalen

Kies in Instellingen **Taal** om de systeemtaal te volgen of Engels, Spaans, Frans, Nederlands, Portugees, Russisch, Vereenvoudigd Chinees, Japans, Koreaans, Indonesisch of Maleis te kiezen. De keuze wordt alleen in deze browser bewaard en blijft behouden bij pakketupgrades.

## Installeren en toegang verlenen

1. Installeer de x86-64-`.spk` via Package Center → Handmatige installatie.
2. Open BiblioFuse NAS en maak een beheerder met minimaal 12 tekens.
3. Open Instellingen → **De 6 stappen tonen**, of volg ze hier:
   1. Open DSM **Configuratiescherm** → **Gedeelde map**.
   2. Kies de bestaande gedeelde map met uw boeken en selecteer **Bewerken**.
   3. Open **Machtigingen**.
   4. Verander de vervolgkeuze naar **Interne systeemgebruiker**.
   5. Zoek `BiblioFuseNAS`, geef **Alleen-lezen** en sla op.
   6. Ga terug naar BiblioFuse → **Bibliotheek koppelen** → **Toegang vernieuwen**, en kies daarna de share of een boeksubmap.
4. Kies **Boeken vernieuwen**.

U hoeft geen `/volume1/...`- of `/var/packages/...`-pad te typen. Na toegang verlenen is geen pakket-herstart nodig.

## Levenscyclus van gegevens

- **Uitschakelen:** behoud de catalogus en laat de koppeling later weer inschakelen.
- **Loskoppelen:** wis catalogus, metadata en leesvoortgang van die BiblioFuse-koppeling.
- **Pakket bijwerken:** behoud account, certificaatidentiteit, instellingen, catalogus en cache.
- **Pakket verwijderen:** wis alle BiblioFuse-eigen account-, wachtwoord-, identiteit-, instellingen-, catalogus-, log- en cachegegevens.
- **Bibliotheek:** blijft altijd buiten BiblioFuse-pakketgegevens en wordt nooit verwijderd.

Een upgrade vanaf het privé-v8-testpakket migreert zijn pakketshare-alias naar het normale DSM-volumepad met behoud van rootidentiteit.

## Netwerk en huidige ondersteuningsgrens

- `7343/tcp`: gratis browserbibliotheek en lezer op het vertrouwde LAN.
- `7342/tcp`: vastgezette-HTTPS-listener voor native clients.
- `7341/tcp`: gereserveerd en nooit gebruikt.

Bij het starten leidt het pakket het actieve privé-LAN-adres af van DSM en adverteert Bonjour rechtstreeks vanaf de NAS-host. Als DSM Tailscale actief is, wordt het `tailscale0`-adres als optionele handmatige verbindingssuggestie opgenomen. Grote native JSON-antwoorden bevatten `Content-Length` voor compatibiliteit met het uitgebrachte Apple-transport met vastzetting.

Koppelen op lokaal Wi-Fi met uitgebrachte iOS-/visionOS-apps wordt ondersteund via Bonjour en vastgezette HTTPS. Native streaming blijft onderworpen aan de Premium-grens van de native app.

## Architectuur

Het initiële pakket ondersteunt Synology x86-64. ARM64 is nog niet gebouwd en getest. Controleer de CPU-architectuur van uw NAS vóór het downloaden van een release.
