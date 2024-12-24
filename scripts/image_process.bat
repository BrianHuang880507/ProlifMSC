@echo off
set ENV_NAME=pyimagej
set pc_folder=PC
set df_folder=DF

call activate %ENV_NAME%
if %ERRORLEVEL% NEQ 0 (
    echo Failed to activate virtual environment '%ENV_NAME%'.
    exit /b 1
)
echo Virtual environment '%ENV_NAME%' activated.

echo Analyzing cropped images...
python main.py process --pc_folder_name "%pc_folder%" --df_folder_name "%df_folder%"
if %ERRORLEVEL% NEQ 0 (
    echo Python script execution failed.
    call conda deactivate
    exit /b 1
)

call conda deactivate
echo Virtual environment '%ENV_NAME%' deactivated.
