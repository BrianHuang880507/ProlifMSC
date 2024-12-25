@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul

:: 獲取批處理文件所在目錄
set CURRENT_DIR=%~dp0

:: 定義本地檔案路徑
set JAVA_ZIP_PATH=%CURRENT_DIR%openjdk-23.0.1_windows-x64_bin.zip
set MAVEN_ZIP_PATH=%CURRENT_DIR%apache-maven-3.9.9-bin.zip
set FIJI_ZIP_PATH=%CURRENT_DIR%fiji-win64.zip

:: 定義解壓目錄
set JAVA_INSTALL_DIR=C:\Program Files\Java
set MAVEN_INSTALL_DIR=C:\Program Files\Maven
set FIJI_INSTALL_DIR=%CURRENT_DIR%prolifmsc

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
echo 正在安裝 OpenJDK...
if exist "%JAVA_ZIP_PATH%" (
    if exist "%JAVA_INSTALL_DIR%" rmdir /s /q "%JAVA_INSTALL_DIR%"
    mkdir "%JAVA_INSTALL_DIR%"
    tar -xf "%JAVA_ZIP_PATH%" -C "%JAVA_INSTALL_DIR%" --strip-components=1
    if exist "%JAVA_INSTALL_DIR%\bin" (
        setx JAVA_HOME "%JAVA_INSTALL_DIR%"
        setx PATH "%PATH%;%JAVA_INSTALL_DIR%\bin"
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
echo 正在安裝 Maven...
if exist "%MAVEN_ZIP_PATH%" (
    if exist "%MAVEN_INSTALL_DIR%" rmdir /s /q "%MAVEN_INSTALL_DIR%"
    mkdir "%MAVEN_INSTALL_DIR%"
    tar -xf "%MAVEN_ZIP_PATH%" -C "%MAVEN_INSTALL_DIR%" --strip-components=1
    if exist "%MAVEN_INSTALL_DIR%\bin" (
        setx MAVEN_HOME "%MAVEN_INSTALL_DIR%"
        setx PATH "%PATH%;%MAVEN_INSTALL_DIR%\bin"
        echo Maven 安裝成功！
    ) else (
        echo Maven 安裝失敗！
        pause
        exit /b 1
    )
) else (
    echo 無法找到 Maven 壓縮檔案：%MAVEN_ZIP_PATH%
    pause
    exit /b 1
)

:: 解壓 Fiji ImageJ
echo 正在解壓 Fiji ImageJ...
if exist "%FIJI_ZIP_PATH%" (
    if exist "%FIJI_INSTALL_DIR%" rmdir /s /q "%FIJI_INSTALL_DIR%"
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
    echo 無法找到 Fiji 壓縮檔案：%FIJI_ZIP_PATH%
    pause
    exit /b 1
)

:: 更新 JAVA_HOME
echo 更新 JAVA_HOME 環境變數...
set FIJI_JAVA_PATH=%FIJI_INSTALL_DIR%\Fiji.app\java\win64\zulu8.60.0.21-ca-fx-jdk8.0.322-win_x64\jre
if exist "%FIJI_JAVA_PATH%" (
    setx JAVA_HOME "%JAVA_INSTALL_DIR%;%FIJI_JAVA_PATH%"
    echo JAVA_HOME 已更新，包含 Fiji 的內置 Java 路徑！
) else (
    echo 無法找到 Fiji 的 Java 路徑：%FIJI_JAVA_PATH%
    pause
    exit /b 1
)

:: 驗證安裝
echo ---------------------------------------
echo 驗證安裝...
java -version
if %errorLevel% neq 0 (
    echo Java 配置失敗！
    pause
    exit /b 1
)

mvn -v
if %errorLevel% neq 0 (
    echo Maven 配置失敗！
    pause
    exit /b 1
)

echo ---------------------------------------
echo OpenJDK、Maven 和 Fiji 已成功安裝並配置。
echo 請重新啟動命令提示字元以生效環境變數。
pause
