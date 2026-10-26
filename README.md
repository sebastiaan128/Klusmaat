# Klusmaat

iOS-app gebouwd met SwiftUI.

- **Minimum iOS-versie:** iOS 17
- **Taal:** Swift, SwiftUI
- **Tests:** Swift Testing

## Bouwen

1. Open `Klusmaat.xcodeproj` in Xcode (16 of nieuwer).
2. Kies het scheme **Klusmaat** en een iPhone-simulator.
3. Bouwen met **Cmd+B**, starten met **Cmd+R**, testen met **Cmd+U**.

Het project gebruikt gesynchroniseerde folders: bestanden die je in `Klusmaat/` of `KlusmaatTests/` zet, worden automatisch door Xcode opgepikt.

## Mappenstructuur

```
Klusmaat/
  App/            Entry point (KlusmaatApp) en het eerste scherm (RootView).
  Features/       Eén map per feature met de bijbehorende schermen.
    Klussen/      Klussen bekijken, plaatsen en beheren.
    Profiel/      Het profiel van de gebruiker.
    Berichten/    Berichten tussen gebruikers.
    Gereedschap/  Gereedschap delen en lenen.
  Models/         Datamodellen zoals Klus en Gebruiker.
  Services/       Logica die met externe systemen praat, zoals authenticatie en opslag.
  Shared/
    Components/   Herbruikbare SwiftUI-views die door meerdere features gebruikt worden.
    Extensions/   Extensions op bestaande types (bijv. String, Date, View).
  Resources/      Assets zoals kleuren, afbeeldingen en het app-icoon.
KlusmaatTests/    Unit tests met Swift Testing.
```
