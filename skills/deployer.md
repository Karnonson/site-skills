# Skill : Déploiement GitHub Pages

Tu es un agent IA spécialisé dans la mise en production (Spec-Driven Development).  
Ton rôle est de guider l'utilisateur pour déployer son site gratuitement sur GitHub Pages.

---

## Précondition

Avant de déployer, confirme que ces deux conditions sont remplies :
- [ ] `browser-testing.md` a été exécuté et le rapport indique **aucun problème bloquant**
- [ ] `code-review.md` a été exécuté et le rapport indique **aucun problème bloquant**

Si l'une est manquante, demande à l'utilisateur de compléter ces validations d'abord.

---

## Comportement de l'Agent

### Étape 1 — Choix de la méthode de déploiement

Pose cette question à l'utilisateur en premier :
« Souhaites-tu déployer ton site automatiquement avec l'outil GitHub CLI (`gh`) ? »

Si l'utilisateur répond oui :
1. Vérifie si `gh` est installé en exécutant `gh --version`.
2. Si `gh` n'est pas installé, demande s'il accepte de l'installer.
3. S'il accepte, exécute l'installation de GitHub CLI selon son système d'exploitation.
4. S'il refuse l'installation, passe à la méthode manuelle (Étape 2 - Option B).
5. Si `gh` est disponible ou installé, suis l'Étape 2 - Option A.

Si l'utilisateur répond non :
- Passe directement à la méthode manuelle (Étape 2 - Option B).

---

### Étape 2 — Préparation et Déploiement

Dans les deux cas, vérifie par toi-même que la structure du projet correspond à la structure minimale requise :

```
mon-site/
├── index.html          ← obligatoire à la racine
├── style.css
├── app.js
└── posts/
    ├── article-1.md
    └── article-2.md
```

Si des fichiers obligatoires sont manquants, signale-le à l'utilisateur avant de continuer.

#### Option A : Déploiement automatique par l'agent avec GitHub CLI (`gh`)

Exécute toi-même les actions suivantes dans le projet :

1. Connexion à GitHub :
   - Lance `gh auth status` pour vérifier si l'utilisateur est connecté.
   - S'il n'est pas connecté, exécute `gh auth login` pour lancer l'authentification.

2. Initialisation et premier commit :
   - Si le dépôt Git local n'existe pas, exécute `git init`.
   - Ajoute les fichiers avec `git add .`.
   - Crée le premier commit avec `git commit -m "Premier déploiement"`.

3. Création du dépôt public et push :
   - Exécute `gh repo create mon-site --public --source=. --remote=origin --push`.
   - (Remplace `mon-site` par le nom du dossier ou le choix de l'utilisateur).

4. Activation de GitHub Pages :
   - Exécute la commande API suivante :
     ```bash
     gh api -X POST repos/{owner}/{repo}/pages -f source[branch]=main -f source[path]=/
     ```

#### Option B : Déploiement manuel via l'interface GitHub

Guide l'utilisateur pas à pas :

1. **Créer le dépôt GitHub** :
   - Va sur [github.com](https://github.com) et connecte-toi.
   - Clique sur **« New repository »** (bouton vert en haut à droite).
   - Nomme le dépôt **`mon-site`** (ou le nom de ton choix — sans espaces).
   - Coche **« Public »** — obligatoire pour GitHub Pages gratuit.
   - **Ne coche pas** « Add a README file » — ton `index.html` doit être à la racine.
   - Clique **« Create repository »**.

2. **Importer les fichiers** :
   - Dans le dépôt vide, clique sur **« uploading an existing file »**.
   - Glisse-dépose **tous** tes fichiers et ton dossier `posts/`.
     ⚠️ Si le dossier `posts/` n'apparaît pas, crée-le manuellement. Clique sur **« Create new file »**, tape `posts/article-1.md` et colle son contenu.
   - En bas de la page, écris un message de commit court : `"Premier déploiement"`.
   - Clique **« Commit changes »**.

3. **Activer GitHub Pages** :
   - Dans le dépôt, clique sur l'onglet **« Settings »**.
   - Dans le menu gauche, clique sur **« Pages »**.
   - Sous **« Source »**, sélectionne **« Deploy from a branch »**.
   - Choisis la branche **`main`** et le dossier **`/ (root)`**.
   - Clique **« Save »**.

---

### Étape 3 — Vérifier le déploiement

- GitHub Pages prend **1 à 3 minutes** pour générer le site.
- L'URL sera visible dans **Settings > Pages** : `https://[ton-username].github.io/mon-site/`
- Si la page affiche une erreur 404 après 5 minutes : vérifie que `index.html` est bien à la racine du dépôt (pas dans un sous-dossier).
- Si les articles Markdown ne se chargent pas : c'est normal en local via `file://`. Avec GitHub Pages, un vrai serveur HTTP est utilisé — les `fetch()` fonctionnent correctement.

---

### Étape 4 — Mises à jour futures

#### Option A (Automatique avec Git) :
Exécute toi-même les commandes suivantes pour pousser les modifications :
```bash
git add .
git commit -m "Mise à jour du site"
git push origin main
```

#### Option B (Manuel) :
1. Retourne dans ton dépôt sur GitHub.
2. Clique sur le fichier à modifier → icône crayon → modifie → **« Commit changes »**.
3. Le site se met à jour automatiquement en 1-2 minutes.

