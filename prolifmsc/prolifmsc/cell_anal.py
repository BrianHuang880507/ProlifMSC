import imagej
import pandas as pd
import matplotlib.pyplot as plt
import glob, os
from prolifmsc.utils.io import get_paths


def run_macro(img_pth, outlines, data_name, crop_img_name):
    """Run Fiji ImageJ macro for image analysis.

    Args:
        img_pth (str): Path to the input image.
        outlines (str): Path to the outline file.
        data_name (str): Name of the dataset.
        crop_img_name (str): Name of the cropped image being processed.

    Returns:
        None
    """
    ij = imagej.init(r"prolifmsc\Fiji.app", mode="interactive")
    print(f"ImageJ2 version: {ij.getVersion()}")

    # Define the macro script to be run by ImageJ
    macro = """
    #@ String img_pth
    #@ String outlines
    #@ String output_1
    #@ String output_2
    #@ String output_3
    from ij import IJ
    from ij.plugin.frame import RoiManager
    from ij.gui import PolygonRoi
    from ij.gui import Roi
    from java.awt import Window

    # Open the input image
    img = IJ.openImage(imgPth)
    img.show()

    # Initialize ROI Manager
    rm = RoiManager.getInstance()
    if rm is None:
        rm = RoiManager()

    imp = IJ.getImage()

    # Clear any previous results and ROIs
    IJ.run("Clear Results")
    rm.runCommand("Delete")

    # Load and process outlines from the file
    with open(outlines, "r") as textfile:
        for line in textfile:
            xy = list(map(int, line.rstrip().split(",")))  
            X = xy[::2]
            Y = xy[1::2]
            if len(X) > 2 and len(Y) > 2:  
                imp.setRoi(PolygonRoi(X, Y, Roi.POLYGON))
                roi = imp.getRoi()
                if roi is not None:  
                    rm.addRoi(roi)

    # Perform measurements and save the first results
    rm.runCommand("Show None")
    IJ.run("Set Measurements...", "area mean perimeter fit shape feret's redirect=None decimal=3")
    rm.select(0)
    rm.runCommand("Measure")
    rm.runCommand("Deselect")
    rm.select(1)
    rm.runCommand("Measure")
    rm.runCommand("Deselect")

    IJ.saveAs("Results", output_1)

    # Additional processing steps (Convex Hull, Integrated measurements, etc.)
    # omitted here for brevity, but similar logic applies as shown above

    # Save the final results
    IJ.saveAs("Results", output_3)

    # Clean up
    IJ.run("Clear Results")
    rm.runCommand("Delete")
    """

    # Define output file paths
    output_1 = os.path.join(data_name, crop_img_name, "_result-1.csv")
    output_2 = os.path.join(data_name, crop_img_name, "_result-2.csv")
    output_3 = os.path.join(data_name, crop_img_name, "_result-3.csv")
    excelOutputFile = os.path.join(data_name, crop_img_name, "_result.csv")

    # Arguments to pass to the macro
    args = {
        "img_pth": img_pth,
        "outlines": outlines,
        "output_1": output_1,
        "output_2": output_2,
        "output_3": output_3,
    }

    # Run the macro script with ImageJ
    ij.py.run_script("py", macro, args)

    # Save results to an Excel file
    save_to_excel(output_1, output_2, output_3, excelOutputFile)


def run_all(data_name):
    """Process all cropped images and their corresponding outlines.

    Args:
        data_name (str): Name of the dataset containing images and outlines.

    Returns:
        None
    """
    # Get paths for cropped images and outlines
    crop_imgs = get_paths(data_name, anal=True)
    outlines = get_paths(data_name, outlines=True)

    # Define the output directory
    output_pth = os.path.join("data", "output", "result", data_name)
    os.makedirs(output_pth, exist_ok=True)

    # Loop through each cropped image
    for crop_img in crop_imgs:
        crop_img_name = os.path.splitext(os.path.basename(crop_img))[
            0
        ]  # Extract the base name

        # Find the corresponding outline file
        outline = next(
            (o for o in outlines if crop_img_name in os.path.basename(o)), None
        )

        if outline is None:
            print(f"Warning: No matching outline found for {crop_img_name}")
            continue

        # Run the macro for the current image and outline
        run_macro(crop_img, outline, output_pth, crop_img_name)


def save_to_excel(output_1, output_2, output_3, excelOutputFile):
    """Save three CSV result files into different sheets in an Excel file.

    Args:
        output_1 (str): Path to the first results CSV.
        output_2 (str): Path to the second results CSV.
        output_3 (str): Path to the third results CSV.
        excelOutputFile (str): Path to save the Excel file.

    Returns:
        None
    """
    # Read all result files
    df1 = pd.read_csv(output_1)
    df2 = pd.read_csv(output_2)
    df3 = pd.read_csv(output_3)

    # Write to Excel with separate sheets
    with pd.ExcelWriter(excelOutputFile) as writer:
        df1.to_excel(writer, sheet_name="Results_1", index=False)
        df2.to_excel(writer, sheet_name="Results_2", index=False)
        df3.to_excel(writer, sheet_name="Results_3", index=False)

    print(f"Results saved to {excelOutputFile} in separate sheets.")
