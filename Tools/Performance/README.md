# Performancecontroles

Uitgevoerd op 11 november 2026 met Xcode 27.2. Vergelijking met de iOS-code vóór de performancewijzigingen; bestaande styling en Firebase-configuratie zijn gelijk gehouden.

## Gemeten resultaten

| Onderdeel | Voor | Na |
| --- | --- | --- |
| Release `.app`, arm64, on-gecomprimeerde bestanden | 41.464.063 bytes | 9.574.565 bytes (77% kleiner) |
| Gekoppelde Firebase-producten | 22 | 6 |
| Eén voorbeeldfoto: origineel versus kaartthumbnail | 68.807 bytes, 1200 × 800 | 13.145 bytes, 384 × 256 (81% minder bytes) |
| Zoekbenchmark, ronde 1 | 0,676 s | 0,139 s |
| Zoekbenchmark, ronde 2 | 0,629 s | 0,137 s |
| Zoekbenchmark, ronde 3 | 0,620 s | 0,131 s |

De zoekbenchmark gebruikt 12.000 voorbeeldklussen, 10 zoektermen en vier resultaatlezingen per schermupdate, zoals de oude `HomeView`. Dit is een CPU-benchmark op de Mac; geen meting van iPhone-schermlatentie. De nieuwe zoekindex kostte ongeveer 45 ms om eenmalig op te bouwen voor deze 12.000 klussen. De werkelijke app heeft momenteel 12 voorbeeldklussen.

De fotometing betreft één identieke Picsum-seed. Netwerkduur is niet als snelheidswinst gerapporteerd: netwerkvariatie maakt die vergelijking onbetrouwbaar. Alleen Picsum-URL's worden aangepast; andere afbeeldingsservers en URL-queryparameters blijven intact. Detailfoto's kunnen de oorspronkelijke resolutie laden.

## Wijzigingen

- Ongebruikte Firebase-producten verwijderd. Firebase Auth/Core, App Check, Analytics, Crashlytics en Performance blijven gekoppeld. Firebase Console, backendinstellingen en Klusmaat Web zijn niet gewijzigd.
- Afbeeldingen worden opgevraagd in resolutiebuckets; de geheugen-cache heeft een kostenbudget van 32 MiB en maximaal 150 afbeeldingen. Gedecodeerde pixels tellen mee in de kosten. `NSCache` beheert automatische uitzetting; het budget is geen harde procesgeheugenlimiet.
- Zichtbare consumenten delen dezelfde download. Annuleren van de laatste consument annuleert ook de onderliggende URLSession-taak. HTTP-fouten en ongeldige afbeeldingen worden niet in de geheugencache opgeslagen.
- `JobImage` koppelt de geladen afbeelding en de taak aan zowel URL als resolutie, zodat een hergebruikte view geen oude afbeelding toont.
- Zoektekst en sorteringen worden vooraf voorbereid. Resultaten veranderen bij wijzigingen van zoekterm, filters of sortering; UI-hertekeningen lezen de opgeslagen resultaten. Het aparte resultatenscherm berekent één resultaatarray per body-evaluatie.

## Opnieuw controleren

```sh
# Gedragstests plus zoekbenchmark:
Tools/Performance/check.sh

# Ook de UIKit-afbeeldingscontroles, op een reeds opgestarte simulator:
SIMULATOR_UDID=<simulator-UDID> Tools/Performance/check.sh
```

Het script gebruikt tijdelijke bestanden en kopieën van de echte productiecode. De vijf Swift Testing-gedragstests controleren filters, sorteringen, zoekresultaten en opgeslagen activiteit. De zes afbeeldingscontroles gebruiken een lokale URLProtocol-fixture: resolutie en URL-behoud, gedeelde requests, gedeeltelijke annulering, volledig annuleren/herstarten, caching, HTTP-fouten en ongeldige data.

```sh
xcodebuild -project Klusmaat.xcodeproj -scheme Klusmaat \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' \
  -configuration Debug -derivedDataPath /tmp/klusmaat-check \
  CODE_SIGNING_ALLOWED=NO build
```

## Meten op een echte iPhone

De Release-builds voor de aangesloten iPhone 16 Pro slagen. Instruments kon bij de eerste poging de App Launch-meting niet starten (`Timed out waiting for device to boot`), ondanks een gekoppeld toestel met Developer Mode. Opstarttijd, toetsenbordrespons en scrollhaperingen zijn daarom nog niet als voor/na-resultaat gemeld. Een kleinere build en de CPU-benchmark bewijzen geen verbetering in deze interacties.

Voor vervolgmetingen: houd de iPhone ontgrendeld en verbonden, selecteer dezelfde Release-configuratie en gebruik de Instruments-templates App Launch, Time Profiler en Animation Hitches. Vergelijk dezelfde zoekopdrachten, dezelfde scrollroute en dezelfde toetsenbordactie vóór en na, met dezelfde cachetoestand en meerdere herhalingen.
