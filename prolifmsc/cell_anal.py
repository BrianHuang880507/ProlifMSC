import imagej
import pandas as pd
import glob, os
from prolifmsc.utils.io import get_paths

macro = """
# @ String img_pth
# @ String outlines
# @ String output_1
# @ String output_2
# @ String output_3
from ij import IJ
from ij.plugin.frame import RoiManager
from ij.gui import PolygonRoi
from ij.gui import Roi
from java.awt import Window

img = IJ.openImage(img_pth)
img.show()

rm = RoiManager.getInstance()
if rm is None:
    rm = RoiManager()

imp = IJ.getImage()

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

rm.runCommand("Show None")
IJ.run(
    "Set Measurements...",
    "area mean perimeter fit shape feret's redirect=None decimal=3",
)
rm.select(0)
rm.runCommand("Measure")
rm.runCommand("Deselect")
rm.select(1)
rm.runCommand("Measure")
rm.runCommand("Deselect")
IJ.saveAs("Results", output_1)

IJ.run("Clear Results")
rm.runCommand("Delete")

with open(outlines, "r") as textfile:
    for line in textfile:
        xy = list(map(int, line.rstrip().split(",")))
        X = xy[::2]
        Y = xy[1::2]
        if len(X) > 2 and len(Y) > 2:
            imp.setRoi(PolygonRoi(X, Y, Roi.POLYGON))
            IJ.run(imp, "Convex Hull", "")
            roi = imp.getRoi()
            if roi is not None:
                rm.addRoi(roi)

rm.runCommand("Show None")
IJ.run("Set Measurements...", "perimeter redirect=None decimal=3")
rm.select(0)
rm.runCommand("Measure")
rm.runCommand("Deselect")
rm.select(1)
rm.runCommand("Measure")
rm.runCommand("Deselect")
IJ.saveAs("Results", output_2)

IJ.run("Clear Results")
rm.runCommand("Delete")

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

rm.runCommand("Show None")
IJ.run("Set Measurements...", "integrated redirect=None decimal=3")

if rm.getCount() > 1:
    rm.select(0)
    rm.runCommand("Rename", "nuclei_0")
    rm.runCommand("Deselect")

    rm.select(1)
    rm.runCommand("Rename", "cyto")

    cyto_index = rm.getIndex("cyto")
    rm.select(cyto_index)
    roi = rm.getRoi(cyto_index)
    cyto_bounds = roi.getBounds()
    cyto_w = cyto_bounds.width
    cyto_h = cyto_bounds.height
    rm.runCommand("Deselect")

    if cyto_w > cyto_h:
        cyto_threshold = cyto_w
    elif cyto_w < cyto_h:
        cyto_threshold = cyto_h
    else:
        cyto_threshold = cyto_w

    for i in range(10):
        nuclei_index = rm.getIndex("nuclei_0")
        rm.select(nuclei_index)
        roi = rm.getRoi(nuclei_index)
        roi_bounds = roi.getBounds()

        if (
            roi_bounds.width * (1.5 + (0.5 * i)) <= cyto_threshold
            and roi_bounds.height * (1.5 + (0.5 * i)) <= cyto_threshold
        ):
            rm.scale(1.5 + (0.5 * i), 1.5 + (0.5 * i), True)
            roi = imp.getRoi()
            if roi is not None:
                rm.addRoi(roi)
                rm.runCommand("Rename", "nuclei_{}".format(i + 1))
            rm.runCommand("Deselect")
        else:
            break

    num_Roi = rm.getCount()
    for i in range(num_Roi - 2):
        n1_index = rm.getIndex("nuclei_{}".format(i))
        n2_index = rm.getIndex("nuclei_{}".format(i + 1))
        rm.setSelectedIndexes([n1_index, n2_index])
        rm.runCommand(imp, "XOR")
        roi = imp.getRoi()
        if roi is not None:
            rm.addRoi(roi)

            num_Roi = rm.getCount()
            rm.select(num_Roi - 1)
            rm.runCommand("Rename", "nuclei_{}{}".format(i, i + 1))
            rm.runCommand("Deselect")

            nxor_index = rm.getIndex("nuclei_{}{}".format(i, i + 1))
            cyto_index = rm.getIndex("cyto")
            rm.setSelectedIndexes([nxor_index, cyto_index])
            rm.runCommand(imp, "AND")
            roi = imp.getRoi()
            if roi is not None:
                rm.addRoi(roi)

                num_Roi = rm.getCount()
                rm.select(num_Roi - 1)
                rm.runCommand("Rename", "nuclei_{}{}F".format(i, i + 1))
                nf_index = rm.getIndex("nuclei_{}{}F".format(i, i + 1))

                rm.select(nf_index)
                rm.runCommand("Measure")

IJ.saveAs("Results", output_3)

IJ.run("Clear Results")
rm.runCommand("Delete")

if img is not None:
    img.close()

for window in Window.getWindows():
    if window != img.getWindow():
        window.dispose()
"""


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

    output_1 = os.path.join(data_name, crop_img_name + "_result-1.csv").replace(
        "\\", "/"
    )
    output_2 = os.path.join(data_name, crop_img_name + "_result-2.csv").replace(
        "\\", "/"
    )
    output_3 = os.path.join(data_name, crop_img_name + "_IntDen_result.csv").replace(
        "\\", "/"
    )
    excelOutputFile = os.path.join(
        data_name, crop_img_name + "_Param_result.csv"
    ).replace("\\", "/")

    args = {
        "img_pth": img_pth,
        "outlines": outlines,
        "output_1": output_1,
        "output_2": output_2,
        "output_3": output_3,
    }

    ij.py.run_script("py", macro, args)

    merged_excel(output_1, output_2, excelOutputFile)

    m_df = pd.read_csv(excelOutputFile, sep="\t")
    m_df["Roughness"] = 1 - (m_df["CPerim."] / m_df["Perim."])

    nucleus_area = m_df.loc[0, "Area"]
    cytoplasm_area = m_df.loc[1, "Area"]
    m_df["NC_ratio"] = [None, None]
    m_df.loc[1, "NC_ratio"] = nucleus_area / cytoplasm_area
    m_df.to_csv(excelOutputFile, index=False)


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


def merged_excel(output_1, output_2, excelOutputFile):
    """Save three CSV result files into different sheets in an Excel file.

    Args:
        output_1 (str): Path to the first results CSV.
        output_2 (str): Path to the second results CSV.
        excelOutputFile (str): Path to save the Excel file.

    Returns:
        None
    """
    df1 = pd.read_csv(output_1, sep=",")
    df2 = pd.read_csv(output_2, sep=",")

    target_column = df1.columns[3]
    df2 = df2.rename(columns={df2.columns[0]: "CPerim."})

    df1.insert(df1.columns.get_loc(target_column) + 1, "CPerim.", df2["CPerim."])
    df1.to_csv(excelOutputFile, sep="\t", index=False)
    os.remove(output_2)
