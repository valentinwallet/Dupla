# API spécialisées

Lire uniquement la section liée à la demande, puis vérifier les déclarations et la documentation Apple pertinentes. Ces sujets ne doivent pas alourdir une correction SwiftUI ordinaire.

## Swift Charts

- Importer `Charts` explicitement et choisir des données à identité stable.
- Donner des noms sémantiques aux valeurs : axes, légendes et accessibilité en dépendent.
- Appliquer les modificateurs de graphique au conteneur, ceux de mark au mark.
- Pour des séries catégorielles, conserver une correspondance stable entre catégorie, style et symbole ; utiliser les tokens Dupla et une distinction au-delà de la couleur.
- Une sélection X/Y/angle renvoie une valeur du domaine, pas directement le modèle. Prévoir le rapprochement voulu et le cas sans sélection.
- Gérer données vides, domaines constants ou dégénérés, points manquants et densité des labels. Une vue liste/table peut être un complément accessible.
- Vérifier les disponibilités séparées des marks, sélections, plots vectorisés et Chart3D. Ne pas introduire la 3D sans un besoin produit.

## Documents

Une tâche de stockage métier n’est pas une migration vers `DocumentGroup`. Pour une app réellement documentaire, préserver lecture, écriture, types de contenu, autosave, undo/redo et coordination des accès.

Les nouveaux protocoles `Document`/reader/writer décrits dans les sources exigent des OS récents. Pour une ancienne cible, conserver `FileDocument`/`ReferenceFileDocument` quand ils répondent au contrat. Vérifier la détection de modifications et l’enregistrement d’undo avec le modèle choisi ; ne pas supposer qu’une propriété observée garantit à elle seule l’autosave.

Garder snapshots cohérents, travail I/O hors des mutations d’interface, gestion d’erreur et coordination requise. Une écriture incrémentale de package complexifie les invariants ; la réserver à un coût établi. Ne pas changer le format utilisateur ou les migrations sans demande.

## WebKit

Vérifier si `WebView`/`WebPage` natifs couvrent le contrat sur la cible. `WKWebView` peut rester nécessaire pour macOS 14, des intégrations existantes ou une capacité spécifique.

Définir avant création le datastore et les préférences voulus. Conserver explicitement le contrat cookies/session. En preview Blick, datastore non persistant et HTML local sans chargement externe.

Un changement SwiftUI sans rapport ne doit pas recharger la page. Distinguer URL demandée, URL effectivement visitée et événement de navigation. Respecter annulation et terminaison du contenu web. Pour le JavaScript, transmettre des arguments plutôt qu’interpoler des données non échappées dans le code.

Ne pas remplacer une politique de navigation/authentification ou une validation de provenance par un simple affichage d’URL. Ces comportements appartiennent à la fonctionnalité de l’app.

## Texte enrichi

Pour du texte court ou des notes, utiliser le contrôle existant adapté ; ne pas transformer toute saisie multiligne en éditeur riche. `TextEditor` avec `AttributedString` et ses sélections requiert ses propres versions d’OS.

Une mutation de texte peut invalider des indices. Utiliser les opérations qui mettent à jour la sélection et traiter les sélections discontinues. Lire les attributs au point d’insertion pour les contrôles de formatage ; conserver les styles Dupla et les contraintes réellement souhaitées.

`Text` n’est pas un moteur Markdown de documents complet. Pour titres, listes ou blocs, choisir une représentation appropriée au contenu et au projet ; ne pas prétendre qu’un simple littéral `Text` restitue toute la syntaxe.

## Liquid Glass

Ne pas convertir spontanément le thème Dupla Atelier en Liquid Glass. Les matériaux que le système applique à son chrome peuvent coexister avec l’app ; ils ne justifient pas une migration des cartes et contrôles de marque.

Si une adoption est demandée : identifier les surfaces, les états et le repli Dupla ; vérifier plateformes et cibles ; étendre le design system si la variante est réutilisable. Respecter Reduce Transparency et le contraste. Pour des effets regroupés, utiliser les conteneurs natifs appropriés et éviter les doubles couches de matériau.

Ne pas copier les helpers de fallback amont sans vérifier les types de leur signature : un type récent utilisé comme paramètre peut rendre le helper indisponible avant même sa branche `#available`. Ne pas inventer de valeur `Glass.prominent` ni de modificateur de transition plausible mais absent du SDK.
