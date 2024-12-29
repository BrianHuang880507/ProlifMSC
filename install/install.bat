@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul

:: 定義本地檔案路徑
set JAVA_ZIP_PATH=%~dp0\openjdk-23.0.1_windows-x64_bin.zip
set MAVEN_ZIP_PATH=%~dp0\apache-maven-3.9.9-bin.zip
set FIJI_ZIP_PATH=%~dp0\fiji-win64.zip

:: 定義解壓目錄
set JAVA_INSTALL_DIR=C:\Program Files\jdk-23.0.1
set MAVEN_INSTALL_DIR=C:\Program Files\apache-maven-3.9.9
set FIJI_INSTALL_DIR=%USERPROFILE%\ProlifMSC

:: 定義 Anaconda 安裝路徑
set ANACONDA_SCRIPTS_DIR=C:\ProgramData\anaconda3\Scripts

echo ---------------------------------------
echo 開始安裝 OpenJDK、Maven 和 Fiji ImageJ
echo ---------------------------------------

:: 檢查管理員權限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 請以管理員模式運行此腳本！
    pause
    exit /b 1
)

:: 安裝 OpenJDK
echo.
echo 正在安裝 OpenJDK...
echo ---------------------------------------
if exist "%JAVA_ZIP_PATH%" (
    if not exist "%JAVA_INSTALL_DIR%" mkdir "%JAVA_INSTALL_DIR%"
    tar -xf "%JAVA_ZIP_PATH%" -C "%JAVA_INSTALL_DIR%" --strip-components=1
    
    setx JAVA_HOME "%JAVA_INSTALL_DIR%" /m
    for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path ^| findstr /i "Path"') do (
        set "CURRENT_PATH=%%B"
    )
    set "NEW_PATH=%CURRENT_PATH%;%%JAVA_HOME%%\bin"
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path /t REG_EXPAND_SZ /d "%NEW_PATH%" /f
    if "%JAVA_HOME%"=="%JAVA_INSTALL_DIR%" (
        echo JAVA_HOME 設置正確，值為：%JAVA_HOME%
    ) else (
        echo JAVA_HOME 設置錯誤，當前值為：%JAVA_HOME%，應為：%JAVA_INSTALL_DIR%
        pause
        exit /b 1
    )

    call java -version >nul 2>&1
    if not errorlevel 1 (
        echo OpenJDK 安裝成功！
    ) else (
        echo OpenJDK 安裝失敗！
        pause
        exit /b 1
    )
) else (
    echo 無法找到 OpenJDK 壓縮檔案：%JAVA_ZIP_PATH%
    pause
    exit /b 1
)

:: 安裝 Maven
echo.
echo 正在安裝 Maven...
echo ---------------------------------------
if exist "%MAVEN_ZIP_PATH%" (
    if not exist "%MAVEN_INSTALL_DIR%" mkdir "%MAVEN_INSTALL_DIR%"
    tar -xf "%MAVEN_ZIP_PATH%" -C "%MAVEN_INSTALL_DIR%" --strip-components=1

    setx M2_HOME "%MAVEN_INSTALL_DIR%" /m
    for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path ^| findstr /i "Path"') do (
        set "CURRENT_PATH=%%B"
    )
    set "NEW_PATH=%CURRENT_PATH%;%%M2_HOME%%\bin"
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path /t REG_EXPAND_SZ /d "%NEW_PATH%" /f
    call mvn -version >nul 2>&1
    if not errorlevel 1 (
        echo Maven 安裝成功！
    ) else (
        echo Maven 未正確安裝!
        pause
        exit /b 1
    )
) else (
    echo 無法找到 Maven 壓縮檔案：%MAVEN_ZIP_PATH%
    pause
    exit /b 1
)

:: 解壓 Fiji ImageJ
echo.
echo 正在安裝 Fiji ImageJ...
echo ---------------------------------------
if exist "%FIJI_ZIP_PATH%" (
    mkdir "%FIJI_INSTALL_DIR%"
    tar -xf "%FIJI_ZIP_PATH%" -C "%FIJI_INSTALL_DIR%"
    if exist "%FIJI_INSTALL_DIR%\Fiji.app" (
        echo Fiji ImageJ 解壓成功！
    ) else (
        echo Fiji ImageJ 解壓失敗！
        pause
        exit /b 1
    )
) else (
    echo \n 無法找到 Fiji 壓縮檔案：%FIJI_ZIP_PATH%
    pause
    exit /b 1
)

:: 添加 Anaconda Scripts 到 Path
echo 正在添加 Anaconda Scripts 到 Path...
if exist "%ANACONDA_SCRIPTS_DIR%" (
    for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path ^| findstr /i "Path"') do (
        set "CURRENT_PATH=%%B"
    )
    setx PATH "%CURRENT_PATH%;%ANACONDA_SCRIPTS_DIR%" /m
    setx PATH "%CURRENT_PATH%;%ANACONDA_SCRIPTS_DIR%"
    echo Anaconda Scripts 已成功添加到 Path！
) else (
    echo 無法找到 Anaconda Scripts 目錄：%ANACONDA_SCRIPTS_DIR%
    pause
    exit /b 1
)

echo ---------------------------------------
echo OpenJDK、Maven 和 Fiji 已成功安裝並配置。
echo ---------------------------------------
echo 請重新啟動命令提示字元以生效環境變數。
pause
