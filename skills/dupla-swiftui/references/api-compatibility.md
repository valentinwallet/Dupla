# Compatibilité des API et modernisation

## La preuve avant la recette

Les noms et disponibilités des API changent. Lire le symbole dans le SDK installé ou la documentation Apple officielle pour l’API réellement utilisée. Une table communautaire est un index de recherche, pas une garantie de compilation ou d’équivalence de comportement.

Vérifier séparément :

1. Le compilateur et le SDK savent-ils déclarer le symbole ou la macro ?
2. Le mode Swift et l’isolation du target acceptent-ils cette utilisation ?
3. La plateforme le prend-elle en charge ? Une disponibilité iOS ne prouve pas celle de macOS.
4. La cible minimale permet-elle l’appel ? Sinon, prévoir une branche `#available` et un repli utile.
5. Des types/propriétés qui nomment la nouvelle API ont-ils eux aussi une disponibilité correcte ?

`#available` protège l’exécution ; il ne donne pas à un ancien SDK la connaissance d’un symbole nouveau. Une macro peut dépendre de la toolchain tout en se déployant sur des OS plus anciens. Ne pas ajouter des conditions et des branches si la cible couvre déjà l’API.

## Classer ce qui est trouvé

| Situation | Action |
|---|---|
| Erreur de compilation dans le chemin demandé | Corriger la cause dans le périmètre nécessaire |
| API officiellement dépréciée | Pour du nouveau code, choisir un équivalent compatible ; en migration demandée, vérifier les différences de comportement |
| API soft-deprecated, avertissements supprimés par une version lointaine | Ne pas en faire un bug urgent ; moderniser seulement si cela fait partie du changement |
| API fonctionnelle hors sujet | Ne pas lancer de migration voisine |
| Simple préférence de style | Ne pas la signaler comme défaut de correction |

Même une dépréciation officielle ne justifie pas de réécrire une fonctionnalité sans rapport pendant une correction. Si une migration devient nécessaire, expliquer pourquoi et conserver les comportements utiles.

## Remplacements fréquents, à contextualiser

- `foregroundStyle`/`tint` expriment des styles modernes ; ils ne remplacent pas les tokens Dupla.
- `NavigationStack`/`NavigationSplitView` remplacent les usages adaptés de `NavigationView` ; migrer navigation et restauration comme un tout cohérent.
- Les surcharges modernes de `onChange` ont zéro ou deux arguments. Vérifier la sémantique initiale, les captures et les effets.
- Préférer les surcharges builder d’overlay/background quand on passe une vue ; les surcharges de style restent valides.
- `clipShape(.rect(cornerRadius:))` et les API de coins récents doivent être compatibles avec la cible. Ne pas recopier `.concentric` comme cas de `RoundedCornerStyle` sans vérifier sa déclaration.
- Les `Tab`, scroll positions, toolbars, macros et API d’animation récentes ont leurs propres contraintes. Garder un ancien usage nécessaire à la cible sans le qualifier de faute.
- `@Entry` peut simplifier une nouvelle clé ; une déclaration manuelle existante avec un défaut stable n’impose pas une migration.
- `@ViewBuilder` existant n’est pas un défaut parce qu’une toolchain expose un nouveau nom de builder. Choisir d’après les déclarations disponibles et la compatibilité du package partagé.

## Équivalence à vérifier

`colorScheme(_:)` était implémenté dans le SDK 27 observé par une écriture dans l’environnement. `preferredColorScheme(_:)` émet une préférence vers la présentation. Pour préserver la portée locale lors d’un remplacement, utiliser `.environment(\.colorScheme, ...)` ; ne pas appliquer aveuglément le nom indiqué par une annotation de renommage.

Même prudence pour :

- setter de `Binding` → `onChange` ;
- `Window` → `WindowGroup` ;
- `WKWebView` → `WebView` ;
- cache de fichiers locaux → cache HTTP ;
- `FileDocument`/stockage métier → nouveau `Document` ;
- contrôle Dupla → contrôle avec apparence système.

## Entretenir les conseils

Pour une mise à jour du skill après un SDK, comparer uniquement les thèmes concernés avec Apple et les signatures locales. Enregistrer version du SDK, symbole, plateformes, minimums et différence sémantique. Actualiser les liens et les références affectées ; éviter une longue liste de nouveautés sans rapport avec les apps.

Le skill de maintenance amont AvdLee requiert Sosumi et prévoit un PR dans son dépôt. Ce package n’en hérite ni la dépendance obligatoire, ni l’autorisation de publier. Utiliser les moyens de documentation disponibles et conserver les changements locaux tant qu’aucune publication n’est demandée.
