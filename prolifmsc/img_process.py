import os
import cv2
import numpy as np
import torch
from prolifmsc.utils.io import get_paths, extract_identifier
from cellpose import models, io
from torchvision.ops import masks_to_boxes


def outlines_to_text(base, outlines):
    """Save outlines as text in a file.

    Args:
        base (str): Base file name for the output text file.
        outlines (list): List of outlines as pixel coordinates.

    Returns:
        None
    """
    with open(base + "_cp_outlines.txt", "w") as f:
        for o in outlines:
            xy = list(o.flatten())
            xy_str = ",".join(map(str, xy))
            f.write(xy_str)
            f.write("\n")


def get_cyto_masks(img_path):
    """Generate segmentation masks using the Cellpose model.

    Args:
        img_path (str): Path to the input image.

    Returns:
        ndarray: Segmentation masks generated by the Cellpose model.
    """
    model = models.CellposeModel(
        gpu=True, model_type=r"C:\Users\B30027\.cellpose\models\model_BDL6_label_test"
    )
    img = io.imread(img_path)
    masks, flow, _ = model.eval(img, channels=[0, 0])
    return masks


def get_outlines(masks):
    """Get outlines of masks as a list to loop over for plotting.

    Args:
        masks (ndarray): masks (0=no cells, 1=first cell, 2=second cell,...)

    Returns:
        list: List of outlines as pixel coordinates.

    """
    outpix = []
    for n in np.unique(masks)[1:]:
        mn = masks == n
        if mn.sum() > 0:
            contours = cv2.findContours(
                mn.astype(np.uint8),
                mode=cv2.RETR_EXTERNAL,
                method=cv2.CHAIN_APPROX_NONE,
            )
            contours = contours[-2]
            cmax = np.argmax([c.shape[0] for c in contours])
            pix = contours[cmax].astype(int).squeeze()
            if len(pix) > 4:
                outpix.append(pix)
            else:
                outpix.append(np.zeros((0, 2)))
    return outpix


def process_images_and_crop(pc_folder_name, df_folder_name):
    """Process images to segment and crop regions based on masks.

    Args:
        pc_folder_name (str): Path to the folder containing PC images.
        df_folder_name (str): Path to the folder containing DF images.

    Returns:
        None
    """
    pc_images = get_paths(pc_folder_name)
    df_images = get_paths(df_folder_name)

    for pc_img_path in pc_images:
        pc_base_name = os.path.basename(pc_img_path)
        pc_identifier = extract_identifier(pc_base_name)

        df_img_path = next(
            (
                img
                for img in df_images
                if extract_identifier(os.path.basename(img)) == pc_identifier
            ),
            None,
        )

        if df_img_path:
            df_img = cv2.imread(df_img_path)

            cyto_masks = get_cyto_masks(pc_img_path)
            unique_cyto_labels = np.unique(cyto_masks)[1:]
            binary_cyto_masks = np.array(
                [(cyto_masks == label).astype(np.uint8) for label in unique_cyto_labels]
            )

            print("binary_cyto_masks type:", type(binary_cyto_masks))
            print(
                "binary_cyto_masks shape:",
                (
                    binary_cyto_masks.shape
                    if hasattr(binary_cyto_masks, "shape")
                    else "No shape"
                ),
            )
            print(
                "binary_cyto_masks dtype:",
                (
                    binary_cyto_masks.dtype
                    if hasattr(binary_cyto_masks, "dtype")
                    else "No dtype"
                ),
            )

            masks_tensor = torch.tensor(binary_cyto_masks, dtype=torch.float32)

            bounding_boxes = masks_to_boxes(masks_tensor)

            masked_img = df_img.copy()

            base_name = os.path.splitext(os.path.basename(df_img_path))[0]

            df_crop_folder = os.path.join("data", "output", "crop", df_folder_name)
            os.makedirs(df_crop_folder, exist_ok=True)
            df_outline_folder = os.path.join(
                "data", "output", "outlines", df_folder_name
            )
            os.makedirs(df_outline_folder, exist_ok=True)

            for i, box in enumerate(bounding_boxes):
                x_min, y_min, x_max, y_max = map(int, box)

                current_mask = binary_cyto_masks[i]
                masked_img_copy = masked_img.copy()
                masked_img_copy[current_mask == 0] = 0
                cropped_img = masked_img_copy[y_min:y_max, x_min:x_max]

                output_img_path = os.path.join(df_crop_folder, f"{base_name}_{i}.jpg")
                output_txt_path = os.path.join(df_outline_folder, f"{base_name}_{i}")

                outlines = get_outlines(current_mask)
                outlines_to_text(output_txt_path, outlines)
                cv2.imwrite(output_img_path, cropped_img)

                print(f"Saved cropped image: {output_img_path}")
        else:
            print(f"No matching image found for {pc_base_name}")