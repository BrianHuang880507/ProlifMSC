@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul

echo ---------------------------------------
echo 環境設置腳本開始
echo ---------------------------------------

:: 檢查管理員權限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 請以管理員模式運行此腳本！
    pause
    exit /b 1
)

:: 創建 Conda 環境
call conda create -n prolifmsc python=3.10 -y
if %errorLevel% neq 0 (
    echo Conda 環境創建失敗！
    pause
    exit /b 1
)

:: 激活 Conda 環境
echo 激活 Conda 環境...
call "%ProgramData%\anaconda3\condabin\conda.bat" activate prolifmsc
if %errorLevel% neq 0 (
    echo Conda 環境激活失敗！
    pause
    exit /b 1
)

:: 安裝所需 Python 套件
echo 安裝必要的 Python 套件...
call python -m pip install cellpose
if %errorLevel% neq 0 (
    echo 安裝 cellpose 失敗！
    pause
    exit /b 1
)

call pip install pyimagej
if %errorLevel% neq 0 (
    echo 安裝 pyimagej 失敗！
    pause
    exit /b 1
)

call pip install torch torchvision torchaudio
if %errorLevel% neq 0 (
    echo 安裝 PyTorch 套件失敗！
    pause
    exit /b 1
)

echo ---------------------------------------
echo 環境設置完成
pause