#!/usr/bin/env python3
import argparse
from PyPDF2 import PdfReader, PdfWriter
import os


def split_pdf_by_ranges(input_pdf, page_ranges):
    """
    Split a PDF file according to specified page ranges.

    Args:
        input_pdf (str): Path to the input PDF file
        page_ranges (str): Comma-separated page numbers defining ranges (e.g., "1,4" means pages 1-4)
    """
    try:
        # Read the input PDF
        reader = PdfReader(input_pdf)

        # Convert page numbers to list and sort them
        pages = [int(p) for p in page_ranges.split(",")]
        pages.sort()

        # Create ranges from consecutive numbers in the list
        ranges = []
        start = pages[0]
        for i in range(len(pages) - 1):
            if i == len(pages) - 2:  # If this is the second-to-last number
                ranges.append((start, pages[-1]))
            elif pages[i + 1] - pages[i] > 1:  # If there's a gap
                ranges.append((start, pages[i]))
                start = pages[i + 1]

        if len(pages) == 1:
            ranges = [(pages[0], pages[0])]

        # Get base filename without extension
        base_name = os.path.splitext(input_pdf)[0]

        # Process each range
        for start, end in ranges:
            writer = PdfWriter()

            # Add pages for current range (subtract 1 because PDF pages are 0-indexed)
            for page_num in range(start - 1, end):
                writer.add_page(reader.pages[page_num])

            # Create output filename
            output_filename = f"{base_name}_pages_{start}-{end}.pdf"

            # Save the output PDF
            with open(output_filename, "wb") as output_file:
                writer.write(output_file)

            print(f"Created: {output_filename}")

    except Exception as e:
        print(f"Error: {str(e)}")


def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Split PDF file by page ranges")
    parser.add_argument("pdf_path", help="Path to the input PDF file")
    parser.add_argument(
        "--pages",
        required=True,
        help='Comma-separated page numbers defining ranges (e.g., "1,4" creates a PDF with pages 1-4)',
    )

    # Parse arguments
    args = parser.parse_args()

    # Check if file exists
    if not os.path.exists(args.pdf_path):
        print(f"Error: File '{args.pdf_path}' does not exist")
        return

    # Process the PDF
    split_pdf_by_ranges(args.pdf_path, args.pages)


if __name__ == "__main__":
    main()
