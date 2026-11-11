# Navigation, fenêtres, commandes et ponts natifs

## Navigation et présentations

Choisir le conteneur selon le parcours : `NavigationStack` pour un chemin, `NavigationSplitView` pour une hiérarchie sélection/détail, `HSplitView`/`VSplitView` sur macOS pour des panneaux pairs redimensionnables. Garder une composition métier existante quand sa structure est intentionnelle. Un panneau latéral n’impose pas de convertir tout l’espace de travail en navigation hiérarchique.

Préférer des routes typées et une inscription `navigationDestination(for:)` par type dans la pile concernée. Éviter les destinations concurrentes et les mélanges de modèles de navigation qui créent un comportement incohérent. Un lien à destination directe simple n’est pas automatiquement un bug.

Pour une sheet fondée sur une donnée optionnelle, `.sheet(item:)` évite la désynchronisation entre donnée et booléen. Un enum identifiable peut représenter plusieurs présentations mutuellement exclusives. Conserver un booléen pour une présentation sans donnée si c’est suffisant.

Une sheet peut utiliser `dismiss` pour sa fermeture. Elle peut aussi recevoir `onSave`, `onCancel`, un binding ou un service injecté : choisir le contrat qui préserve la séparation métier et la possibilité de preview. Une sauvegarde asynchrone qui échoue doit laisser le brouillon et l’erreur accessibles ; ne pas fermer avant de connaître le résultat.

Garder une seule source de vérité pour l’objet d’une suppression/confirmation. Vérifier les nouvelles surcharges `item:` dans le SDK réel ; leur disponibilité de compilation peut différer de leur disponibilité d’exécution. Les contrôles destructifs ont un rôle explicite.

Utiliser un inspector natif s’il exprime le besoin et ses comportements adaptatifs ; conserver l’état au-dessus d’une branche de layout qui pourrait le remplacer. Attacher les présentations à un hôte qui survit assez longtemps, notamment autour d’un menu transitoire.

## Fenêtres et scènes macOS

- `WindowGroup` exprime plusieurs instances ; `Window` exprime une fenêtre unique. Préserver le comportement produit, notamment fermeture et réouverture. Ne pas changer le type de scène pour appliquer une préférence générale.
- L’état de navigation, sélection et brouillon d’une fenêtre appartient à sa racine. Un singleton ou `@AppStorage` peut involontairement coupler deux fenêtres.
- Préférer `Settings`, `SettingsLink` et `openSettings` pour les préférences quand les cibles le permettent.
- Employer `MenuBarExtra` si l’app a ce besoin. `UtilityWindow`, des placements et d’autres réglages plus récents exigent de vérifier le minimum macOS.
- Distinguer taille initiale, taille minimale, taille idéale et resizability. Ne pas bloquer le redimensionnement pour cacher un problème de layout.
- Les signatures des modificateurs de scène ne se déduisent pas de leur nom. Par exemple, le SDK 27 local donne à `windowIdealPlacement` deux arguments de closure, contenu et contexte.

## Toolbars, clavier et focus

Placer les actions dans la toolbar de la zone qu’elles contrôlent. Utiliser des titres accessibles avec les symboles et des placements sémantiques quand ils conviennent. Garder les styles Dupla pour les contrôles personnalisés ; ne pas reconstruire le chrome système inutilement.

Exposer les actions usuelles dans les menus/commandes appropriés sans dupliquer leur logique métier. Activer les commandes selon le document ou la sélection de la fenêtre réellement focalisée, via les focused values/bindings existants. Ne pas diriger une commande sur le dernier modèle global créé.

`@FocusState private` représente un champ unique ou un enum optionnel à valeurs distinctes. Lire le focus près de son usage. Ne pas réassigner le focus dans une gesture si `.focusable()`/`.focused()` gère déjà l’interaction ; examiner l’ordre des modificateurs et la disponibilité avant d’ajouter un délai.

Préférer le focus initial déclaratif (`defaultFocus`) quand il convient. Conserver un indicateur de focus visible si le style système est remplacé. Les raccourcis de suppression et les flèches ne doivent pas voler l’édition d’un champ texte focalisé.

## AppKit et representables

SwiftUI est le premier choix quand son API couvre le contrat. Un pont AppKit est légitime pour un comportement ou une cible non couverts. Ne pas remplacer `WKWebView` seulement parce que `WebView` existe sur un OS plus récent.

- Création/configuration initiale dans `makeNSView` ; synchronisation idempotente des changements dans `updateNSView`.
- Un appel de mise à jour ne doit pas relancer un chargement web, réinstaller un delegate ou remettre le curseur à zéro si les entrées pertinentes n’ont pas changé.
- Utiliser un coordinator pour delegates et retours ; actualiser les références/bindings qu’il conserve.
- Libérer observers, tâches et delegates quand leur cycle l’exige. Éviter boucles de retour état SwiftUI → AppKit → même écriture.
- SwiftUI gère la taille du NSView représenté ; ne pas forcer ses frames pour contrer le layout.
- Prévoir une preview directe avec un stockage ou contenu de démonstration isolé.

## Fichiers et documents

Réutiliser les importeurs/exporteurs et services du projet. Pour une URL security-scoped, équilibrer un accès acquis avec sa libération quand l’opération asynchrone est réellement terminée. Ne pas fermer l’accès par `defer` avant qu’une tâche lancée séparément ait lu le fichier. Distinguer annulation et échec d’import ; rendre l’erreur utile à l’utilisateur.

Un workspace stocké via une base métier ne devient pas une app `DocumentGroup` parce qu’il manipule des fichiers. Pour une app réellement fondée sur des documents, consulter [les API spécialisées](specialized-apis.md) et vérifier sauvegarde, undo, coordination et compatibilité avant une migration.
