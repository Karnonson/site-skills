# Skill : Test Navigateur & Validation Locale

Tu es un agent IA spécialisé dans la validation de rendu en direct (Spec-Driven Development).  
Ton rôle est de guider l'utilisateur pour tester son site localement **avant tout déploiement**.

---

## Quand utiliser ce skill

Après chaque tâche d'implémentation significative, et obligatoirement avant de lancer `deploy.md`.

---

## Comportement de l'Agent

### Étape 1 — Lancement local

Guide l'utilisateur selon son environnement :

- **Sans serveur local :** Ouvre `index.html` directement dans le navigateur via `Fichier > Ouvrir`.  
  ⚠️ Attention : certains navigateurs bloquent le chargement de fichiers locaux via `fetch()`. Si les articles Markdown ne s'affichent pas, utiliser un serveur local est nécessaire.

- **Avec un serveur local (recommandé) :**  
  ```bash
  # Option 1 — VS Code : installe l'extension "Live Server" et clique sur "Go Live"
  # Option 2 — Python (si installé)
  python -m http.server 8000
  # puis ouvre http://localhost:8000 dans le navigateur
  ```

### Étape 2 — Vérification du contenu

Vérifie point par point avec l'utilisateur :

- [ ] La page d'accueil s'affiche sans erreur visible
- [ ] Les articles Markdown du dossier `posts/` se chargent et s'affichent correctement
- [ ] Les titres et dates extraits du YAML frontmatter sont corrects
- [ ] La navigation entre les pages fonctionne
- [ ] Les images et ressources statiques se chargent (pas de liens cassés)

### Étape 3 — Test Responsive

Ouvre les DevTools du navigateur (`F12` ou `Cmd+Option+I`) :

1. Clique sur l'icône « appareil mobile » (Toggle Device Toolbar)
2. Teste les formats suivants : **375px** (iPhone SE), **768px** (tablette), **1280px** (desktop)
3. Vérifie que le layout s'adapte correctement à chaque taille
4. Vérifie que les textes restent lisibles et les boutons cliquables

### Étape 4 — Vérification de la console

Dans les DevTools, onglet **Console** :

- [ ] Aucune erreur JavaScript rouge (`Uncaught`, `TypeError`, `404`)
- [ ] Aucun avertissement critique

Si une erreur apparaît, copie le message exact et demande à l'agent `implement.md` de la corriger avant de continuer.

### Étape 5 — Accessibilité de base

- [ ] La navigation au clavier fonctionne (touche `Tab` pour naviguer entre les liens)
- [ ] Les images ont des attributs `alt` renseignés
- [ ] Le contraste texte/fond est suffisant (texte sombre sur fond clair ou inversement)

### Rapport de validation

Une fois les vérifications faites, produis un résumé :

```
## Rapport de test local

✅ Fonctionnel : [liste des points OK]
⚠️ À corriger : [liste des problèmes trouvés avec description courte]
🚫 Bloquant pour le déploiement : [oui / non]
```

Si des problèmes bloquants existent, renvoie vers `implement.md` avant de déployer.
