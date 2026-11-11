# Composition, identité et collections

## Découper par responsabilité

Un écran compose des sections et coordonne navigation et actions. Une barre latérale, un inspecteur, un panneau d’assistant ou une ligne complexe justifient un type `View` dédié avec des entrées utiles. Garder les composants propres à la fonctionnalité près de son écran.

Les helpers privés qui retournent quelques vues locales restent utiles. Ils organisent le code ; ils ne créent pas une frontière indépendante d’invalidation comme un type `View`. Ne pas leur confier plusieurs panneaux complets. Un type séparé n’impose pas un fichier séparé pour chaque petit enum ou détail privé : suivre les responsabilités et les règles du dépôt.

Ne pas imposer MVVM, un routeur, un protocole ou un store par composant. Extraire la logique métier vers les modèles/services/use cases existants. Un simple changement d’état visuel peut rester dans l’action d’un bouton.

Garder les initialiseurs peu coûteux : ils peuvent être réévalués souvent. Ne pas y lire le disque, décoder des médias ou construire de grands modèles dérivés. Construire le contenu d’un conteneur générique une fois dans son initialiseur si son API le permet ; conserver une closure quand son exécution différée ou paramétrée est nécessaire.

## Préserver l’identité

- Pour le style d’une même vue, préférer une valeur conditionnelle du modificateur à deux branches recréant tout le sous-arbre.
- Utiliser `if`/`switch` pour des contenus réellement différents ou optionnels. Les branches ne sont pas interdites.
- Éviter les helpers génériques `.if` pour un simple style : ils peuvent changer l’identité, réinitialiser l’état et perturber les transitions.
- `opacity(0)` conserve l’espace, les interactions et l’accessibilité par défaut. Ne pas l’utiliser pour retirer une action sans traiter ces conséquences.
- `AnyShapeStyle` peut unifier deux styles de types différents. `AnyView` efface le type de toute la vue ; le réserver aux API qui nécessitent cette érosion.
- Employer `AnyLayout` quand seule l’organisation spatiale change et que l’état des enfants doit survivre.

Supprimer un `Group` à enfant concret unique s’il ne sert à rien. Garder les groupes qui distribuent des modificateurs ou expriment un builder utile. Ne pas réduire la hiérarchie au détriment du sens du layout.

## Listes, grilles et tables

Une collection modifiable doit avoir des identifiants stables, uniques dans son contexte et indépendants de la position ou du contenu éditable. Créer les identifiants à l’insertion dans le modèle, pas pendant `body`. Un UUID stocké durablement est valide ; un UUID régénéré à chaque rendu ne l’est pas.

Les indices conviennent à un ensemble de positions fixes dont l’identité est la position. Ils ne conviennent pas comme identité d’une bibliothèque triable, filtrable ou réordonnable. Pour une numérotation avec `enumerated()`, garder l’identité de l’élément ; vérifier la disponibilité de sa conformance collection avant de retirer une conversion `Array` sur d’anciennes cibles.

`id: \.self` peut convenir à de petites valeurs uniques et stables. Sur une grosse struct mutable, il peut coûter cher à hacher et changer à l’édition. Un identifiant serveur ou une clé du domaine n’exige pas de rendre tout le modèle `Identifiable` si ce contrat ne lui appartient pas.

Dans les conteneurs paresseux, préférer une ligne ayant un seul conteneur racine lorsque son contenu varie. Filtrer les éléments avant la construction des lignes plutôt que produire zéro ou plusieurs lignes selon l’élément. Ne pas qualifier un filtrage de changement d’identité si les identifiants restent stables : ses coûts de calcul et de construction des lignes sont des sujets distincts.

Pour beaucoup de contenu scrollable, employer un conteneur paresseux quand il correspond au besoin. Une petite rangée statique peut rester un `HStack`. Réutiliser `List` pour ses comportements natifs ; ne pas transformer systématiquement une grille photo en liste.

Une `Table` sélectionne par ID ; son binding de tri exprime l’ordre choisi mais le modèle doit effectivement appliquer le tri. Conserver une représentation utile quand des colonnes deviennent indisponibles à largeur compacte. Pour `TableColumnForEach`, vérifier la cible exacte, notamment macOS 14.4 plutôt que macOS 14.0.

Les API de réorganisation récentes ne remplacent pas seules le modèle : appliquer le déplacement, conserver l’ordre des éléments déplacés et réconcilier la sélection. Ne pas ajouter `reorderable` ou supprimer un delegate existant sans vérifier la disponibilité, le contrat de drag et les échanges inter-apps.

## Décoration et styles

Employer `overlay`/`background` pour décorer une vue principale, et `ZStack` pour des éléments qui participent comme pairs au layout. Leur proposition de taille diffère ; ne pas les interchanger seulement pour raccourcir le code.

Créer un style/modificateur partagé pour une combinaison visuelle réutilisée, dans DuplaDesign si générique. Ne pas ajouter systématiquement `.compositingGroup()`, `.drawingGroup()` ou `.equatable()` : les utiliser pour un défaut ou un coût identifié, en vérifiant leur effet. Une égalité qui ne compare que l’ID d’une donnée éditable peut masquer des changements visibles.
