@echo off
setlocal

:: URL ZIP-файла
set URL=https://github.com/vayulqq/zapret/releases/download/qedqedndndn/zapret.zip

:: Пути к папке загрузок и рабочему столу
set "DOWNLOADS_PATH=%USERPROFILE%\Downloads"
set "DESKTOP_PATH=%USERPROFILE%\Desktop"

:: Локальный путь для сохранения ZIP-файла
set "ZIP_PATH=%DOWNLOADS_PATH%\zapret.zip"

:: Функция для скачивания файла
echo Скачивание файла...
curl -L %URL% -o "%ZIP_PATH%"
if %errorlevel% neq 0 (
    echo Ошибка при скачивании файла.
    exit /b 1
)
echo Файл успешно скачан: %ZIP_PATH%

:: Проверка существования папки рабочего стола
if not exist "%DESKTOP_PATH%" (
    echo Папка рабочего стола не существует. Создаю её...
    mkdir "%DESKTOP_PATH%"
)

:: Распаковка файла на рабочий стол
echo Распаковка файла...
powershell -Command "Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%DESKTOP_PATH%' -Force"
if %errorlevel% neq 0 (
    echo Ошибка при распаковке файла.
    exit /b 1
)
echo Файлы успешно распакованы в папку: %DESKTOP_PATH%

:: Удаляем ZIP-файл после распаковки
echo Удаление ZIP-файла...
del "%ZIP_PATH%"
if %errorlevel% neq 0 (
    echo Ошибка при удалении ZIP-файла.
    exit /b 1
)
echo ZIP-файл удален.

:: Завершаем выполнение
endlocal
pause
