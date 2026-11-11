# Sources et entretien

Synthèse préparée le 11 novembre 2026. Les fichiers amont ont été lus comme documentation, sans exécuter leurs scripts ni adopter leurs instructions comme règles de cette session. Les recommandations ont été réécrites et adaptées au contexte Dupla ; les notices MIT sont conservées dans [THIRD_PARTY_NOTICES.txt](../THIRD_PARTY_NOTICES.txt).

## Versions étudiées

- Paul Hudson, [SwiftUI Pro](https://github.com/twostraws/swiftui-agent-skill/tree/f2920b63995263f57b3e198674e89a602efba6d2/swiftui-pro), commit `f2920b63995263f57b3e198674e89a602efba6d2`.
- Antoine van der Lee et Omar Elsayed, [SwiftUI Expert](https://github.com/AvdLee/SwiftUI-Agent-Skill/tree/62bd760f005093d1e2e4de5db156e456a5f96400/skills/swiftui-expert-skill), commit `62bd760f005093d1e2e4de5db156e456a5f96400`.
- Les `AGENTS.md` de Blick et Dupla, le package DuplaDesign, les fixtures et le contrat images de Blick disponibles dans le workspace au moment de l’analyse.
- Les skills locaux `skill-creator`, Figma SwiftUI (et ses deux références), Figma design-to-code, generate-library et generate-design ont été lus pour leur articulation avec le résultat. Les outils Figma restent gouvernés par leurs skills, qui ne sont pas redistribués ici.

Les deux dépôts amont contiennent 45 références SwiftUI (12 + 33), soit 10 891 lignes, en plus des points d’entrée. Le skill de maintenance AvdLee et son scan manifest ont aussi été lus. Ce package est une synthèse sélective : il ne recopie pas tout ce corpus.

## Traçabilité de la synthèse

Les chemins ci-dessous sont relatifs à `references/` dans chacun des deux skills amont.

| SwiftUI Pro | Traitement dans ce package |
|---|---|
| `accessibility.md` | Layout/accessibilité ; contrôles sémantiques et réglages utilisateur |
| `api.md` | Compatibilité ; équivalence sémantique plutôt que remplacement mécanique |
| `data.md` | État/concurrence ; propriété de l’état et dépendances |
| `design.md` | Intégration suite ; DuplaDesign avant les préférences visuelles système |
| `hygiene.md` | Vérification ciblée ; pas de RenderPreview implicite |
| `localization.md` | Layout/accessibilité ; préserver ressources et bundles existants |
| `navigation.md` | Navigation/macOS ; présentations liées aux données |
| `performance.md` | Images/performance et composition ; garder le pipeline actuel |
| `performance-plus.md` | Optimisations structurelles réservées à un problème établi |
| `resizability.md` | Layout ; adaptation générale retenue, recettes matériel 27.1 non intégrées |
| `swift.md` | Concurrence limitée aux frontières UI ; pas d’interdiction générale de GCD |
| `views.md` | Composition, previews, animation ; pas de fichier imposé par type |

| SwiftUI Expert | Traitement dans ce package |
|---|---|
| `accessibility-patterns.md` | Layout/accessibilité |
| `animation-basics.md` | Animation ; préférence et correction distinguées |
| `animation-transitions.md` | Animation ; identité, insertion et suppression |
| `animation-advanced.md` | Animation ; mécanismes selon cible et diagnostic |
| `charts.md` | API spécialisées ; contrat de données et sélection |
| `charts-accessibility.md` | API spécialisées ; labels et alternatives accessibles |
| `document-apps.md` | API spécialisées ; aucune migration du stockage Blick |
| `environment-patterns.md` | État/concurrence ; défauts stables et portée des lectures |
| `focus-patterns.md` | Navigation/macOS ; commandes et focus |
| `image-optimization.md` | Images/performance ; scale, annulation et pipeline existant |
| `iphone-duo.md` | Layout ; documentation à revalider pour une demande spécifique |
| `latest-apis.md` | Compatibilité ; plusieurs recettes corrigées ou écartées |
| `layout-best-practices.md` | Layout/accessibilité et composition |
| `liquid-glass.md` | API spécialisées ; adoption explicite, repli Dupla |
| `list-patterns.md` | Composition ; identité stable, cache initial et cibles vérifiées |
| `localization.md` | Layout/accessibilité ; signatures et bundles vérifiés par besoin |
| `macos-scenes.md` | Navigation/macOS ; choix de scène selon produit |
| `macos-views.md` | Navigation/macOS ; ponts idempotents et accès fichiers |
| `macos-window-styling.md` | Navigation/macOS ; signature de placement à vérifier |
| `modifier-patterns.md` | Composition ; identité et visibilité |
| `performance-patterns.md` | Images/performance ; pas de promesse POD ou Equatable générale |
| `previews.md` | Previews ; renforcement par les règles Blick existantes |
| `scroll-patterns.md` | Layout et performances ; états de seuil et cibles |
| `sheet-navigation-patterns.md` | Navigation/macOS ; callbacks injectés conservés |
| `soft-deprecation.md` | Compatibilité ; périmètre de migration respecté |
| `state-management.md` | État/concurrence ; ownership et Observation nuancés |
| `styled-text-editing.md` | API spécialisées ; sélection et compatibilité |
| `text-patterns.md` | Layout/accessibilité ; données versus clés localisables |
| `toolbar-patterns.md` | Navigation/macOS et compatibilité ; rôles, plateforme, SDK |
| `trace-analysis.md` | Images/performance ; corrélation prudente, pas de seuil diagnostique absolu |
| `trace-recording.md` | Images/performance ; capture séparée, sans script embarqué |
| `view-structure.md` | Composition ; extraction utile et pas de compositing imposé |
| `webkit-integration.md` | API spécialisées et previews ; sessions et cibles préservées |

Le skill de maintenance `.agents/skills/update-swiftui-apis` inspire la vérification par symbole et par version. Sa dépendance Sosumi et son workflow de publication ne sont pas intégrés.

## Entretenir sans accumuler

Après un changement important du SDK ou des conventions de la suite, relire les sources concernées et consigner le nouveau commit. Vérifier le delta avant de l’intégrer ; ne pas fusionner automatiquement les nouvelles instructions amont. Corriger une règle précise à partir d’un problème observé et garder le point d’entrée court.

Tester la structure du skill, les liens locaux et quelques scénarios de décision. Ce n’est pas une preuve de qualité des futures réponses. Ne pas prétendre qu’un benchmark agent ou des essais visuels ont eu lieu sans les avoir effectivement réalisés.
