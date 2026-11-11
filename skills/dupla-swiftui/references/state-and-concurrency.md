# État, Observation, bindings et tâches

## Choisir selon la propriété de la donnée

| Besoin | Choix usuel |
|---|---|
| État local dont la vue possède la durée de vie | `@State private` |
| Modèle `@Observable` créé et conservé par la vue | `@State private` |
| Valeur reçue, lue seulement | Propriété simple, généralement `let` |
| Valeur du parent modifiée par l’enfant | `@Binding` |
| Modèle `@Observable` reçu avec projections pour des contrôles | `@Bindable`, éventuellement local |
| Modèle observable partagé par une hiérarchie | Injection existante, ou `@Environment(Model.self)` si approprié |
| Intégration `ObservableObject` conservée | `@StateObject` pour le propriétaire, `@ObservedObject` pour le receveur |

`@Bindable` donne accès aux bindings ; il n’est pas nécessaire pour toute lecture d’un modèle Observation. Ne pas créer un objet injecté dans `body` ou sous `@ObservedObject` en espérant que SwiftUI en conserve la durée de vie.

Un état initialisé depuis un argument reçoit une **graine initiale**, pas une entrée synchronisée. Garder cette distinction pour un brouillon d’édition. Si les changements du parent doivent suivre, utiliser une valeur reçue ou un binding. Ne pas ajouter `.id(input)` pour masquer une erreur de propriété : cela réinitialise le sous-arbre.

Avec une toolchain qui fournit `@State` sous forme de macro, lire le diagnostic et la déclaration disponible. Initialiser l’état à un seul endroit ; ne pas cumuler défaut de déclaration et valeur injectée dans `init`. Ne pas copier automatiquement une recette d’initialisation d’une autre génération du SDK.

## Observer ce qui est utilisé

Observation suit les propriétés lues, y compris à travers un getter calculé. Passer un modèle observable entier ne signifie pas observer toutes ses propriétés. Lire un élément d’un tableau stocké ou un champ d’une struct stockée peut toutefois créer une dépendance sur la propriété composée.

Passer à une ligne son élément ou les informations nécessaires, plutôt qu’un grand store et un index qui imposent une nouvelle recherche. Réserver l’aplatissement des modèles, les objets observables par ligne et les caches dérivés aux problèmes établis. Une propriété calculée simple reste préférable à une seconde source de vérité.

Un cache dérivé doit couvrir l’état initial, tous ses facteurs d’entrée, les changements programmatiques et les suppressions. Déplacer `filter` dans un getter ne mémorise pas son résultat. Ajouter `Equatable` quand l’égalité exprime réellement la sémantique, sans promettre un comportement d’invalidation identique sur toutes les générations du compilateur.

## Bindings et effets

Préférer les projections natives ou une propriété/subscript modifiable quand ils expriment le même contrat. Un `Binding(get:set:)` reste approprié pour une adaptation ou une validation ; il ne justifie pas une refonte du modèle à lui seul.

Ne pas remplacer son setter par `onChange` sans vérifier les effets : le setter reçoit les écritures faites par le binding, y compris une valeur égale ; `onChange` réagit aux changements observés, y compris programmatiques. Une sauvegarde, un undo ou une validation peuvent dépendre de cette différence.

Une propriété binding utilisée pour mettre à jour la vue ou un representable doit participer au mécanisme dynamique via `@Binding`. Rafraîchir les bindings conservés par un coordinator quand ses entrées changent.

Les wrappers liés au cycle SwiftUI (`@AppStorage`, `@SceneStorage`, `@Query`) ne deviennent pas des propriétés observables fiables en les déplaçant dans une classe `@Observable`. `@ObservationIgnored` résout certains conflits de synthèse, pas la notification des écritures externes. Conserver le wrapper dans la vue ou employer le service de persistance déjà conçu pour le modèle.

## Environnement

- Placer les lectures près du consommateur. Supprimer les clés déclarées mais inutilisées.
- Injecter les modèles avec une durée de vie explicite ; ne pas recréer un singleton implicite par lecteur.
- Pour une nouvelle clé, `@Entry` peut réduire le code si la toolchain le permet. Une clé manuelle stable et fonctionnelle n’est pas un bug à migrer systématiquement.
- Garder les valeurs par défaut stables : pas de `UUID()`, date courante ou nouvel objet à chaque accès. Une absence représentée par `nil` peut être préférable à un objet sentinelle. Un `static let` partagé n’est adapté que si ce partage est voulu ; ne pas en faire un modèle de fenêtre partagé involontairement.
- Une closure dans une clé personnalisée peut compliquer la comparaison. Pour un problème d’invalidation, examiner un modèle ou une action avec identité et données stables. Ne pas interdire les callbacks ordinaires transmis à un composant ; ne pas remplacer les actions système `dismiss`/`openURL`.
- Ne pas diffuser positions de scroll ou de drag à chaque frame dans tout l’environnement. Observer un seuil, ou un état local/par élément, quand cela suffit.

## Concurrence au contact de SwiftUI

Isoler les modèles d’interface mutables sur `MainActor` si leur contrat l’exige, en tenant compte de l’isolation par défaut du projet. `@Observable` assure l’observation, pas la synchronisation des accès. Les acteurs de stockage et traitement ne doivent pas être déplacés sur le MainActor pour se conformer à une règle générale.

Préférer `.task(id:)` quand une requête dépend d’une entrée qui change ; inclure les facteurs qui rendent un ancien résultat invalide. L’annulation est coopérative : la tâche et les services doivent l’honorer. Avant de publier un résultat, vérifier qu’il correspond encore à la demande courante si le service peut terminer après annulation. Traiter `CancellationError` séparément d’une erreur utilisateur.

`Task {}` peut hériter de l’acteur appelant. Un `await` ne déplace pas magiquement un décodage ou une lecture bloquante. Choisir un acteur/exécuteur adapté au travail, et vérifier les règles de la version Swift utilisée. Un acteur dédié sérialise ses accès ; ce n’est pas automatiquement un pool de décodage parallèle.

Utiliser Swift Concurrency pour le code concurrent nouveau ou modifié. Éviter GCD ; ne pas introduire `DispatchQueue`, groupes ou sémaphores par commodité. Une exception exige une contrainte concrète d’API, d’intégration ou d’exécution qui n’est pas correctement couverte par la solution Swift retenue. La confiner à un adaptateur, documenter sa raison et conserver annulation et isolation cohérentes. La présence d’une dépendance n’autorise pas GCD partout autour d’elle.

Dans les sources Swift propres à Blick et Dupla inspectées le 11 novembre 2026, les seuls usages explicites de GCD sont les deux queues du `ImagePipeline` qui configurent les lectures locales et le traitement Kingfisher. Ce constat ne couvre ni l’implémentation interne des dépendances, ni les autres apps de la suite. L’exception actuelle préserve ce contrôle d’exécution ; elle ne prétend pas qu’une solution entièrement Swift serait impossible et n’est pas une migration à entreprendre pendant une tâche sans rapport.

Réserver `Task.detached` aux besoins explicites d’exécution indépendante ; gérer captures `Sendable`, annulation, priorité et durée de vie. Ce n’est pas un remplacement mécanique de `DispatchQueue`.

Éviter de bloquer le MainActor avec I/O synchrones, attente de sémaphore ou décodage lourd. `Task.sleep(for:)` suspend une tâche sans bloquer son thread ; une faible activité CPU dans une trace ne prouve donc pas que cette API bloque l’interface.

Références Apple : [données observables](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app), [suspension d’une tâche](https://developer.apple.com/documentation/swift/task/sleep(for:tolerance:clock:)).
