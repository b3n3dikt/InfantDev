import os
import glob
import sys
import re
from PIL import Image, ImageDraw, ImageFont

def create_html_file(output_file, image_files):
    with open(output_file, 'w') as f:
        f.write('<!DOCTYPE html>\n<html>\n<head>\n<style>\n')
        f.write('table {width: 100%;}\ntd {vertical-align: top;}\n')
        f.write('</style>\n</head>\n<body>\n')

        f.write('<table>\n')

        for image_file in image_files:
            relative_path = os.path.relpath(image_file, os.path.dirname(output_file))
            print("Adding image:", image_file)
            f.write('<tr><td>{}</td></tr>\n'.format(os.path.basename(image_file)))
            f.write('<tr><td><img src="{}" alt="{}" width="100%"></td></tr>\n'.format(relative_path, os.path.basename(image_file)))

        f.write('</table>\n</body>\n</html>\n')

def sort_image_files(image_files):
    def parse_subject_session(file_name):
        match = re.match(r'sub-(\d+)_ses-(\d+)', file_name)
        return (int(match.group(1)), int(match.group(2))) if match else (0, 0)

    return sorted(image_files, key=lambda x: parse_subject_session(os.path.basename(x)))

def main():
    if len(sys.argv) != 3:
        print("Usage: python script.py <images_dir> <image_suffix>")
        sys.exit(1)

    images_dir = sys.argv[1]
    image_suffix = sys.argv[2]
    output_base_dir = os.path.abspath(os.path.join(images_dir, ".."))

    image_files = glob.glob(os.path.join(images_dir, '*{}'.format(image_suffix)))
    image_files = sort_image_files(image_files)
    print("Matched files:", image_files)

    output_file = os.path.join(output_base_dir, 'qc_images_{}.html'.format(image_suffix.replace(".png", "")))

    create_html_file(output_file, image_files)

if __name__ == "__main__":
    main()
