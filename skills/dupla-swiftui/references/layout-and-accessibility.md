# Layout, accessibilité et texte

## S’adapter à l’espace proposé

Construire le layout d’après l’espace du conteneur, pas un écran global, un modèle d’appareil ou une orientation supposée. Les fenêtres macOS, sheets et écrans multiples rendent les dimensions globales inadaptées.

Utiliser les stacks et priorités pour le flux naturel, `ViewThatFits` pour des alternatives qui dépendent du contenu, `AnyLayout` pour réorganiser les mêmes enfants, et les grilles pour leurs collections. Un `GeometryReader` reste valide lorsque le layout dépend d’une mesure, comme un canvas de recadrage. `containerRelativeFrame`, `visualEffect` ou `onGeometryChange` ne sont pas des remplacements universels.

Lire les valeurs de layout et `displayScale` près de la vue ou dans `context.environment` d’un representable. Les size classes sont optionnelles et ne sont pas une mesure universelle de largeur, notamment sur macOS. Un `nil` ne signifie pas `.regular`. Ne pas les mettre en cache dans un modèle pour déduire la fenêtre courante.

Garder l’accès aux fonctionnalités quand la fenêtre rétrécit. Prévoir scroll, repli ou autre route plutôt que masquer définitivement une action. Conserver sélection et état au-dessus d’une branche qui recrée une hiérarchie.

## Safe areas et dimensions

- Laisser les conteneurs réserver leurs insets. Ne pas imiter une barre système par un padding fixe ni appliquer deux fois le même inset.
- `safeAreaInset` convient à du contenu fixé qui doit réserver de la place. `safeAreaBar` peut convenir à une vraie barre si le SDK et les cibles le permettent.
- `safeAreaPadding` représente une marge de design supplémentaire ; ce n’est pas la mesure dynamique d’une barre.
- Réserver `ignoresSafeArea` à une intention précise et aux bords concernés. Une décoration plein fond peut ignorer les bords ; les contrôles et textes doivent rester accessibles.
- Les dimensions fixes peuvent être justifiées par une vignette, un ratio, une icône, un token de contrôle ou un canvas. Éviter les frames copiées d’un appareil et les hauteurs qui tronquent du texte.

Ne pas ajouter de gestion de charnière, de caméra ou de reserved regions à une app qui n’en a pas besoin. Pour une tâche explicite de matériel pliable, vérifier la documentation Apple et les déclarations du SDK disponible ; les deux dépôts sources décrivent des API 27.1 dont la toolchain locale observée 27.0 ne disposait pas. Garder un repli fonctionnel et ne pas annoncer un essai de pose qui n’a pas eu lieu.

## Contrôles et accessibilité

Préférer `Button`/`Toggle`/`Picker` aux gestures lorsqu’il s’agit de ces actions : clavier, focus et sémantique sont alors conservés. Une gesture est légitime pour la position, le nombre de taps, le drag ou une interaction de canvas ; fournir alors une voie accessible et préserver la sélection existante.

Donner aux actions un libellé qui exprime leur intention. Une apparence à icône seule peut conserver le titre via `.labelStyle(.iconOnly)`. Marquer les illustrations purement décoratives comme telles. Ne pas exposer dix fois la même information par l’image, le texte et le conteneur.

Grouper les labels qui forment une seule information sans fusionner des boutons indépendants. Pour un contrôle personnalisé, examiner `accessibilityRepresentation`, les actions ajustables et les valeurs sélectionnées. Le label décrit l’action ou l’objet ; la valeur décrit son état.

Respecter Reduce Motion et Reduce Transparency, le contraste et la différenciation sans couleur. Ne pas exprimer sélection, erreur ou disponibilité uniquement par une teinte. Ne pas remplacer un focus visible par un simple hover.

Sur iOS, tenir compte des cibles tactiles attendues par la plateforme ; ne pas imposer 44 ou 48 points à toute ligne compacte de bureau. Dans DuplaDesign, utiliser les tailles de contrôle existantes et demander une variante pertinente si le contrat d’accessibilité exige une évolution.

Les polices personnalisées de Dupla sont intentionnelles. Réutiliser leurs styles et leur relation aux tailles sémantiques ; traiter une limite de lisibilité ou de mise à l’échelle dans le composant partagé concerné. Ne pas prétendre que toute taille actuellement présente est déjà validée sur toutes les plateformes.

## Localisation et formatage

Suivre les ressources existantes (`.strings`, `.stringsdict`, `.xcstrings`, symboles générés). Ne pas déclencher une migration du système de traduction pour une petite fonctionnalité.

Un littéral passé à une API localisable peut être extrait ; une `String` dynamique s’affiche telle quelle et n’est pas extraite automatiquement en l’enveloppant après coup. Employer `LocalizedStringKey` ou `LocalizedStringResource` selon les signatures réelles, sans casser l’API publique existante de DuplaDesign.

Préférer une phrase interpolée aux fragments concaténés afin que le traducteur puisse déplacer les variables. Conserver les noms de fichiers, pseudos et contenus saisis comme données, sans les traiter comme des clés. Ajouter un commentaire pour une formulation ambiguë ou des placeholders difficiles à comprendre.

Résoudre les ressources d’un package dans son bundle. `Bundle.module` est approprié dans un package avec ressources ; un framework a un autre accès. Vérifier les macros récentes comme `#bundle` dans la toolchain avant de les prescrire.

Lire locale, calendrier et fuseau dans l’environnement pour la présentation liée à une vue. Utiliser `FormatStyle` et `Text(_:format:)` pour dates, nombres et monnaies quand ils répondent au contrat. Les formats fixes de stockage/échange ont une autre responsabilité ; ne pas leur appliquer les conventions de présentation.

Utiliser leading/trailing pour la disposition directionnelle et prévoir textes longs et tailles de lecture accrues. Le mode sombre n’est pas une fonctionnalité acquise parce qu’un type `Color` est utilisé : vérifier les variantes du catalogue. Ne pas inventer une nouvelle palette sombre sans demande.
