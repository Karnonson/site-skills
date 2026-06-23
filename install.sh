#!/usr/bin/env bash

# Script d'installation des compétences (Skills) pour agents IA.
# Auteur : Karnonson (WebModerne)

# Couleurs pour l'affichage console (esthétique premium)
ROUGE='\033[0;31m'
VERT='\033[0;32m'
BLEU='\033[0;34m'
CYAN='\033[0;36m'
JAUNE='\033[0;33m'
NEUTRE='\033[0m'

# Détecter la source locale ou distante
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd 2>/dev/null)"
IS_LOCAL=false
if [ -d "$SCRIPT_DIR/skills" ]; then
  IS_LOCAL=true
fi

RAW_BASE_URL="https://raw.githubusercontent.com/Karnonson/site-skills/main/skills"

SKILLS=(
  "clarifier.md"
  "spec.md"
  "plan.md"
  "taches.md"
  "coder.md"
  "revue.md"
  "tester.md"
  "deployer.md"
)

# Fonction de téléchargement ou copie
recuperer_fichier() {
  local source_nom="$1"
  local dest_path="$2"

  if [ "$IS_LOCAL" = true ]; then
    cp "$SCRIPT_DIR/skills/$source_nom" "$dest_path"
  else
    if command -v curl >/dev/null 2>&1; then
      curl -fsSL "$RAW_BASE_URL/$source_nom" -o "$dest_path"
    elif command -v wget >/dev/null 2>&1; then
      wget -q "$RAW_BASE_URL/$source_nom" -O "$dest_path"
    else
      echo -e "${ROUGE}Erreur : ni curl ni wget n'est disponible.${NEUTRE}"
      exit 1
    fi
  fi
}

echo -e "${CYAN}=========================================${NEUTRE}"
echo -e "${CYAN}      INSTALLATEUR DE COMPÉTENCES        ${NEUTRE}"
echo -e "${CYAN}=========================================${NEUTRE}"
echo -e "Prépare ton projet pour le pilotage d'agent."
echo ""

# Choix de l'agent
echo -e "Quel agent de codage utilises-tu ?"
echo -e "1) ${VERT}GitHub Copilot${NEUTRE}"
echo -e "2) ${VERT}Claude Code${NEUTRE}"
echo -e "3) ${VERT}Autre${NEUTRE} (Dossier générique .agents)"
echo ""
read -r -p "Saisis ton choix (1, 2 ou 3) : " CHOIX
echo ""

# Choix du dossier cible
read -r -p "Où se trouve ton dossier cible ? (Défaut : .) : " DOSSIER_CIBLE
if [ -z "$DOSSIER_CIBLE" ]; then
  DOSSIER_CIBLE="."
fi

# Créer le dossier s'il n'existe pas
mkdir -p "$DOSSIER_CIBLE"

# Exécution de l'installation selon le choix
case "$CHOIX" in
  1)
    echo -e "${BLEU}Installation pour GitHub Copilot...${NEUTRE}"
    
    # Créer l'arborescence Copilot
    mkdir -p "$DOSSIER_CIBLE/.github/skills"
    
    # 1. Installer le fichier principal copilot-instructions.md
    recuperer_fichier "copilot-instructions.md" "$DOSSIER_CIBLE/.github/copilot-instructions.md"
    
    # Ajouter la référence des compétences dans le fichier principal
    {
      echo ""
      echo "## Compétences Disponibles"
      echo ""
      echo "Tu as accès à des compétences spécifiques sous forme de fichiers Markdown."
      echo "Ils sont situés dans le dossier '.github/skills/'."
      echo "Lis attentivement ces fichiers avant de commencer chaque phase :"
      echo "- Pour clarifier l'idée : '.github/skills/clarifier.md'"
      echo "- Pour rédiger le cahier des charges : '.github/skills/spec.md'"
      echo "- Pour concevoir l'architecture : '.github/skills/plan.md'"
      echo "- Pour lister et suivre les tâches : '.github/skills/taches.md'"
      echo "- Pour coder le projet : '.github/skills/coder.md'"
      echo "- Pour faire la revue de code : '.github/skills/revue.md'"
      echo "- Pour tester le site : '.github/skills/tester.md'"
      echo "- Pour déployer le projet : '.github/skills/deployer.md'"
    } >> "$DOSSIER_CIBLE/.github/copilot-instructions.md"

    # 2. Installer les compétences individuelles
    for skill in "${SKILLS[@]}"; do
      echo -e "Copie de la compétence : $skill"
      recuperer_fichier "$skill" "$DOSSIER_CIBLE/.github/skills/$skill"
    done
    
    echo ""
    echo -e "${VERT}Succès ! Les compétences Copilot sont installées.${NEUTRE}"
    echo -e "Retrouve-les dans ${JAUNE}$DOSSIER_CIBLE/.github/${NEUTRE} ."
    ;;

  2)
    echo -e "${BLEU}Installation pour Claude Code...${NEUTRE}"
    
    # Créer l'arborescence Claude Code
    mkdir -p "$DOSSIER_CIBLE/.claude/skills"
    
    # 1. Créer le fichier CLAUDE.md général
    cat << 'EOF' > "$DOSSIER_CIBLE/CLAUDE.md"
# Projet Orchestré

Ce projet utilise le Spec-Driven Development (développement dirigé par les spécifications).
Les compétences détaillées de l'agent se trouvent dans le dossier `.claude/skills/`.

## Commandes de Référence

- Pour clarifier ton idée : `/clarifier` ou lis `.claude/skills/clarifier.md`
- Pour rédiger les spécifications : `/spec` ou lis `.claude/skills/spec.md`
- Pour concevoir le plan technique : `/plan` ou lis `.claude/skills/plan.md`
- Pour lister et suivre les tâches : `/taches` ou lis `.claude/skills/taches.md`
- Pour implémenter le code : `/coder` ou lis `.claude/skills/coder.md`
- Pour faire une revue de code : `/revue` ou lis `.claude/skills/revue.md`
- Pour tester dans le navigateur : `/tester` ou lis `.claude/skills/tester.md`
- Pour déployer le projet : `/deployer` ou lis `.claude/skills/deployer.md`
EOF

    # 2. Installer les compétences individuelles
    for skill in "${SKILLS[@]}"; do
      echo -e "Copie de la compétence : $skill"
      recuperer_fichier "$skill" "$DOSSIER_CIBLE/.claude/skills/$skill"
    done
    
    echo ""
    echo -e "${VERT}Succès ! Les compétences Claude Code sont installées.${NEUTRE}"
    echo -e "Retrouve ton fichier ${JAUNE}$DOSSIER_CIBLE/CLAUDE.md${NEUTRE} ."
    ;;

  3)
    echo -e "${BLEU}Installation du dossier générique .agents...${NEUTRE}"
    
    # Créer l'arborescence générique
    mkdir -p "$DOSSIER_CIBLE/.agents/skills"
    
    # 1. Créer le fichier AGENTS.md général
    cat << 'EOF' > "$DOSSIER_CIBLE/AGENTS.md"
# Orchestration des Agents

Les règles générales et les compétences pour guider les agents de codage.
Les compétences détaillées se trouvent dans le dossier `.agents/skills/`.

## Compétences Disponibles

- Clarification de l'idée : `/clarifier` ou `.agents/skills/clarifier.md`
- Spécification : `/spec` ou `.agents/skills/spec.md`
- Plan technique : `/plan` ou `.agents/skills/plan.md`
- Liste de tâches : `/taches` ou `.agents/skills/taches.md`
- Implémentation : `/coder` ou `.agents/skills/coder.md`
- Revue de code : `/revue` ou `.agents/skills/revue.md`
- Tests navigateur : `/tester` ou `.agents/skills/tester.md`
- Déploiement : `/deployer` ou `.agents/skills/deployer.md`
EOF

    # 2. Installer les compétences individuelles
    for skill in "${SKILLS[@]}"; do
      echo -e "Copie de la compétence : $skill"
      recuperer_fichier "$skill" "$DOSSIER_CIBLE/.agents/skills/$skill"
    done
    
    echo ""
    echo -e "${VERT}Succès ! Les compétences génériques sont installées.${NEUTRE}"
    echo -e "Retrouve ton fichier ${JAUNE}$DOSSIER_CIBLE/AGENTS.md${NEUTRE} ."
    ;;

  *)
    echo -e "${ROUGE}Erreur : choix invalide.${NEUTRE}"
    exit 1
    ;;
esac
