# Animation et transitions

Commencer par l’intention : feedback d’une action, état visuel, insertion/suppression, réorganisation ou progression. Préserver l’identité et les interactions pendant l’animation.

## Choisir le mécanisme

- `withAnimation` pour une mutation liée à une action.
- `.animation(_:value:)` pour un état précis dans une sous-hiérarchie ciblée.
- Une animation à closure peut limiter les modificateurs animés si elle est disponible ; ne pas la confondre avec l’ancienne surcharge `.animation(_:)` sans valeur, qui applique une portée trop large.
- Une transition décrit une insertion/suppression. Son contexte d’animation doit survivre à la disparition de l’enfant.
- `matchedGeometryEffect`/transitions de navigation : vérifier identité, namespace, plateforme et cible ; ne pas inventer un modificateur parce que son nom paraît plausible.

Éviter les animations placées à la racine sans raison : elles peuvent affecter du contenu chargé ou des changements de layout sans rapport avec l’action.

## Ordre, transactions et séquences

L’ordre des modificateurs et les transactions déterminent la portée. Ajuster la transaction au point utile ; ne pas supposer que toute propriété située après une animation suivra le même comportement.

Pour une suite d’états, utiliser les completions d’animation, `phaseAnimator` ou `keyframeAnimator` selon le besoin et la cible. Ne pas empiler des délais arbitraires qui se désynchronisent si l’action est interrompue. Un délai métier n’est pas une durée d’animation.

Quand l’interpolation personnalisée est nécessaire, implémenter `Animatable`/`animatableData` ou employer `@Animatable` seulement si ses disponibilités conviennent. Les valeurs non animables ne doivent pas être synthétisées comme animables. Garder une implémentation explicite quand le setter applique une normalisation ou un bornage indispensable.

## Accessibilité et coût

Respecter `accessibilityReduceMotion` : réduire ou remplacer un grand mouvement par une transition discrète selon le contexte. Garder un indicateur de changement quand l’animation disparaît. Les animations doivent rester interruptibles et ne pas bloquer une action importante.

Réutiliser les choix de mouvement du design system lorsqu’ils existent. Ne pas ajouter une nouvelle gestuelle ou des timings partagés pour chaque correction locale.

Les transforms peuvent éviter du relayout quand seul l’aspect visuel doit changer. Modifier la taille est correct si la place occupée doit évoluer ; ne pas remplacer un layout requis par un scale qui chevauche ses voisins.

Ne pas animer des écritures d’état global à chaque pixel de scroll. Préférer un effet visuel local ou un seuil utile. Une séquence permanente ou des couches floutées méritent une mesure si elles sont suspectées de dégrader la fluidité.

Les conseils de cette référence ne constituent pas une autorisation de lancer l’app ou les previews. Suivre les règles de vérification du dépôt.
