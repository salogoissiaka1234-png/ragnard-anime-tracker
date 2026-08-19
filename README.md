# Ragnard Anime Tracker

App Flutter pour suivre les sorties d'anime et recevoir des rappels d'épisodes.
Données fournies par l'API publique [Jikan](https://jikan.moe) (basée sur MyAnimeList).

## Fonctionnalités v1
- Liste des animes de la saison en cours
- Recherche d'anime par nom
- Fiche détaillée (synopsis, note, jour de diffusion)
- Suivi d'anime + rappel hebdomadaire automatique le jour de sortie
- Liste personnelle "Mes animes suivis"

---

## Étapes pour builder l'APK sans PC (GitHub + Codemagic)

### 1. Créer le repo GitHub
Déjà fait ✅

### 2. Uploader les fichiers
En cours (création manuelle fichier par fichier)

### 3. Connecter Codemagic
1. Va sur codemagic.io et crée un compte gratuit (connexion via GitHub)
2. Clique Add application, choisis ton repo ragnard-anime-tracker
3. Codemagic détecte automatiquement le fichier codemagic.yaml à la racine
4. Lance le build en cliquant Start new build → workflow android-apk

### 4. Récupérer l'APK
1. Une fois le build terminé (5-10 min), va dans l'onglet Artifacts
2. Télécharge le fichier app-release.apk directement sur ton téléphone
3. Installe-le (autorise "sources inconnues" dans les paramètres Android si demandé)

---

## Prochaines étapes possibles
- Ajouter une icône et un splash screen personnalisés (branding Ragnard Games)
- Filtrer par genre (action, romance, seinen...)
- Widget écran d'accueil Android avec le prochain épisode
- Notifications push au lieu de rappels locaux (nécessite un backend)
