@echo off
setlocal enabledelayedexpansion
@rem chcp 65001
C:\Windows\System32\chcp.com 65001 >nul

set /a treshold=1048576
set /a percentage=70
set /a nec=204800

set "path=C:\Users\User\laba\log"
set "backuppath=C:\Users\User\laba\backup"

set /a totalsize=0
for /r "%path%" %%F in (*) do (
    set /a totalsize+=%%~zF
)
set /a foldersize=totalsize/1024

set /a fullness=(foldersize*100)/treshold
if !fullness! leq !percentage! (
    echo Папка заполнена менее чем на %percentage% процентов, архивация файлов не требуется
) else (
    :loop
    set "moved=0"
    for /f "tokens=*" %%f in ( '
        dir /b /a-d /od "%path%"
    ' ) do (
        if !moved! equ 0 (
            move "%path%\%%f" "%backuppath%"
            set "latestfile=%%f"
            set "moved=1"
        )
    )

    cd %backuppath%
    C:\Windows\System32\tar.exe -cJvf !latestfile!.tar "!latestfile!
    del !latestfile!

    set /a s=0
    for /r "%path%" %%F in (*) do (
        set /a s+=%%~zF
    )
    set /a currsize=s/1024

    if !currsize! geq %nec% (
        goto loop
    )
)
