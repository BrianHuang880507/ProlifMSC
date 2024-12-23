from prolifmsc.img_process import process_images_and_crop
from prolifmsc.cell_anal import run_all
import argparse


def process_images(args):
    """Handle image processing and cropping."""
    process_images_and_crop(args.pc_folder_name, args.df_folder_name)


def cell_analyze(args):
    """Handle Fiji ImageJ analysis."""
    run_all(args.data_name)


def main():
    parser = argparse.ArgumentParser(
        description="MSC Project CLI for image processing and analysis."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    # Subcommand for image processing
    process_parser = subparsers.add_parser(
        "process", help="Process and crop images using masks."
    )
    process_parser.add_argument(
        "--pc_folder_name",
        required=True,
        help="Path to the folder containing PC images (e.g., phase-contrast images).",
    )
    process_parser.add_argument(
        "--df_folder_name",
        required=True,
        help="Path to the folder containing DF images (e.g., fluorescent-labeled images).",
    )
    process_parser.set_defaults(func=process_images)

    # Subcommand for Fiji analysis
    analyze_parser = subparsers.add_parser(
        "analyze", help="Run Fiji ImageJ analysis and save results."
    )
    analyze_parser.add_argument(
        "--data_name",
        required=True,
        help="Path to the dataset folder containing cropped images and their corresponding outlines.",
    )
    analyze_parser.set_defaults(func=cell_analyze)

    # Parse the arguments and call the appropriate function
    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
