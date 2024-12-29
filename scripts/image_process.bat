@echo off

chcp 65001 >nul

:: 定義變數
set ENV_NAME=prolifmsc
set pc_folder=B4_P14-PC
set df_folder=B4_P14-DF
set code_dir=%~dp0..

:: 檢查目標目錄是否存在，若不存在則創建
if not exist "%USERPROFILE%\.cellpose\models" (
    mkdir "%USERPROFILE%\.cellpose\models"
)

:: 定義源目錄
set SOURCE_DIR=%USERPROFILE%\prolifmsc

:: 定義目標目錄
set TARGET_DIR=%USERPROFILE%\.cellpose\models

:: 移動檔案
move "%SOURCE_DIR%\model_BDL3_label_dapi" "%TARGET_DIR%"
if %errorLevel% neq 0 (
    echo 無法移動 model_BDL3_label_dapi 到 %TARGET_DIR%！
    pause
    exit /b 1
)

move "%SOURCE_DIR%\model_BDL6_label_test" "%TARGET_DIR%"
if %errorLevel% neq 0 (
    echo 無法移動 model_BDL6_label_test 到 %TARGET_DIR%！
    pause
    exit /b 1
)

echo 所有檔案已成功移動到 %TARGET_DIR%

:: 切換到程式碼目錄
cd /d %code_dir%
if %ERRORLEVEL% NEQ 0 (
    echo 無法切換到目錄 '%code_dir%'。
    pause
    exit /b 1
)
echo 已切換到目錄 '%code_dir%'。

:: 啟動虛擬環境
call activate %ENV_NAME%
if %ERRORLEVEL% NEQ 0 (
    echo 無法啟動虛擬環境 '%ENV_NAME%'。
    pause
    exit /b 1
)
echo 已啟動虛擬環境 '%ENV_NAME%'。

:: 執行 Python 程式
echo ---------------------------------------
echo 正在識別細胞中...
echo ---------------------------------------
python main.py process --pc_folder_name "%pc_folder%" --df_folder_name "%df_folder%"
if %ERRORLEVEL% NEQ 0 (
    echo Python 腳本執行失敗。
    call conda deactivate
    pause
    exit /b 1
)

:: 停用虛擬環境
call conda deactivate
if %ERRORLEVEL% NEQ 0 (
    echo 無法退出虛擬環境 '%ENV_NAME%'。
    pause
    exit /b 1
)
echo 已退出虛擬環境 '%ENV_NAME%'。

:: 暫停視窗
pause
