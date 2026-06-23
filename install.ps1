# Script d'installation des compétences (Skills) pour agents IA en PowerShell.
# Auteur : Karnonson (WebModerne)

# Configurer la console pour supporter l'UTF-8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Détecter la source locale ou distante
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$IsLocal = $false
if ($ScriptDir -and (Test-Path "$ScriptDir\skills")) {
    $IsLocal = $true
}

$RawBaseUrl = "https://raw.githubusercontent.com/Karnonson/site-skills/main/skills"

$Skills = @(
    "clarifier.md",
    "spec.md",
    "plan.md",
    "taches.md",
    "coder.md",
    "revue.md",
    "tester.md",
    "deployer.md"
)

function Get-SkillFile {
    param (
        [string]$SourceNom,
        [string]$DestPath
    )

    if ($IsLocal) {
        Copy-Item "$ScriptDir\skills\$SourceNom" $DestPath -Force
    } else {
        # Téléchargement à distance depuis GitHub
        try {
            Invoke-RestMethod -Uri "$RawBaseUrl/$SourceNom" -OutFile $DestPath
        } catch {
            Write-Host "Erreur : impossible de télécharger $SourceNom ." -ForegroundColor Red
            Exit 1
        }
    }
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "      INSTALLATEUR DE COMPÉTENCES        " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Prépare ton projet pour le pilotage d'agent."
Write-Host ""

Write-Host "Quel agent de codage utilises-tu ?"
Write-Host "1) GitHub Copilot" -ForegroundColor Green
Write-Host "2) Claude Code" -ForegroundColor Green
Write-Host "3) Autre (Dossier générique .agents)" -ForegroundColor Green
Write-Host ""

$Choix = Read-Host "Saisis ton choix (1, 2 ou 3) "
Write-Host ""

$DossierCible = Read-Host "Où se trouve ton dossier cible ? (Défaut : .) "
if ([string]::IsNullOrWhiteSpace($DossierCible)) {
    $DossierCible = "."
}

# Créer le dossier s'il n'existe pas
if (!(Test-Path $DossierCible)) {
    New-Item -ItemType Directory -Path $DossierCible -Force | Out-Null
}

switch ($Choix) {
    "1" {
        Write-Host "Installation pour GitHub Copilot..." -ForegroundColor Blue
        
        $SkillsDir = Join-Path $DossierCible ".github\skills"
        if (!(Test-Path $SkillsDir)) {
            New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
        }

        # 1. Installer le fichier principal copilot-instructions.md
        $CopilotInstructionsFile = Join-Path $DossierCible ".github\copilot-instructions.md"
        Get-SkillFile -SourceNom "copilot-instructions.md" -DestPath $CopilotInstructionsFile

        # Ajouter la référence des compétences dans le fichier principal
        $ExtraInstructions = @"


## Compétences Disponibles

Tu as accès à des compétences spécifiques sous forme de fichiers Markdown.
Ils sont situés dans le dossier '.github/skills/'.
Lis attentivement ces fichiers avant de commencer chaque phase :
- Pour clarifier l'idée : '.github/skills/clarifier.md'
- Pour rédiger le cahier des charges : '.github/skills/spec.md'
- Pour concevoir l'architecture : '.github/skills/plan.md'
- Pour lister et suivre les tâches : '.github/skills/taches.md'
- Pour coder le projet : '.github/skills/coder.md'
- Pour faire la revue de code : '.github/skills/revue.md'
- Pour tester le site : '.github/skills/tester.md'
- Pour déployer le projet : '.github/skills/deployer.md'
"@
        Add-Content -Path $CopilotInstructionsFile -Value $ExtraInstructions

        # 2. Installer les compétences individuelles
        foreach ($skill in $Skills) {
            Write-Host "Copie de la compétence : $skill"
            $Dest = Join-Path $SkillsDir $skill
            Get-SkillFile -SourceNom $skill -DestPath $Dest
        }

        Write-Host ""
        Write-Host "Succès ! Les compétences Copilot sont installées." -ForegroundColor Green
        Write-Host "Retrouve-les dans $DossierCible\.github\ ." -ForegroundColor Yellow
    }

    "2" {
        Write-Host "Installation pour Claude Code..." -ForegroundColor Blue
        
        $SkillsDir = Join-Path $DossierCible ".claude\skills"
        if (!(Test-Path $SkillsDir)) {
            New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
        }

        # 1. Créer le fichier CLAUDE.md général
        $ClaudeFile = Join-Path $DossierCible "CLAUDE.md"
        $ClaudeContent = @"
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
"@
        Set-Content -Path $ClaudeFile -Value $ClaudeContent -Encoding UTF8

        # 2. Installer les compétences individuelles
        foreach ($skill in $Skills) {
            Write-Host "Copie de la compétence : $skill"
            $Dest = Join-Path $SkillsDir $skill
            Get-SkillFile -SourceNom $skill -DestPath $Dest
        }

        Write-Host ""
        Write-Host "Succès ! Les compétences Claude Code sont installées." -ForegroundColor Green
        Write-Host "Retrouve ton fichier $DossierCible\CLAUDE.md ." -ForegroundColor Yellow
    }

    "3" {
        Write-Host "Installation du dossier générique .agents..." -ForegroundColor Blue
        
        $SkillsDir = Join-Path $DossierCible ".agents\skills"
        if (!(Test-Path $SkillsDir)) {
            New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
        }

        # 1. Créer le fichier AGENTS.md général
        $AgentsFile = Join-Path $DossierCible "AGENTS.md"
        $AgentsContent = @"
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
"@
        Set-Content -Path $AgentsFile -Value $AgentsContent -Encoding UTF8

        # 2. Installer les compétences individuelles
        foreach ($skill in $Skills) {
            Write-Host "Copie de la compétence : $skill"
            $Dest = Join-Path $SkillsDir $skill
            Get-SkillFile -SourceNom $skill -DestPath $Dest
        }

        Write-Host ""
        Write-Host "Succès ! Les compétences génériques sont installées." -ForegroundColor Green
        Write-Host "Retrouve ton fichier $DossierCible\AGENTS.md ." -ForegroundColor Yellow
    }

    default {
        Write-Host "Erreur : choix invalide." -ForegroundColor Red
        Exit 1
    }
}
