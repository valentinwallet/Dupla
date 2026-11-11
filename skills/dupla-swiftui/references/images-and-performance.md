# Images et performances

## Chercher d’abord le contrat existant

Une app de photographie gère des originaux, des vignettes, des recadrages et des imports. Un conseil sur `AsyncImage` pour une URL HTTP ne couvre pas nécessairement ces besoins. Lire le pipeline actuel et son contrat avant de créer un chargeur ou un cache.

Dans Blick, lire `docs/IMAGE_LOADING.md` et les services `ImagePipeline`/`DiskMediaStore`. Le pipeline existant utilise Kingfisher et prend en charge cache mémoire/disque, résolutions, orientation, invalidation de sources et mutualisation des demandes. L’import Instagram a un contrat distinct de session/provenance/persistance. Conserver ces frontières.

## Checklist d’une demande d’image

- Distinguer points SwiftUI et pixels. Lire `displayScale` dans l’environnement puis transmettre une cible en pixels au traitement. Ne pas multiplier deux fois une dimension déjà en pixels.
- Calculer la résolution utile selon dimensions affichées, orientation, ratio et zoom. Une miniature suffisante à l’affichage normal peut être insuffisante pour un recadrage agrandi.
- Réduire/décoder hors du MainActor quand le coût le justifie. Le chargement d’un original pour une petite case peut gaspiller beaucoup de mémoire.
- Définir une clé qui tient compte de la source et de sa version, ainsi que des transformations affectant les pixels. Une URL seule n’invalide pas un fichier local remplacé.
- Borner les caches et le travail concurrent selon le contrat existant. La taille compressée d’un JPEG n’est pas sa mémoire une fois décodé.
- Mutualiser une demande identique sans supprimer le travail encore utile à d’autres consommateurs quand une ligne disparaît.
- Éviter de publier une ancienne image après changement de source, taille ou scale. Préserver les invariants d’annulation et les états loading/erreur.
- Ne pas précharger toute la bibliothèque ni générer des composites supplémentaires sans besoin établi.

`AsyncImage` peut suffire pour une image distante simple. Traiter les phases vide/succès/échec. Vérifier la documentation et les headers HTTP avant d’ajouter un cache ; son comportement varie avec le runtime et ne garantit pas le traitement du pipeline local. Les surcharges request/session récentes exigent leurs propres disponibilités.

## Rechercher l’efficacité systématiquement

Appliquer les bonnes pratiques dès la conception, sans attendre une plainte : identité stable, état au bon niveau, travail lourd hors du rendu, résolutions d’images adaptées, annulation et absence de chargements en double. Corriger dans le périmètre travaillé un coût local clairement identifié ; une mesure préalable n’est pas nécessaire pour chaque amélioration simple.

Pour une optimisation structurelle qui ajoute un cache, une égalité personnalisée, des modèles par ligne ou une nouvelle stratégie de rendu, préciser le coût visé, les compromis mémoire/correction/maintenance et le scénario de vérification. S’appuyer sur une analyse concrète ou une mesure quand le bénéfice est incertain. Ne pas annoncer un gain chiffré sans mesure. Garder la modernisation d’API comme une question distincte : une API récente n’accélère pas nécessairement le traitement.

## Diagnostiquer avant de restructurer

Partir du symptôme : ouverture lente, mémoire, scroll, sélection, drag, mise à jour de modèle. Chercher le chemin concerné, puis séparer :

1. Travail répété dans `body`/`init` : décodage, I/O, gros tris, construction de modèles.
2. Invalidation excessive : état trop haut, propriété composée fréquemment modifiée, environnement à chaque frame, identité instable.
3. Rendu/layout : couches lourdes, flous, ombres, géométrie en boucle, nombre de lignes.
4. Attente réelle : I/O synchrone, verrou, synchronisation ou saturation de ressources.

Une collection filtrée dans `ForEach` peut avoir un coût répété sans avoir une identité incorrecte. Un getter de modèle n’est pas un cache. Ne mémoriser une donnée dérivée qu’avec une initialisation et une invalidation complètes ; vérifier le changement de tous ses paramètres et l’état vide.

Réduire les changements rapides en observations utiles : seuil franchi, élément visible, valeur de présentation. Pour un effet visuel de scroll, considérer `visualEffect`/`scrollTransition` sans transférer chaque offset dans un grand store.

Ne pas faire reposer l’architecture sur les détails internes de diffing. Une struct contenant `String` n’est pas un exemple fiable de donnée trivialement comparable bit à bit ; éviter les wrappers dits POD prescrits sans mesure. Une vue `Equatable` doit tenir compte des données qui influent sur son rendu et ne pas figer une action obsolète.

## Mesure et Instruments

Une lecture de code permet de décrire un risque ; elle ne mesure pas un gain. Présenter l’hypothèse, le scénario et l’indicateur à comparer. Dans les apps Dupla, Valentin effectue le parcours manuel ; ne pas lancer app, preview ou enregistrement pour vérifier sans demande explicite.

Si une trace existante est fournie, l’analyser sans lancer de nouvelle session : identifier app/processus, run, intervalle pertinent et pistes enregistrées. Vérifier `xcrun xctrace help` avant d’employer des sous-commandes récentes. Une piste manquante n’indique pas absence de problème.

Corréler durée des hangs/hitches, échantillons, symboles du code, mises à jour SwiftUI et événements de la fenêtre demandée. Un graphe de causes révèle des dépendances candidates, pas une preuve automatique de bug à partir d’un nombre d’arêtes.

Une faible couverture d’échantillons Main Thread peut indiquer une attente, un échantillonnage incomplet ou une contention de la machine. Ne pas convertir les seuils 25/75 % du parser amont en diagnostic certain. `Task.sleep` et une suspension `await` ne bloquent pas leur thread par nature.

Ce package ne contient pas les scripts Instruments amont. Ne pas annoncer un parser disponible ni installer un outil de profilage implicitement. Pour une capture explicitement demandée, définir la cible et une durée/but d’arrêt ; cibler l’app concernée. Ne pas élargir à tous les processus sans autorisation explicite de ce périmètre. Ne pas passer d’un attach en échec au lancement de l’app sans autorisation correspondante.

Après une correction de performance, vérifier la logique, l’annulation et le cache concernés. Rapporter séparément compilation/tests et mesure effective. Retirer les logs de diagnostic temporaires ajoutés pour l’investigation.
