# ProlifMSC

## Overview
ProlifMSC is a command-line tool designed for processing cell images and performing analysis using Cellpose and Fiji ImageJ. The project provides two main functionalities:

1. **Image Processing**: Segment and crop regions of interest (ROIs) from phase-contrast (PC) and fluorescent-labeled (DF) images using Cellpose.
2. **Image Analysis**: Analyze the cropped images using Fiji ImageJ to extract detailed measurements.

## Prerequisites

### Python Dependencies
- Python 3.8+
- Required libraries:
  - `opencv-python`
  - `numpy`
  - `torch`
  - `cellpose`
  - `pandas`
  - `matplotlib`

Install the dependencies using:
```bash
pip install -r requirements.txt
```

### Additional Tools
- **Fiji ImageJ**: Ensure Fiji ImageJ is installed and its path is properly set in `cell_anal.py`.
- **Cellpose Model**: Provide a Cellpose model for segmentation. Update the model path in `img_process.py`.

## Usage

### Command Structure
The tool uses a CLI with two subcommands: `process` and `analyze`.

### 1. Image Processing
Segment and crop images using the `process` command.

#### Arguments:
- `--pc_folder_name`: Path to the folder containing PC images (e.g., bright-field phase-contrast images).
- `--df_folder_name`: Path to the folder containing DF images (e.g., dark-field or fluorescent-labeled images).

#### Example:
```bash
python main.py process --pc_folder_name ./data/PC --df_folder_name ./data/DF
```

### 2. Image Analysis
Perform Fiji ImageJ analysis on the cropped images using the `analyze` command.

#### Arguments:
- `--data_name`: Path to the dataset folder containing cropped images and their corresponding outlines.

#### Example:
```bash
python main.py analyze --data_name ./data/output/crop
```

## Output

### Image Processing Outputs:
- Cropped images saved to `./data/output/crop/<df_folder_name>`.
- Outlines saved as text files in `./data/output/outlines/<df_folder_name>`.

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
1. Ensure the paths for input and output directories exist.
2. Customize the Cellpose model path in `img_process.py` to match your environment.
3. Configure Fiji ImageJ in `cell_anal.py` by specifying the correct Fiji path.

## License
This project is open-source and available under the MIT License.

---
For further assistance, please refer to the code comments or contact the maintainers.