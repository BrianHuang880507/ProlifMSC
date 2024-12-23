import sys
import os

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import unittest
from unittest.mock import patch, MagicMock
from prolifmsc.main import cell_analyze


class TestProcessImages(unittest.TestCase):
    @patch("prolifmsc.main.cell_analyze")
    def test_cell_analyze(self, mock_cell_analyze):
        args = MagicMock()
        args.data_name = "DF"
        cell_analyze(args)
        mock_cell_analyze.assert_called_once_with("DF")


if __name__ == "__main__":
    unittest.main()
