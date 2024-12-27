import os


def get_paths(folder_name, crop=False, anal=False, outlines=False):
    """Get all file paths from the specified folder.

    Args:
        folder_name (str): Name of the folder.

    Returns:
        list: List of file paths with certain extension.
    """
    if crop:
        extensions = (".jpg", ".jpeg", ".png", ".bmp", ".tiff", ".gif")
        base_path = os.path.join("data", "input", folder_name)
    elif anal:
        extensions = (".jpg", ".jpeg", ".png", ".bmp", ".tiff", ".gif")
        base_path = os.path.join("data", "output", "crop", folder_name)
    elif outlines:
        extensions = ".txt"
        base_path = os.path.join("data", "output", "outlines", folder_name)
    else:
        raise ValueError(
            "One of 'crop', 'anal', or 'outlines' must be True to specify the file type."
        )

    if not os.path.exists(base_path):
        raise FileNotFoundError(f"The folder {base_path} does not exist.")

    paths = [
        os.path.join(base_path, file_name)
        for file_name in os.listdir(base_path)
        if file_name.lower().endswith(extensions)
    ]
    return paths


def extract_identifier(file_name):
    """Extract the identifier from the file name after the first hyphen.

    Args:
        file_name (str): File name of the image.

    Returns:
        str: Identifier string extracted from the file name.
    """
    return file_name.split("-", 1)[1]


def get_model(model_name):
    home_dir = os.path.expanduser("~")
    cellpose_dir = os.path.join(home_dir, ".cellpose", "models")

    if not os.path.exists(cellpose_dir):
        raise FileNotFoundError(
            f"The Cellpose model directory '{cellpose_dir}' does not exist."
        )

    model_path = os.path.join(cellpose_dir, model_name)
    if not os.path.exists(model_path):
        raise FileNotFoundError(
            f"The model file '{model_path}' does not exist in '{cellpose_dir}'."
        )
    return model_path
