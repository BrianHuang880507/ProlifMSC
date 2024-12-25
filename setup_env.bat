@echo off
:: 啟動 Anaconda Prompt 並執行命令
echo =======================================
echo Anaconda Environment Setup Script
echo =======================================

:: 切換到 Anaconda Prompt
call %USERPROFILE%\anaconda3\Scripts\activate.bat

:: 創建名為 prolifmsc 的虛擬環境並指定 Python 版本
conda create --name prolifmsc python=3.10 -y

:: 激活虛擬環境
conda activate prolifmsc

:: 安裝必要的套件
python -m pip install cellpose
pip install pyimagej
pip3 install torch torchvision torchaudio

echo =======================================
echo Environment setup completed!
echo =======================================
pause
