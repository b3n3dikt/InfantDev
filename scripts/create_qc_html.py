import os
import glob
import sys

def create_html_file(output_file, image_files):
    with open(output_file, 'w') as f:
        f.write('<!DOCTYPE html>\n<html>\n<head>\n<style>\n')
        f.write('table {width: 100%;}\ntd {vertical-align: top;}\n')
        f.write('</style>\n</head>\n<body>\n')

        f.write('<table>\n')

        for image_file in image_files:
            relative_path = os.path.relpath(image_file, os.path.dirname(output_file))
            print("Adding image:", image_file)
            f.write('<tr><td><img src="{}" alt="{}" width="100%"></td></tr>\n'.format(relative_path, os.path.basename(image_file)))

        f.write('</table>\n</body>\n</html>\n')

def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py <images_dir>")
        sys.exit(1)

    images_dir = sys.argv[1]
    output_base_dir = os.path.abspath(os.path.join(images_dir, ".."))

    image_files = glob.glob(os.path.join(images_dir, '*T1w_acpc_dc_brain_axial.png'))
    print("Matched files:", image_files)

    output_file = os.path.join(output_base_dir, 'qc_images.html')

    create_html_file(output_file, image_files)

if __name__ == "__main__":
    main()
