import sys
import os

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import unittest
from unittest.mock import patch, MagicMock
from prolifmsc.main import process_images


class TestProcessImages(unittest.TestCase):
    @patch("prolifmsc.main.process_images_and_crop")
    def test_process_images(self, mock_process_images_and_crop):
        args = MagicMock()
        args.pc_folder_name = "PC"
        args.df_folder_name = "DF"
        process_images(args)
        mock_process_images_and_crop.assert_called_once_with("PC", "DF")


if __name__ == "__main__":
    unittest.main()
