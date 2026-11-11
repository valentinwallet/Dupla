---
name: dupla-swiftui
description: Écrire, corriger, refactoriser ou relire du code SwiftUI pour macOS et iOS, avec une attention aux états, à l’identité, aux performances et aux previews. Intègre les conventions DuplaDesign dans les apps Dupla et les règles locales de Blick. À utiliser pour une tâche SwiftUI concrète ; les échanges avec Figma restent couverts par les skills Figma spécialisés.
metadata:
  version: "1.0.0"
---

# SwiftUI pour Dupla

Produire un changement ciblé, cohérent avec le projet et compréhensible à la relecture. Les recommandations des sources sont une aide à la décision ; elles ne remplacent ni les instructions de l’utilisateur, ni les règles du dépôt, ni les déclarations du SDK réellement disponible.

## Avant de modifier

1. Lire les `AGENTS.md` applicables et le code concerné. Identifier le comportement attendu, les modifications déjà présentes et les conventions existantes.
2. Vérifier les plateformes, cibles de déploiement, version de compilateur, mode Swift, isolation par défaut et dépendances pertinentes. Les vérifier à nouveau seulement si la tâche ou l’environnement change. Ne pas relever une cible ou migrer une architecture pour satisfaire ce skill.
3. Identifier le propriétaire de chaque état et les effets externes. Pour une interface Dupla, lire [l’intégration à la suite](references/suite-integration.md) et chercher d’abord dans DuplaDesign.
4. Charger uniquement les références utiles ci-dessous. Une correction locale n’est pas un audit complet.

## Choisir les références

| Travail | Lecture |
|---|---|
| Interface d’une app Dupla, composant partagé, règles Blick | [Suite et design system](references/suite-integration.md) |
| Propriété d’un état, Observation, bindings, tâches et concurrence | [État et concurrence](references/state-and-concurrency.md) |
| Découpage, identité, listes, grilles, modificateurs | [Composition et identité](references/composition-and-identity.md) |
| Navigation, sheets, fenêtres, commandes, focus, pont AppKit | [Navigation et macOS](references/navigation-and-macos.md) |
| Redimensionnement, safe areas, accessibilité, traduction | [Layout et accessibilité](references/layout-and-accessibility.md) |
| Vignettes, cache, scroll lent, mémoire, analyse d’une trace | [Images et performances](references/images-and-performance.md) |
| Création ou modification d’un type d’interface | [Previews](references/previews.md), en plus du sujet concerné |
| Animation, transition, transaction | [Animation](references/animation.md) |
| Remplacement d’API, avertissement ou diagnostic de macro | [Compatibilité des API](references/api-compatibility.md) |
| Charts, documents, WebKit, texte enrichi, Liquid Glass | [API spécialisées](references/specialized-apis.md) |
| Origine des recommandations et entretien du skill | [Sources](references/sources.md) |

## Pendant le travail

- Respecter la demande. En revue, produire des constats sans modifier ; en implémentation, faire les changements nécessaires sans lancer une modernisation voisine.
- Garder les écrans centrés sur la composition, la navigation et la coordination. Extraire une responsabilité identifiable dans un `View` dédié ; conserver les petits détails locaux en helpers privés quand cela suffit.
- Garder l’état au niveau qui l’utilise. Préférer `@Observable` pour un nouveau modèle d’interface compatible avec les cibles ; conserver une intégration `ObservableObject` fonctionnelle hors migration demandée.
- Préserver identité, sélection, focus, annulation et sémantique des actions. Une réécriture plus courte n’est pas équivalente si elle change ces comportements.
- Garder `body` et `init` sans effets externes ni traitement lourd. Une fonction `async` n’implique pas à elle seule une exécution hors du MainActor.
- Utiliser Swift Concurrency pour le code concurrent nouveau ou modifié. Éviter GCD ; toute exception doit répondre à une contrainte concrète et rester confinée et documentée. L’adaptateur Kingfisher du pipeline images Blick est l’exception actuellement recensée, pas une autorisation générale liée à cette dépendance.
- Réutiliser les composants, ressources et services existants. Dans Dupla, étendre DuplaDesign pour un besoin générique ; laisser la logique métier et les compositions de fonctionnalités dans l’app.
- Supprimer les états, helpers, ressources et chemins devenus inutiles du fait du changement. Ne pas nettoyer du code voisin sans rapport.
- Ajouter ou actualiser les previews requises, avec des données isolées et déterministes. Ne jamais confondre leur écriture avec l’autorisation de les exécuter.
- Rechercher systématiquement une implémentation efficace. Appliquer les bonnes pratiques de performance et les améliorations locales étayées dans le périmètre travaillé. Pour une optimisation structurelle, expliciter le coût visé, les compromis et la manière de vérifier le bénéfice ; consulter [images et performances](references/images-and-performance.md).
- Distinguer un défaut observable, une amélioration de maintenance et une optimisation à mesurer. Ne pas présenter une préférence de style ou une hypothèse de diffing interne comme une erreur certaine.

## Vérifier et terminer

Utiliser la plus petite vérification pertinente : inspection du diff, compilation ciblée ou tests de la logique modifiée selon les règles du projet. Pas de suite de tests inventée pour recopier l’implémentation d’un changement visuel mineur.

Dans les apps Dupla, Valentin conserve l’exécution et les essais manuels. Sans demande explicite, ne lancer ni l’app, ni les previews, ni une capture ou automatisation UI pour vérifier. L’existence d’un outil `RenderPreview`, d’un simulateur ou d’un script Instruments ne donne pas cette autorisation. Dans DuplaDesign, vérifier les modifications du package en ligne de commande. Hors de la suite, suivre les règles du dépôt.

En revue, signaler les problèmes avérés par impact : fichier et ligne, condition qui déclenche le problème, conséquence et correction minimale. Une suggestion cosmétique n’est pas un bug. Pour une implémentation, expliquer brièvement le résultat, ce qui a été vérifié et ce qui reste à essayer manuellement. Ne pas annoncer un gain de performances ou une validation visuelle non mesuré.
