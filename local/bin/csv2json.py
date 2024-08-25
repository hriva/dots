#!/usr/bin/env python3
import csv
import json
import sys


# csv_file_path = "conceptos-testing.csv"
# json_file_path = "trainig-test.json"
def csv_to_json(csv_file_path: str, json_file_path: str) -> None:
    # Read the CSV file
    with open(csv_file_path, "r", encoding="utf-8") as csv_file:
        csv_reader = csv.DictReader(csv_file)
        data = list(csv_reader)

    # Write to JSON file
    with open(json_file_path, "w") as json_file:
        json.dump(data, json_file, ensure_ascii=False, indent=2)

    print(f"JSON data written to {json_file_path}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: ./{sys.argv[1]} <input_csv_file> <output_json_file>")
        sys.exit(1)

input_csv = sys.argv[1]
output_json = sys.argv[2]

csv_to_json(input_csv, output_json)
