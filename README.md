# ProlifMSC

## Overview
ProlifMSC is a command-line tool designed for processing cell images and performing analysis using Cellpose and Fiji ImageJ. The project provides two main functionalities:

1. **Image Processing**: Segment and crop regions of interest (ROIs) from phase-contrast (PC) and fluorescent-labeled (DF) images using Cellpose.
2. **Image Analysis**: Analyze the cropped images using Fiji ImageJ to extract detailed measurements.

## Prerequisites
- Fiji ImageJ
- Java
- Maven

Install the Prerequisites using:
 - set up your java, maven, anaconda loaction
 - run `install.bat`


### Python Dependencies
- Python 3.10+
- Required libraries:
  - `cellpose`
  - `pyimagej`
  - `torchvision`


Install the dependencies using: 
 - run `env_set.bat`

## Usage

### 1. Env Config
Set up your cellpose model
 - Place model at `<pathtocellpose>\.cellpose\models\<yourmodel.pt>`.

Set up Imagej
 - Put your Fiji.app at `.\prolifmsc\`.

Dataset placement
 - `.\data\input\` your datastes placement.

### 2. Image Processing
Segment and crop images run `img_process.bat` or using the `process` command.

#### Arguments:
- `--pc_folder_name`: Folder containing PC images (e.g., bright-field phase-contrast images).
- `--df_folder_name`: Folder containing DF images (e.g., dark-field or fluorescent-labeled images).

#### Example:
```bash
python main.py process --pc_folder_name PC --df_folder_name DF
```

### 3. Image Analysis
Perform Fiji ImageJ analysis on the cropped images run `cell_anal.bat` or using the `analyze` command.

#### Arguments:
- `--data_name`: Dataset folder containing cropped images and their corresponding outlines.

#### Example:
```bash
python main.py analyze --data_name DF
```

## Output

### Image Processing Outputs:
- Cropped images saved to `./data/output/crop/<folder_name>`.
- Outlines saved as text files in `./data/output/outlines/<folder_name>`.

### Image Analysis Outputs:
- Results saved as CSV files in `./data/output/result/<data_name>`.
- Combined results exported to an Excel file with multiple sheets.

## Project Structure
```
PROLIFMSC/
├── data/                 # Data storage (input and output)
    ├── input             
    ├── output            
├──prolifmsc/             
    ├──Fiji.app/          # Fiji imagej install location
    ├──utils/
        ├──io.py
    ├── main.py           # CLI entry point
    ├── img_process.py    # Image segmentation and cropping logic
    ├── cell_anal.py      # Fiji ImageJ analysis logic
├── scripts/              # CLI scripts
├── test/                 # Unit test
└── requirements.txt      
```

## Notes

## License

---
For further assistance, please refer to the code comments or contact the maintainers.