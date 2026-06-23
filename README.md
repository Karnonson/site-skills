# Site Skills — Compétences d'Orchestration d'Agent

Ce dépôt contient les compétences d'orchestration pour ton agent de codage.
Tu peux installer ces compétences dans n'importe quel projet.
Elles sont structurées selon le standard agentskills.io.

---

## Installation Cross-Plateforme

Choisis la commande adaptée à ton système d'exploitation.
Lance la commande depuis la racine de ton projet cible.

### macOS / Linux / Git Bash

Exécute cette commande dans ton terminal :

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/site-skills/main/install.sh | bash
```

### Windows (PowerShell)

Exécute cette commande dans PowerShell :

```powershell
irm https://raw.githubusercontent.com/Karnonson/site-skills/main/install.ps1 | iex
```

---

## Agents Supportés

Le script d'installation configure automatiquement ton projet selon ton agent :

1. **GitHub Copilot :**
   - Crée `.github/copilot-instructions.md` pour les règles générales.
   - Installe les compétences dans `.github/skills/[nom-skill]/SKILL.md` .

2. **Claude Code :**
   - Crée `CLAUDE.md` pour l'accueil et les commandes de référence.
   - Installe les compétences dans `.claude/skills/[nom-skill]/SKILL.md` .

3. **Autre (Dossier générique) :**
   - Crée `AGENTS.md` pour les règles générales à la racine.
   - Installe les compétences dans `.agents/skills/[nom-skill]/SKILL.md` .

---

## Utilisation des Compétences

Une fois installées, tu peux appeler les compétences dans le chat de ton agent.
Saisis simplement la commande `/` suivie du nom de la compétence.

### Liste des Commandes :

- `/clarifier` : Clarifier ton idée de projet.
- `/spec` : Définir les spécifications fonctionnelles (QUOI).
- `/plan` : Rédiger le plan technique (COMMENT).
- `/taches` : Suivre la liste des tâches à accomplir.
- `/coder` : Lancer l'implémentation complète du code.
- `/revue` : Effectuer une revue de code rigoureuse.
- `/tester` : Valider le rendu dans le navigateur.
- `/deployer` : Déployer ton application en production.
