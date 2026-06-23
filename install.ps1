# Script d'installation des compétences (Skills) pour agents IA (agentskills.io) en PowerShell.
# Auteur : Karnonson (WebModerne)

param (
    [string]$Choix,
    [string]$DossierCible
)

# Configurer la console pour supporter l'UTF-8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Détecter la source locale ou distante
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$IsLocal = $false
if ($ScriptDir -and (Test-Path "$ScriptDir\skills")) {
    $IsLocal = $true
}

$RawBaseUrl = "https://raw.githubusercontent.com/Karnonson/site-skills/main"

$Skills = @(
    "clarifier",
    "spec",
    "plan",
    "taches",
    "coder",
    "revue",
    "tester",
    "deployer"
)

function Get-SkillFile {
    param (
        [string]$SourceRelatif,
        [string]$DestPath
    )

    $ParentDir = Split-Path -Parent $DestPath
    if (!(Test-Path $ParentDir)) {
        New-Item -ItemType Directory -Path $ParentDir -Force | Out-Null
    }

    if ($IsLocal) {
        Copy-Item "$ScriptDir\$SourceRelatif" $DestPath -Force
    } else {
        # Téléchargement à distance depuis GitHub
        try {
            Invoke-RestMethod -Uri "$RawBaseUrl/$SourceRelatif" -OutFile $DestPath
        } catch {
            Write-Host "Erreur : impossible de télécharger $SourceRelatif ." -ForegroundColor Red
            Exit 1
        }
    }
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "      INSTALLATEUR DE COMPÉTENCES        " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Prépare ton projet pour le pilotage d'agent."
Write-Host ""

if ([string]::IsNullOrWhiteSpace($Choix)) {
    Write-Host "Quel agent de codage utilises-tu ?"
    Write-Host "1) GitHub Copilot" -ForegroundColor Green
    Write-Host "2) Claude Code" -ForegroundColor Green
    Write-Host "3) Autre (Dossier générique .agents)" -ForegroundColor Green
    Write-Host ""

    # Détecter si la session est non interactive
    $argsList = [Environment]::GetCommandLineArgs()
    $isNonInteractive = $argsList | Where-Object { $_ -like '-NonI*' }
    if ($isNonInteractive) {
        Write-Host "Erreur : session non interactive et aucun argument fourni." -ForegroundColor Red
        Write-Host "Usage : .\install.ps1 -Choix <1|2|3> [-DossierCible <chemin>]" -ForegroundColor Red
        Exit 1
    }

    $Choix = Read-Host "Saisis ton choix (1, 2 ou 3) "
    Write-Host ""
}

if ([string]::IsNullOrWhiteSpace($DossierCible)) {
    $argsList = [Environment]::GetCommandLineArgs()
    $isNonInteractive = $argsList | Where-Object { $_ -like '-NonI*' }
    if (!$isNonInteractive) {
        $DossierCible = Read-Host "Où se trouve ton dossier cible ? (Défaut : .) "
    }
    if ([string]::IsNullOrWhiteSpace($DossierCible)) {
        $DossierCible = "."
    }
}

# Créer le dossier s'il n'existe pas
if (!(Test-Path $DossierCible)) {
    New-Item -ItemType Directory -Path $DossierCible -Force | Out-Null
}

switch ($Choix) {
    "1" {
        Write-Host "Installation pour GitHub Copilot..." -ForegroundColor Blue
        
        # 1. Copier le fichier d'instructions générales
        $CopilotInstructionsFile = Join-Path $DossierCible ".github\copilot-instructions.md"
        Get-SkillFile -SourceRelatif "instructions.md" -DestPath $CopilotInstructionsFile

        # Ajouter la référence des compétences dans le fichier principal
        $ExtraInstructions = @"


## Compétences Disponibles

Tu as accès à des compétences spécifiques sous forme de dossiers conformes à agentskills.io.
Ils se trouvent dans '.github/skills/'.
Chaque compétence contient un fichier 'SKILL.md' définissant ses métadonnées et ses consignes.
Lis attentivement ces fichiers avant de commencer chaque phase :
- Pour clarifier l'idée : '.github/skills/clarifier/SKILL.md'
- Pour rédiger le cahier des charges : '.github/skills/spec/SKILL.md'
- Pour concevoir l'architecture : '.github/skills/plan/SKILL.md'
- Pour lister et suivre les tâches : '.github/skills/taches/SKILL.md'
- Pour coder le projet : '.github/skills/coder/SKILL.md'
- Pour faire la revue de code : '.github/skills/revue/SKILL.md'
- Pour tester le site : '.github/skills/tester/SKILL.md'
- Pour déployer le projet : '.github/skills/deployer/SKILL.md'
"@
        Add-Content -Path $CopilotInstructionsFile -Value $ExtraInstructions

        # 2. Installer les compétences individuelles au format agentskills.io
        foreach ($skill in $Skills) {
            Write-Host "Copie du skill agentskills.io : $skill"
            $Dest = Join-Path $DossierCible ".github\skills\$skill\SKILL.md"
            Get-SkillFile -SourceRelatif "skills/$skill/SKILL.md" -DestPath $Dest
        }

        Write-Host ""
        Write-Host "Succès ! Les compétences Copilot sont installées." -ForegroundColor Green
        Write-Host "Retrouve-les dans $DossierCible\.github\ ." -ForegroundColor Yellow
    }

    "2" {
        Write-Host "Installation pour Claude Code..." -ForegroundColor Blue
        
        # 1. Copier le fichier d'instructions générales
        $ClaudeFile = Join-Path $DossierCible "CLAUDE.md"
        Get-SkillFile -SourceRelatif "instructions.md" -DestPath $ClaudeFile

        # Ajouter la référence des compétences dans le fichier principal
        $ExtraInstructions = @"


## Commandes de Référence (Skills)

Les compétences spécifiques se trouvent sous forme de dossiers agentskills.io dans '.claude/skills/'.
Pour charger ou exécuter une compétence, saisis '/' suivi du nom de la compétence (ex: /spec) :
- Pour clarifier ton idée : '/clarifier' ou lis '.claude/skills/clarifier/SKILL.md'
- Pour rédiger les spécifications : '/spec' ou lis '.claude/skills/spec/SKILL.md'
- Pour concevoir le plan technique : '/plan' ou lis '.claude/skills/plan/SKILL.md'
- Pour lister et suivre les tâches : '/taches' ou lis '.claude/skills/taches/SKILL.md'
- Pour implémenter le code : '/coder' ou lis '.claude/skills/coder/SKILL.md'
- Pour faire une revue de code : '/revue' ou lis '.claude/skills/revue/SKILL.md'
- Pour tester dans le navigateur : '/tester' ou lis '.claude/skills/tester/SKILL.md'
- Pour déployer le projet : '/deployer' ou lis '.claude/skills/deployer/SKILL.md'
"@
        Add-Content -Path $ClaudeFile -Value $ExtraInstructions

        # 2. Installer les compétences individuelles au format agentskills.io
        foreach ($skill in $Skills) {
            Write-Host "Copie du skill agentskills.io : $skill"
            $Dest = Join-Path $DossierCible ".claude\skills\$skill\SKILL.md"
            Get-SkillFile -SourceRelatif "skills/$skill/SKILL.md" -DestPath $Dest
        }

        Write-Host ""
        Write-Host "Succès ! Les compétences Claude Code sont installées." -ForegroundColor Green
        Write-Host "Retrouve ton fichier $DossierCible\CLAUDE.md ." -ForegroundColor Yellow
    }

    "3" {
        Write-Host "Installation du dossier générique .agents..." -ForegroundColor Blue
        
        # 1. Copier le fichier d'instructions générales
        $AgentsFile = Join-Path $DossierCible "AGENTS.md"
        Get-SkillFile -SourceRelatif "instructions.md" -DestPath $AgentsFile

        # Ajouter la référence des compétences dans le fichier principal
        $ExtraInstructions = @"


## Compétences Disponibles (Skills)

Les compétences spécifiques se trouvent sous forme de dossiers agentskills.io dans '.agents/skills/'.
Chaque dossier contient un fichier 'SKILL.md' définissant les consignes associées :
- Clarification de l'idée : '.agents/skills/clarifier/SKILL.md' (commande '/clarifier')
- Spécification : '.agents/skills/spec/SKILL.md' (commande '/spec')
- Plan technique : '.agents/skills/plan/SKILL.md' (commande '/plan')
- Liste de tâches : '.agents/skills/taches/SKILL.md' (commande '/taches')
- Implémentation : '.agents/skills/coder/SKILL.md' (commande '/coder')
- Revue de code : '.agents/skills/revue/SKILL.md' (commande '/revue')
- Tests navigateur : '.agents/skills/tester/SKILL.md' (commande '/tester')
- Déploiement : '.agents/skills/deployer/SKILL.md' (commande '/deployer')
"@
        Add-Content -Path $AgentsFile -Value $ExtraInstructions

        # 2. Installer les compétences individuelles au format agentskills.io
        foreach ($skill in $Skills) {
            Write-Host "Copie du skill agentskills.io : $skill"
            $Dest = Join-Path $DossierCible ".agents\skills\$skill\SKILL.md"
            Get-SkillFile -SourceRelatif "skills/$skill/SKILL.md" -DestPath $Dest
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
