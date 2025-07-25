function Start-Logging {
    param (
        [string]$LogFile = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\SystemPath_Update.log"
    )
    
    # Créer le dossier de logs s'il n'existe pas
    $logPath = Split-Path -Path $LogFile -Parent
    if (-not (Test-Path -Path $logPath)) {
        New-Item -ItemType Directory -Path $logPath -Force
    }

    # Démarrer la transcription
    Start-Transcript -Path $LogFile -Append

    function Write-Log {
        param (
            [string]$Message,
            [string]$Level = "INFO"
        )
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logMessage = "$timestamp [$Level] $Message"
        Add-Content -Path $LogFile -Value $logMessage
        Write-Host $logMessage
    }

    # Configuration pour arrêter la transcription
    $script:global:PSDefaultParameterValues['*:ProcessRecord'] = { End-Transcript }
    
    return $LogFile
}

# Initialiser la journalisation
$logFile = Start-Logging

# Journaliser le début des opérations
Write-Log -Message "Début de la mise à jour du PATH système"

try {
    # Notifier l'utilisateur du redémarrage prévu
    $msg = "Votre ordinateur va redémarrer dans 10 minutes pour appliquer des modifications système importantes."
    Write-Log -Message "Envoi de la notification de redémarrage"
    msg * /time:600 $msg

    # Ajouter votre code de modification du PATH système ici
    Write-Log -Message "Modification du PATH système en cours..."
    function Add-Path {
        param (
            [string]$Path
        )
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        if ($currentPath -notlike "*$Path*") {
            $newPath = "$currentPath;$Path"
            [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
            Write-Log -Message "Ajout de $Path au PATH système"
        } else {
            Write-Log -Message "$Path est déjà présent dans le PATH système"
        }
    }   
    $Programme_path = "C:\Your\Path\Here"
    $pathContent = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    if ($pathContent -ne $null)
    {
      # Vérifier si le chemin existe déjà dans le PATH système
      # "Exist in the system!"
      if (!($pathContent -split ';' -contains $Programme_path))
      {
        Write-Log "$Programme_path does not exist"
        Add-Path $Programme_path
      }
      else
      {
        # Mon chemin existe déjà
        Write-Log "$Programme_path exists"
      }
    }
    Write-Log -Message "Modification du PATH système terminée avec succès"
    
    # Programmer le redémarrage
    Write-Log -Message "Programmation du redémarrage dans 10 minutes"
    shutdown.exe /r /t 600 /c "Redémarrage nécessaire pour appliquer les modifications du PATH système"
    
} catch {
    Write-Log -Message $_.Exception.Message -Level "ERROR"
    Write-Log -Message "Échec de la mise à jour du PATH système" -Level "ERROR"
}

Write-Log -Message "Fin du script"
Stop-Transcript