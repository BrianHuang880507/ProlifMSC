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
