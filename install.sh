#!/usr/bin/env bash

# Script d'installation des compétences (Skills) pour agents IA (agentskills.io).
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

RAW_BASE_URL="https://raw.githubusercontent.com/Karnonson/site-skills/main"

SKILLS=(
  "clarifier"
  "spec"
  "plan"
  "taches"
  "coder"
  "revue"
  "tester"
  "deployer"
)

# Fonction de téléchargement ou copie
recuperer_fichier() {
  local source_relatif="$1"
  local dest_path="$2"

  # Assurer la création du dossier parent
  mkdir -p "$(dirname "$dest_path")"

  if [ "$IS_LOCAL" = true ]; then
    cp "$SCRIPT_DIR/$source_relatif" "$dest_path"
  else
    if command -v curl >/dev/null 2>&1; then
      curl -fsSL "$RAW_BASE_URL/$source_relatif" -o "$dest_path"
    elif command -v wget >/dev/null 2>&1; then
      wget -q "$RAW_BASE_URL/$source_relatif" -O "$dest_path"
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

CHOIX="$1"
DOSSIER_CIBLE="$2"

# Déterminer si un terminal interactif ou /dev/tty est disponible
HAS_TTY=false
if [ -t 0 ]; then
  HAS_TTY=true
elif ( true < /dev/tty ) 2>/dev/null; then
  HAS_TTY=true
fi

# Fonction pour lire une entrée de manière robuste
lire_entree() {
  local prompt="$1"
  local var_name="$2"
  local default_val="$3"
  local val=""

  if [ -t 0 ]; then
    read -r -p "$prompt" val
  elif ( true < /dev/tty ) 2>/dev/null; then
    read -r -p "$prompt" val < /dev/tty
  else
    val="$default_val"
  fi

  if [ -z "$val" ]; then
    val="$default_val"
  fi

  eval "$var_name=\"\$val\""
}

# Choix de l'agent
if [ -z "$CHOIX" ]; then
  echo -e "Quel agent de codage utilises-tu ?"
  echo -e "1) ${VERT}GitHub Copilot${NEUTRE}"
  echo -e "2) ${VERT}Claude Code${NEUTRE}"
  echo -e "3) ${VERT}Autre${NEUTRE} (Dossier générique .agents)"
  echo ""

  if [ "$HAS_TTY" = false ]; then
    echo -e "${ROUGE}Erreur : script non interactif et aucun argument fourni.${NEUTRE}"
    echo -e "Usage : curl -fsSL ... | bash -s -- <choix_agent> [dossier_cible]"
    exit 1
  fi

  lire_entree "Saisis ton choix (1, 2 ou 3) : " CHOIX
  echo ""
fi

# Choix du dossier cible
if [ -z "$DOSSIER_CIBLE" ]; then
  lire_entree "Où se trouve ton dossier cible ? (Défaut : .) : " DOSSIER_CIBLE "."
fi

# Créer le dossier s'il n'existe pas
mkdir -p "$DOSSIER_CIBLE"

# Exécution de l'installation selon le choix
case "$CHOIX" in
  1)
    echo -e "${BLEU}Installation pour GitHub Copilot...${NEUTRE}"
    
    # 1. Copier le fichier d'instructions générales
    recuperer_fichier "instructions.md" "$DOSSIER_CIBLE/.github/copilot-instructions.md"
    
    # Ajouter la référence des compétences dans le fichier principal
    {
      echo ""
      echo "## Compétences Disponibles"
      echo ""
      echo "Tu as accès à des compétences spécifiques sous forme de dossiers conformes à agentskills.io."
      echo "Ils se trouvent dans '.github/skills/'."
      echo "Chaque compétence contient un fichier 'SKILL.md' définissant ses métadonnées et ses consignes."
      echo "Lis attentivement ces fichiers avant de commencer chaque phase :"
      echo "- Pour clarifier l'idée (génère 'idee.md') : '.github/skills/clarifier/SKILL.md'"
      echo "- Pour rédiger le cahier des charges (génère 'spec.md') : '.github/skills/spec/SKILL.md'"
      echo "- Pour concevoir l'architecture (génère 'plan.md') : '.github/skills/plan/SKILL.md'"
      echo "- Pour lister et suivre les tâches (génère 'tasks.md') : '.github/skills/taches/SKILL.md'"
      echo "- Pour coder le projet : '.github/skills/coder/SKILL.md'"
      echo "- Pour faire la revue de code : '.github/skills/revue/SKILL.md'"
      echo "- Pour tester le site : '.github/skills/tester/SKILL.md'"
      echo "- Pour déployer le projet : '.github/skills/deployer/SKILL.md'"
    } >> "$DOSSIER_CIBLE/.github/copilot-instructions.md"

    # 2. Installer les compétences individuelles au format agentskills.io
    for skill in "${SKILLS[@]}"; do
      echo -e "Copie du skill agentskills.io : $skill"
      recuperer_fichier "skills/$skill/SKILL.md" "$DOSSIER_CIBLE/.github/skills/$skill/SKILL.md"
    done
    
    echo ""
    echo -e "${VERT}Succès ! Les compétences Copilot sont installées.${NEUTRE}"
    echo -e "Retrouve-les dans ${JAUNE}$DOSSIER_CIBLE/.github/${NEUTRE} ."
    ;;

  2)
    echo -e "${BLEU}Installation pour Claude Code...${NEUTRE}"
    
    # 1. Copier le fichier d'instructions générales
    recuperer_fichier "instructions.md" "$DOSSIER_CIBLE/CLAUDE.md"
    
    # Ajouter la référence des compétences dans le fichier principal
    {
      echo ""
      echo "## Commandes de Référence (Skills)"
      echo ""
      echo "Les compétences spécifiques se trouvent sous forme de dossiers agentskills.io dans '.claude/skills/'."
      echo "Pour charger ou exécuter une compétence, saisis '/' suivi du nom de la compétence (ex: /spec) :"
      echo "- Pour clarifier ton idée (génère 'idee.md') : '/clarifier' ou lis '.claude/skills/clarifier/SKILL.md'"
      echo "- Pour rédiger les spécifications (génère 'spec.md') : '/spec' ou lis '.claude/skills/spec/SKILL.md'"
      echo "- Pour concevoir le plan technique (génère 'plan.md') : '/plan' ou lis '.claude/skills/plan/SKILL.md'"
      echo "- Pour lister et suivre les tâches (génère 'tasks.md') : '/taches' ou lis '.claude/skills/taches/SKILL.md'"
      echo "- Pour implémenter le code : '/coder' ou lis '.claude/skills/coder/SKILL.md'"
      echo "- Pour faire une revue de code : '/revue' ou lis '.claude/skills/revue/SKILL.md'"
      echo "- Pour tester dans le navigateur : '/tester' ou lis '.claude/skills/tester/SKILL.md'"
      echo "- Pour déployer le projet : '/deployer' ou lis '.claude/skills/deployer/SKILL.md'"
    } >> "$DOSSIER_CIBLE/CLAUDE.md"

    # 2. Installer les compétences individuelles au format agentskills.io
    for skill in "${SKILLS[@]}"; do
      echo -e "Copie du skill agentskills.io : $skill"
      recuperer_fichier "skills/$skill/SKILL.md" "$DOSSIER_CIBLE/.claude/skills/$skill/SKILL.md"
    done
    
    echo ""
    echo -e "${VERT}Succès ! Les compétences Claude Code sont installées.${NEUTRE}"
    echo -e "Retrouve ton fichier ${JAUNE}$DOSSIER_CIBLE/CLAUDE.md${NEUTRE} ."
    ;;

  3)
    echo -e "${BLEU}Installation du dossier générique .agents...${NEUTRE}"
    
    # 1. Copier le fichier d'instructions générales
    recuperer_fichier "instructions.md" "$DOSSIER_CIBLE/AGENTS.md"
    
    # Ajouter la référence des compétences dans le fichier principal
    {
      echo ""
      echo "## Compétences Disponibles (Skills)"
      echo ""
      echo "Les compétences spécifiques se trouvent sous forme de dossiers agentskills.io dans '.agents/skills/'."
      echo "Chaque dossier contient un fichier 'SKILL.md' définissant les consignes associées :"
      echo "- Clarification de l'idée (génère 'idee.md') : '.agents/skills/clarifier/SKILL.md' (commande '/clarifier')"
      echo "- Spécification (génère 'spec.md') : '.agents/skills/spec/SKILL.md' (commande '/spec')"
      echo "- Plan technique (génère 'plan.md') : '.agents/skills/plan/SKILL.md' (commande '/plan')"
      echo "- Liste de tâches (génère 'tasks.md') : '.agents/skills/taches/SKILL.md' (commande '/taches')"
      echo "- Implémentation : '.agents/skills/coder/SKILL.md' (commande '/coder')"
      echo "- Revue de code : '.agents/skills/revue/SKILL.md' (commande '/revue')"
      echo "- Tests navigateur : '.agents/skills/tester/SKILL.md' (commande '/tester')"
      echo "- Déploiement : '.agents/skills/deployer/SKILL.md' (commande '/deployer')"
    } >> "$DOSSIER_CIBLE/AGENTS.md"

    # 2. Installer les compétences individuelles au format agentskills.io
    for skill in "${SKILLS[@]}"; do
      echo -e "Copie du skill agentskills.io : $skill"
      recuperer_fichier "skills/$skill/SKILL.md" "$DOSSIER_CIBLE/.agents/skills/$skill/SKILL.md"
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
