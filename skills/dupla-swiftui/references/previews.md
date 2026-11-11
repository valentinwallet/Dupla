# Previews isolées et utiles

## Portée

Lire les règles du dépôt. Dans les apps Dupla et DuplaDesign, chaque type `View`, `ToolbarContent` et `NSViewRepresentable` créé ou modifié, y compris privé, doit avoir un `#Preview` qui l’instancie directement. Une preview d’écran qui affiche indirectement un enfant ne remplace pas la preview directe de cet enfant. Montrer les variantes et états utiles. Cette exigence s’applique au travail courant, sans déclencher une migration de tous les anciens composants de la suite.

Un helper sous forme de propriété/fonction de quelques lignes peut être couvert par la preview de son parent. Ne pas créer un type supplémentaire uniquement pour satisfaire une preview si le helper n’a pas de responsabilité autonome.

## Choisir les états

Montrer les états qui changent réellement l’apparence ou l’interaction : vide, rempli, sélectionné, désactivé, chargement, erreur, texte long, variante de style ou de taille. Ne pas fabriquer le produit cartésien de toutes les combinaisons. Les variantes doivent être nommées pour qu’un humain sache ce qu’il compare.

Pour un composant adaptable, une taille étroite et une large peuvent être utiles. Ajouter locale, sens de lecture ou taille de texte lorsqu’ils testent un risque réel du composant. Ne pas déclarer de prise en charge du mode sombre inexistante dans le thème.

## Déterminisme et isolation

- Utiliser des dates fixes, IDs stables, noms et médias locaux. Pas de `Date.now`, UUID renouvelé ou contenu distant pour la donnée visible de référence.
- Créer un modèle mutable distinct par preview ; une fixture immuable peut être partagée. Une instance observable globale modifiable peut faire interagir deux previews involontairement.
- Injecter les dépendances requises, y compris l’environnement. Éviter le constructeur de production qui ouvre une bibliothèque ou un compte réel.
- Employer des repositories en mémoire, réglages isolés et médias de démonstration. Une persistance temporaire ne doit pas se confondre avec les réglages réels.
- Dans Blick, réutiliser les fixtures de `Previews/BlickPreviewData.swift` et `.blickPreview()` plutôt que créer une nouvelle infrastructure de mocks pour chaque vue.

Le marqueur `isBlickPreview` n’agit que si les chemins d’exécution le respectent. Examiner tâches au chargement, boutons, callbacks, importeurs, presse-papiers, openURL, Trousseau et API. Garder les interactions locales possibles dans les données de démonstration et l’apparence normale des contrôles. Ne pas désactiver tout l’écran pour rendre la preview sans effets.

Pour une vue web, employer un datastore WebKit non persistant et du HTML local sans sous-ressources réseau ; ne pas partager cookies, cache de session ou URLs d’authentification de production.

## Instanciation directe selon le type

- `View` : construire le composant lui-même dans le bloc `#Preview`, avec ses entrées de démonstration.
- `ToolbarContent` : construire un hôte minimal avec `.toolbar { LeToolbar(...) }`. L’hôte présente le contenu ; il ne remplace pas son instanciation directe dans le bloc.
- `NSViewRepresentable` : construire le representable lui-même, en injectant ses entrées locales et le marqueur de preview si nécessaire.

Pour un binding interactif, utiliser la construction prise en charge par la toolchain et la cible (`@Previewable` si disponible, sinon un hôte d’état minimal). Ne pas relever la cible de l’app seulement pour simplifier la preview. Vérifier les disponibilités des traits et macros au lieu de reprendre une limite iOS comme limite macOS.

Si un hôte SwiftUI devient un type de la suite, il est lui aussi soumis aux règles de preview ; privilégier une solution simple qui évite de multiplier les wrappers.

## Écrire n’est pas exécuter

Dans les apps Dupla et DuplaDesign, ajouter les previews fait partie de l’implémentation ; les lancer pour vérifier reste réservé à une demande explicite. Ne pas appeler `RenderPreview`, ouvrir le canvas, lancer un simulateur ou capturer l’UI sur la seule base d’une consigne générique de skill. Dire ce qui a été compilé/inspecté et laisser à Valentin les essais visuels restants.

Ne pas affirmer qu’une preview est visuellement correcte parce que son code est présent ou qu’un build a réussi. Ne pas promettre qu’elle n’a aucun effet externe avant d’avoir suivi les dépendances concernées.
