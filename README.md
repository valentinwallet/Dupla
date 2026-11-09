# Dupla

Ce dépôt héberge les bibliothèques Swift partagées de la suite. `DuplaDesign` est son design system SwiftUI. Le thème Dupla Atelier associe un fond papier blanc cassé, un bleu encre et des traits dessinés à main levée. Le package cible macOS 14 et iOS 17 ou plus récents.

## Ajouter le package

Dans Xcode, utilise **File → Add Package Dependencies… → Add Local…**, sélectionne le dossier `Dupla` qui contient `Package.swift`, puis ajoute le produit `DuplaDesign` à la cible de l’app. Pour utiliser une version publiée, ajoute l’URL Git de ce dépôt dans Xcode et sélectionne le produit `DuplaDesign`.

```swift
import DuplaDesign
import SwiftUI

struct DuplaExample: View {
    @State private var search = ""

    var body: some View {
        VStack(alignment: .leading, spacing: DuplaMetrics.large) {
            Text("Bibliothèque")
                .duplaTextStyle(.display)

            DuplaTextField("Rechercher une photo", text: $search, kind: .search)

            DuplaBadge("À publier", variant: .stamp)

            DuplaEmptyState("Aucune photo à afficher", motif: .flower) {
                Button("Importer une photo…") {
                    // Appeler l’action d’import de l’app.
                }
                .buttonStyle(.dupla(.outline))
            }
        }
        .padding(DuplaMetrics.section)
        .foregroundStyle(DuplaColors.text)
        .background(DuplaColors.paper)
    }
}
```

## Composants

- **Typographie** · `.display`, `.title` et `.note` utilisent Annie Use Your Telescope. `.label` et `.caption` utilisent IBM Plex Mono. Ajoute `weight: .semibold` ou `weight: .bold` à `.duplaTextStyle` pour choisir leur graisse. `.body` utilise la police système et accepte les mêmes graisses. Annie reste en Regular. Les polices et leurs licences OFL sont intégrées au package.
- **Boutons** · Applique `.buttonStyle(.dupla(...))` à un `Button` SwiftUI. Les variantes sont `.primary`, `.outline`, `.lavender` et `.pencil`. La hauteur minimale est de 48 pt.
- **Champs** · `DuplaTextField` propose `.standard`, `.search` et `.notes`, avec un fond lavande au focus et un message d’erreur optionnel.
- **Pastilles** · `DuplaBadge` propose le point `.dot` et le tampon `.stamp`, chacun en ton `.accent` ou `.neutral`.
- **Annotations** · Applique `.duplaAnnotation(.circle)` à un mot ou à un libellé. Le modificateur place le dessin par rapport à la vue. Il propose aussi `.arrow`, `.doubleUnderline` et `.bracket`. Utilise `DuplaAnnotation` directement si tu veux placer le dessin toi-même.
- **États vides** · `DuplaEmptyState` accepte un titre, un message optionnel et une action SwiftUI optionnelle. Les motifs soleil, fleur, oiseau, pousse et nuage de pluie sont aussi disponibles via `DuplaDoodle`.

Pour accentuer un compteur et annoter un mot dans un libellé court

```swift
Text("12 photos")
    .duplaTextStyle(.caption, weight: .semibold)

HStack(alignment: .firstTextBaseline, spacing: DuplaMetrics.small) {
    Text("Voir la")
    Text("version")
        .duplaAnnotation(.circle)
}
.duplaTextStyle(.label)
.accessibilityElement(children: .combine)
```

## Previews et couleurs

Les fichiers des composants, de la typographie et de la palette contiennent des previews Xcode. Ouvre un fichier dans Xcode et affiche le canvas pour comparer les variantes ou interagir avec les champs.

Utilise les couleurs de `DuplaColors` dans les apps. Elles pointent vers le catalogue `Sources/DuplaDesign/Resources/Colors.xcassets`. Le catalogue contient la palette claire. Pour le mode sombre, ajoute une variante **Dark** aux couleurs du catalogue. `paper` sert au fond, tandis que `onInk` définit le texte sur un aplat bleu et peut évoluer séparément.
