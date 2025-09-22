#!/usr/bin/env python3
import argparse
from PyPDF2 import PdfReader, PdfWriter
import os


def split_pdf_by_pages(input_pdf):
    """
    Split a PDF file into individual pages, creating a new PDF file for each page in a new directory.

    Args:
        input_pdf (str): Path to the input PDF file
    """
    try:
        # Read the input PDF
        reader = PdfReader(input_pdf)
        total_pages = len(reader.pages)

        # Get base filename without extension
        base_name = os.path.splitext(os.path.basename(input_pdf))[0]

        # Create a directory with the same name as the PDF
        output_dir = os.path.join(os.getcwd(), base_name)
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)

        # Process each page
        for page_num in range(total_pages):
            # Create a new PDF writer
            writer = PdfWriter()

            # Add the current page
            writer.add_page(reader.pages[page_num])

            # Create output filename (page_num + 1 for 1-based page numbering)
            output_filename = f"{base_name}_page{page_num + 1}.pdf"
            output_path = os.path.join(output_dir, output_filename)

            # Save the output PDF
            with open(output_path, "wb") as output_file:
                writer.write(output_file)

            print(f"Created: {output_path}")

        print(
            f"Successfully split {total_pages} pages from {input_pdf} into directory: {output_dir}"
        )

    except Exception as e:
        print(f"Error: {str(e)}")


def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Split PDF file into individual pages")
    parser.add_argument("pdf_path", help="Path to the input PDF file")

    # Parse arguments
    args = parser.parse_args()

    # Check if file exists
    if not os.path.exists(args.pdf_path):
        print(f"Error: File '{args.pdf_path}' does not exist")
        return

    # Process the PDF
    split_pdf_by_pages(args.pdf_path)


if __name__ == "__main__":
    main()
