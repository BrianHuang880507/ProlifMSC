@echo off
call conda init
conda create --name prolifmsc python=3.10 -y && conda activate prolifmsc && python -m pip install cellpose && pip install pyimagej && pip install torch torchvision torchaudio && echo Environment setup complete!
