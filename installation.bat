@echo off
setlocal EnableDelayedExpansion

:: 定義下載路徑
set JAVA_URL=https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.exe
set MAVEN_URL=https://dlcdn.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.zip
set FIJI_URL=https://downloads.imagej.net/Fiji.zip

:: 定義安裝目錄
set JAVA_INSTALL_DIR=C:\Program Files\Java
set MAVEN_INSTALL_DIR=C:\Program Files\Apache\Maven
set FIJI_INSTALL_DIR=C:\Fiji

echo ---------------------------------------
echo 開始安裝 Java, Maven, 和 Fiji
echo ---------------------------------------

:: 檢查管理員權限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 請以管理員模式運行此腳本！
    pause
    exit /b 1
)

:: 創建臨時目錄
set TEMP_DIR=%TEMP%\setup_tools
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

:: 安裝 Java
echo 正在下載並安裝 Java...
cd /d "%TEMP_DIR%"
curl -L -o java_installer.exe %JAVA_URL%
start /wait java_installer.exe /s INSTALLDIR="%JAVA_INSTALL_DIR%"
if not exist "%JAVA_INSTALL_DIR%" (
    echo Java 安裝失敗！
    pause
    exit /b 1
)
setx JAVA_HOME "%JAVA_INSTALL_DIR%\jdk-17"
setx PATH "%PATH%;%JAVA_INSTALL_DIR%\jdk-17\bin"

:: 安裝 Maven
echo 正在下載並安裝 Maven...
curl -L -o maven.zip %MAVEN_URL%
if exist "%MAVEN_INSTALL_DIR%" rmdir /s /q "%MAVEN_INSTALL_DIR%"
mkdir "%MAVEN_INSTALL_DIR%"
tar -xf maven.zip -C "%MAVEN_INSTALL_DIR%" --strip-components=1
setx MAVEN_HOME "%MAVEN_INSTALL_DIR%"
setx PATH "%PATH%;%MAVEN_INSTALL_DIR%\bin"

:: 安裝 Fiji (ImageJ)
echo 正在下載並安裝 Fiji...
curl -L -o Fiji.zip %FIJI_URL%
if exist "%FIJI_INSTALL_DIR%" rmdir /s /q "%FIJI_INSTALL_DIR%"
mkdir "%FIJI_INSTALL_DIR%"
tar -xf Fiji.zip -C "%FIJI_INSTALL_DIR%"

:: 清理臨時檔案
echo 正在清理臨時檔案...
cd /d "%TEMP%"
rmdir /s /q "%TEMP_DIR%"

:: 驗證安裝
echo ---------------------------------------
echo 驗證安裝...
java -version
mvn -v
if exist "%FIJI_INSTALL_DIR%\ImageJ-win64.exe" (
    echo Fiji 已安裝成功！
) else (
    echo Fiji 安裝失敗！
)

echo ---------------------------------------
echo 所有軟體已成功安裝並配置。
echo 請重新啟動命令提示字元以生效環境變數。
pause
