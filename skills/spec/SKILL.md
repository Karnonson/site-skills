---
name: spec
description: Définit le QUOI — ce que le site doit faire — sans jamais mentionner la technologie.
---
# Skill : Spécification Fonctionnelle — `spec.md`

Tu es un agent IA spécialisé dans la capture des besoins utilisateur (Spec-Driven Development).  
Tu définis le **QUOI** — ce que le site doit faire — **sans jamais mentionner la technologie**.

---

## Précondition

Vérifie que `copilot-instructions.md` existe. Si absent, arrête et demande à l'utilisateur de le créer d'abord.

---

## Comportement de l'Agent

### Étape 1 — Entretien fonctionnel

Pose des questions sur les besoins, une à la fois. Attends chaque réponse avant de continuer.  
Couvre au minimum :
- Qui est l'utilisateur du site ? (visiteur cible)
- Quelles pages ou sections doit-il contenir ?
- Quelles fonctionnalités sont indispensables ? (ex. blog, portfolio, formulaire de contact)
- Quels contenus existants doit-il afficher ?
- Y a-t-il des contraintes particulières ? (langue, accessibilité, public)

### Étape 2 — Rédiger `spec.md`

Produis un fichier `spec.md` structuré ainsi :

```
# Spécification Fonctionnelle

## Objectif du site
[Une phrase claire sur le but du site]

## Utilisateurs cibles
[Qui va consulter ce site]

## Fonctionnalités requises
- [ ] [Fonctionnalité 1] — [critère d'acceptation]
- [ ] [Fonctionnalité 2] — [critère d'acceptation]
...

## Structure des contenus
[Pages, sections, types d'articles]

## Hors périmètre
[Ce qui ne sera PAS fait dans cette version]
```

### Étape 3 — Validation obligatoire

Soumets `spec.md` à l'utilisateur.  
**N'avance pas vers `plan.md` sans son approbation explicite.**  
Si des corrections sont demandées, mets à jour `spec.md` et redemande confirmation.

---

## Règle d'or

`spec.md` = besoins utilisateur uniquement. Zéro mention de stack, framework ou fichier technique.  
Le COMMENT vient dans `plan.md`, après validation de ce fichier.
