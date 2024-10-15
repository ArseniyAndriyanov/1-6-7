@echo off
setlocal enabledelayedexpansion
@rem chcp 65001
C:\Windows\System32\chcp.com 65001 >nul

set "path=C:\Users\User\laba\log"
set "backup_path=C:\Users\User\laba\backup"
set "script1=C:\Users\User\laba\script1.bat"



echo Тест 1: 1 файл весом 100МБ в папке
C:\Windows\System32\fsutil.exe file createnew C:\Users\User\laba\log\file1.txt 104857600

rem Получение размера папки log
set /a totalsize=0
for /r "%path%" %%F in (*) do (
  set /a totalsize+=%%~zF
)
set /a foldersize=totalsize/1024

rem Получение размера папки backup
set /a totalsizeb=0
for /r "%backup_path%" %%F in (*) do (
    set /a totalsizeb+=%%~zF
)
set /a backupsize=totalsizeb/1024

echo Изначальный вес папки log: !foldersize! K, папки backup: !backupsize! K

call "%script1%"

rem Получение нового размера папки log
set /a totalsize=0
for /r "%path%" %%F in (*) do (
  set /a totalsize+=%%~zF
)
set /a foldersize=totalsize/1024

rem Получение размера папки backup
set /a totalsizeb=0
for /r "%backup_path%" %%F in (*) do (
    set /a totalsizeb+=%%~zF
)
set /a backupsize=totalsizeb/1024

if !foldersize! lss 204800 if "!backupsize!"=="0" (
    echo Тест 1 пройден. Вес папки log: !foldersize! K, вес папки backup: !backupsize! K
) else (
    echo Тест 1 не пройден. Вес папки log: !foldersize! K, вес папки backup: !backupsize! K
)

rem Очистка папок после теста
del /Q "%path%\*"
del /Q "%backup_path%\*"
echo.




echo Тест 2: 1 файл весом 800МБ в папке
C:\Windows\System32\fsutil.exe file createnew C:\Users\User\laba\log\file2.txt 838860800
rem Получение размера папки log
set /a totalsize=0
for /r "%path%" %%F in (*) do (
  set /a totalsize+=%%~zF
)
set /a foldersize=totalsize/1024

rem Получение размера папки backup
set /a totalsizeb=0
for /r "%backup_path%" %%F in (*) do (
    set /a totalsizeb+=%%~zF
)
set /a backupsize=totalsizeb/1024

echo Изначальный вес папки log: !foldersize! K, папки backup: !backupsize! K

call "%script1%"

rem Получение нового размера папки log
set /a totalsize=0
for /r "%path%" %%F in (*) do (
  set /a totalsize+=%%~zF
)
set /a foldersize=totalsize/1024

rem Получение размера папки backup
set /a totalsizeb=0
for /r "%backup_path%" %%F in (*) do (
    set /a totalsizeb+=%%~zF
)
set /a backupsize=totalsizeb/1024

if !foldersize! lss 204800 (
    if exist "%backup_path%\*.tar" (
        echo Тест 2 пройден. Вес папки log: !foldersize! K, вес папки backup: !backupsize! K
    ) else (
        echo Тест 2 не пройден. Вес папки log: !foldersize! K, вес папки backup: !backupsize! K
    )
) else (
    echo Тест 2 не пройден. Вес папки log: !foldersize! K, вес папки backup: !backupsize! K
)

rem Очистка папок после теста
del /Q "%path%\*"
del /Q "%backup_path%\*"
echo.




echo Тест 3: 69 файлов весом >700МБ в папке
for /l %%i in (1,1,69) do (
    C:\Windows\System32\fsutil.exe file createnew "%path%\file%%i.txt" 11534336
)
rem Получение размера папки log
set /a totalsize=0
for /r "%path%" %%F in (*) do (
  set /a totalsize+=%%~zF
)
set /a foldersize=totalsize/1024

rem Получение размера папки backup
set /a totalsizeb=0
for /r "%backup_path%" %%F in (*) do (
    set /a totalsizeb+=%%~zF
)
set /a backupsize=totalsizeb/1024

echo Изначальный вес папки log: !foldersize! K, папки backup: !backupsize! K

call "%script1%"

rem Получение нового размера папки log
set /a totalsize=0
for /r "%path%" %%F in (*) do (
  set /a totalsize+=%%~zF
)
set /a foldersize=totalsize/1024

rem Получение размера папки backup
set /a totalsizeb=0
for /r "%backup_path%" %%F in (*) do (
    set /a totalsizeb+=%%~zF
)
set /a backupsize=totalsizeb/1024

set /a flag=1

if !foldersize! gtr 204800 (
   set /a flag=0
)

for %%F in ("%backup_path%\*") do (
    rem Проверяем расширение каждого файла
    set "ext=%%~xF"
    if /i not "!ext!"==".zip" if /i not "!ext!"==".rar" if /i not "!ext!"==".7z" if /i not "!ext!"==".tar" (
        set /a flag=0
    )
)

if !flag! equ 1 (
    echo Тест 3 пройден. Вес папки log: !foldersize! K, вес папки backup: !backupsize! K
) else (
    echo Тест 3 не пройден. Вес папки log: !foldersize! K, вес папки backup: !backupsize! K
)

rem Очистка папок после теста
del /Q "%path%\*"
del /Q "%backup_path%\*"
echo.




echo Тест 4: Пустая папка

rem Получение размера папки log
set /a totalsize=0
for /r "%path%" %%F in (*) do (
  set /a totalsize+=%%~zF
)
set /a foldersize=totalsize/1024

rem Получение размера папки backup
set /a totalsizeb=0
for /r "%backup_path%" %%F in (*) do (
    set /a totalsizeb+=%%~zF
)
set /a backupsize=totalsizeb/1024

echo Изначальный вес папки log: !foldersize! K, папки backup: !backupsize! K

call "%script1%"

rem Получение нового размера папки log
set /a totalsize=0
for /r "%path%" %%F in (*) do (
  set /a totalsize+=%%~zF
)
set /a foldersize=totalsize/1024

rem Получение размера папки backup
set /a totalsizeb=0
for /r "%backup_path%" %%F in (*) do (
    set /a totalsizeb+=%%~zF
)
set /a backupsize=totalsizeb/1024

if !foldersize! lss 204800 if "!backupsize!"=="0" (
    echo Тест 4 пройден. Вес папки log: !foldersize! K, вес папки backup: !backupsize! K
) else (
    echo Тест 4 не пройден. Вес папки log: !foldersize! K, вес папки backup: !backupsize! K
)

rem Очистка папок после теста
del /Q "%path%\*"
del /Q "%backup_path%\*"
echo.

pause