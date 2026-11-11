# Intégration à Dupla et Blick

Lire cette référence pour une interface Dupla. Confirmer les détails dans les dépôts : cette photographie du contexte ne remplace pas leurs règles vivantes.

## Le partage utile

DuplaDesign est la source commune des couleurs, typographies, styles et composants SwiftUI de la suite. Localiser le dépôt par la configuration du workspace ou du package ; `../Dupla` est la convention des checkouts locaux, pas un chemin universel. Une dépendance Git distante ne prouve pas que le checkout voisin est déjà utilisé par le build de l’app.

Avant de créer un composant :

1. Chercher une API existante dans `Sources/DuplaDesign`, puis ses appels et previews. Le README peut être moins récent que le code.
2. Réutiliser le composant ou étendre une variante si elle exprime le besoin.
3. Si le besoin pourrait servir à plusieurs écrans ou apps, placer la partie générique dans DuplaDesign. Exposer données visuelles, bindings et actions utiles, sans importer les modèles ou services de Blick.
4. Conserver l’assemblage métier près de la fonctionnalité dans l’app. Ne pas transformer chaque section d’écran en composant public.

Les chemins autorisés en écriture restent ceux de la session. Identifier et préparer une modification nécessaire dans un autre dépôt n’autorise pas à contourner ses restrictions.

## API observée au 11 novembre 2026

| Rôle | API existante à examiner |
|---|---|
| Couleurs | `DuplaColors` : `chrome`, `panel`, `paper`, `ink`, `onInk`, `text`, `mutedText`, `border`, `lavender`, `tapeKraft`, `error` |
| Espacement et dimensions | `DuplaMetrics` ; différencier dimensions de contrôle et insets système |
| Typographie | `.duplaTextStyle(_:weight:)` ; rôles display, title, note, body, label, caption, metadata |
| Action | `Button` avec `.buttonStyle(.dupla(...))`, variantes et tailles existantes |
| Saisie | `DuplaTextField`, types standard, search, notes |
| État vide | `DuplaEmptyState` et son contenu d’action |
| Marqueurs et visuels | `DuplaBadge`, `DuplaAnnotation`, `DuplaDoodle`, `DuplaNavigationIcon`, `DuplaInkSwipe`, `DuplaPhotoFrame`, `DuplaTape` |

Ne pas remplacer un `DuplaEmptyState` par `ContentUnavailableView`, les polices Annie/IBM Plex Mono par SF Pro, ou les poids fournis par `.duplaTextStyle` par `.bold()` sous prétexte de modernisation. Garder les comportements natifs de `Button`, `Toggle`, `List`, menus et navigation quand ils conviennent, avec l’habillage Dupla. Une lacune d’accessibilité du design system se corrige à la source, dans le périmètre autorisé.

Le package ciblait macOS 14/iOS 17 et déclarait `swift-tools-version: 5.9` lors de l’analyse. Blick ciblait macOS 14 avec le mode Swift 6.0. Relire ces réglages avant d’introduire une API plus récente ; le compilateur installé et le mode de langage sont deux informations différentes.

## Conventions communes validées

Pour les composants créés ou modifiés dans la suite :

- Un type `View` dédié pour une responsabilité autonome ; un fichier dédié pour un composant conséquent ou réutilisable ; des helpers privés pour les petits détails locaux. Vers 250–300 lignes, revoir le découpage sans limite mécanique ni abstraction ajoutée uniquement pour raccourcir un fichier.
- Des previews directes pour les types d’interface, même privés, avec les états utiles et les dépendances de démonstration isolées. Voir [previews.md](previews.md).
- Valentin conserve l’exécution et les essais visuels ; aucune app, preview, capture ou automatisation UI lancée pour vérifier sans demande explicite. Les vérifications CLI restent proportionnées.
- Swift Concurrency pour le code concurrent, GCD évité sauf contrainte concrète et exception confinée/documentée.
- Recherche systématique d’efficacité et améliorations locales étayées ; coût, compromis et vérification explicités pour une optimisation structurelle.

Ces conventions accompagnent le travail autorisé dans chaque dépôt. Elles ne déclenchent pas une refonte rétroactive de toutes les apps. Les en-têtes de fichiers suivent les règles du projet concerné ; le format spécifique de Blick ci-dessous n’est pas automatiquement imposé ailleurs.

## Conventions Blick

- Écrans composés de sections dédiées. Vers 250–300 lignes, revoir les responsabilités ; ce n’est pas un quota ni un motif pour créer une abstraction sans utilité.
- Preview Xcode directe pour chaque type `View`, `ToolbarContent`, `NSViewRepresentable`, même privé. Les helpers de quelques lignes peuvent être couverts par leur parent. Voir [previews.md](previews.md).
- Réutiliser `Previews/BlickPreviewData.swift`, `.blickPreview()` et `isBlickPreview`. Les actions externes doivent respecter ce mode, sans désactiver les interactions de démonstration.
- Utiliser le pipeline images existant. `docs/IMAGE_LOADING.md` décrit Kingfisher, les clés, les tailles, le recadrage et l’annulation. Ne pas le remplacer par `AsyncImage` ni supprimer ses files de traitement pour appliquer une préférence générale.
- Les essais de l’app sont manuels, menés par Valentin. Vérifications CLI limitées au nécessaire.
- Pour un fichier Swift créé ou modifié, respecter l’en-tête local. Dans Blick : nom exact du fichier, projet Blick, auteur Valentin Wallet, date `dd/MM/yyyy`. Nouveau fichier : date de création à Paris. Fichier ancien sans en-tête : dernière modification avant ajout si aucune date de création n’est connue. Conserver ensuite la date ; actualiser le nom lors d’un renommage.

Ne pas propager le nom Blick, ses chemins de fixtures, ses services Instagram ou ses règles d’en-tête dans une autre app. Y chercher les équivalents locaux.

## Coexistence avec Figma

Une tâche SwiftUI ordinaire ne devient pas une synchronisation Figma. Pour un échange réellement demandé avec Figma, utiliser les skills Figma pertinents et leurs prérequis ; ce skill n’autorise aucune écriture externe supplémentaire.

Mapper les rôles visuels vers DuplaDesign en premier. Les mappings iOS génériques des skills Figma ne constituent pas une demande de remplacer la marque. Une police Dupla déjà choisie n’exige pas une nouvelle question proposant SF Pro. Si un design fourni contredit le code ou un token existant, montrer l’écart concret et demander l’arbitrage avant de changer la valeur partagée.

Une image du design dans Figma sert de référence. Elle ne remplace pas l’interface éditable ni une validation de l’app. Une demande d’implémentation depuis Figma n’autorise pas implicitement le lancement de Blick ou de son canvas de previews.
