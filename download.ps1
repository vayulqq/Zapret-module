# URL ZIP-файла
$url = "https://github.com/vayulqq/zapret/releases/download/qedqedndndn/zapret.zip"

# Получаем пути к папке загрузок и рабочему столу
$downloadsPath = [System.Environment]::GetFolderPath("Downloads")
$desktopPath = [System.Environment]::GetFolderPath("Desktop")

# Локальный путь для сохранения ZIP-файла
$zipPath = Join-Path -Path $downloadsPath -ChildPath "zapret.zip"

# Функция для скачивания файла с повторной попыткой
Function Download-File {
    param (
        [string]$url,
        [string]$savePath
    )
    $attempts = 3
    $success = $false
    Write-Host "Скачивание файла..."
    
    for ($i = 1; $i -le $attempts; $i++) {
        try {
            Invoke-WebRequest -Uri $url -OutFile $savePath -ErrorAction Stop
            Write-Host "Файл успешно скачан: $savePath"
            $success = $true
            break
        } catch {
            Write-Host "Попытка $i из $attempts: Ошибка при скачивании файла: $_"
            if ($i -eq $attempts) {
                Write-Host "Все попытки скачивания завершились неудачей."
                exit 1
            }
        }
        Start-Sleep -Seconds 2  # Пауза между попытками
    }
}

# Функция для распаковки файла
Function Unpack-Zip {
    param (
        [string]$filePath,
        [string]$extractTo
    )
    Write-Host "Распаковка файла..."
    try {
        # Используем System.IO.Compression.ZipFile для распаковки
        [System.IO.Compression.ZipFile]::ExtractToDirectory($filePath, $extractTo)
        Write-Host "Файлы успешно распакованы в папку: $extractTo"
    } catch {
        Write-Host "Ошибка при распаковке файла: $_"
        exit 1
    } finally {
        # Удаляем ZIP-файл после распаковки
        if (Test-Path $filePath) {
            Remove-Item -Path $filePath -Force
            Write-Host "ZIP-файл удален."
        }
    }
}

# Проверка и создание папки загрузок, если она не существует
If (-Not (Test-Path $downloadsPath)) {
    Write-Host "Папка загрузок не существует. Создаю её..."
    New-Item -ItemType Directory -Path $downloadsPath | Out-Null
} else {
    Write-Host "Папка загрузок существует: $downloadsPath"
}

# Проверка существования папки рабочего стола
If (-Not (Test-Path $desktopPath)) {
    Write-Host "Папка рабочего стола не существует. Создаю её..."
    New-Item -ItemType Directory -Path $desktopPath | Out-Null
} else {
    Write-Host "Папка рабочего стола существует: $desktopPath"
}

# Основной процесс
try {
    Write-Host "Рабочая платформа: $($env:OS)"
    
    # Скачиваем файл
    Download-File -url $url -savePath $zipPath
    
    # Распаковываем файл на рабочий стол
    Unpack-Zip -filePath $zipPath -extractTo $desktopPath
} catch {
    Write-Host "Произошла ошибка: $_"
}