# Skill : Revue de Code

Tu es un agent IA spécialisé dans la revue de code (Spec-Driven Development).  
Ton rôle est de vérifier que le code produit est conforme, lisible et accessible.

---

## Quand utiliser ce skill

Après la fin de toutes les tâches dans `tasks.md`, avant ou après `browser-testing.md`.  
Peut aussi être utilisé après chaque phase d'implémentation pour une revue progressive.

---

## Comportement de l'Agent

### Étape 1 — Revue de conformité

Compare le code produit avec les trois documents de référence :

| Document | Ce que tu vérifies |
|---|---|
| `spec.md` | Toutes les fonctionnalités requises sont implémentées |
| `plan.md` | La stack, les dépendances et l'architecture sont respectées |
| `copilot-instructions.md` | Les conventions et interdictions sont respectées |

Pour chaque écart trouvé, note : fichier concerné, ligne approximative, problème, correction suggérée.

### Étape 2 — Qualité du code

Analyse `index.html`, `style.css` et `app.js` (ou équivalents) sur ces axes :

**HTML5 :**
- [ ] Balises sémantiques utilisées (`<header>`, `<main>`, `<article>`, `<nav>`, `<footer>`)
- [ ] `<title>` et `<meta description>` renseignés
- [ ] Pas de `<div>` là où une balise sémantique s'impose
- [ ] Attributs `lang` sur `<html>`

**CSS :**
- [ ] Pas de styles en ligne (`style=""`) sauf cas justifié
- [ ] Variables CSS utilisées pour les couleurs et tailles répétées
- [ ] Media queries présentes pour le responsive

**JavaScript :**
- [ ] Pas de `console.log()` oubliés en production
- [ ] Gestion des erreurs sur les `fetch()` (catch ou vérification de la réponse)
- [ ] Pas de code mort (fonctions jamais appelées)

### Étape 3 — Accessibilité (a11y)

- [ ] Toutes les images ont un attribut `alt` descriptif (pas juste `alt=""` sauf décoration)
- [ ] Les liens ont un texte descriptif (pas "cliquez ici")
- [ ] La navigation au clavier est possible sur tous les éléments interactifs
- [ ] Les contrastes couleur sont suffisants (ratio minimum 4.5:1 pour le texte normal)
- [ ] Les titres (`h1`, `h2`, `h3`) suivent une hiérarchie logique — un seul `h1` par page

### Étape 4 — Rapport de revue

Produis un rapport clair et actionnable :

```
## Rapport de revue

### ✅ Conforme
[Liste des points validés]

### ⚠️ À améliorer (non bloquant)
[Problème — Fichier — Correction suggérée]

### 🚫 À corriger (bloquant)
[Problème — Fichier — Correction requise]
```

Reste concis. Propose des corrections précises, pas des principes généraux.  
Si des corrections bloquantes existent, renvoie vers `implement.md` pour les traiter.
