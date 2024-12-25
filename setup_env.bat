@echo off
:: 啟動 Anaconda Prompt 並執行命令
echo =======================================
echo Anaconda Environment Setup Script
echo =======================================

:: 確保窗口不會在出錯後直接關閉
setlocal EnableDelayedExpansion

:: 切換到 Anaconda Prompt
echo Activating Anaconda...
call %USERPROFILE%\anaconda3\Scripts\activate.bat
if errorlevel 1 (
    echo [ERROR] Failed to activate Anaconda. Check your installation path.
    pause
    exit /b
)

:: 創建名為 prolifmsc 的虛擬環境並指定 Python 版本
echo Creating the virtual environment 'prolifmsc'...
conda create --name prolifmsc python=3.10 -y
if errorlevel 1 (
    echo [ERROR] Failed to create the environment. Check conda settings.
    pause
    exit /b
)

:: 激活虛擬環境
echo Activating the environment 'prolifmsc'...
conda activate prolifmsc
if errorlevel 1 (
    echo [ERROR] Failed to activate the environment. Check if it was created properly.
    pause
    exit /b
)

:: 安裝必要的套件
echo Installing packages...
python -m pip install cellpose
if errorlevel 1 (
    echo [ERROR] Failed to install 'cellpose'. Check Python or pip settings.
    pause
    exit /b
)

pip install pyimagej
if errorlevel 1 (
    echo [ERROR] Failed to install 'pyimagej'.
    pause
    exit /b
)

pip3 install torch torchvision torchaudio
if errorlevel 1 (
    echo [ERROR] Failed to install PyTorch packages.
    pause
    exit /b
)

echo =======================================
echo Environment setup completed successfully!
echo =======================================
pause
