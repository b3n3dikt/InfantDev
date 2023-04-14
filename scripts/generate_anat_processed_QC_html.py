import os
import argparse

# Set up argument parser
parser = argparse.ArgumentParser(description='Generate an HTML file to display QC images for each subject.')
parser.add_argument('subject_list', help='Path to a text file containing a list of subject IDs, one per line')
parser.add_argument('qc_folder', help='Path to the QC folder')
parser.add_argument('-o', '--output', default='output.html', help='Name of the output HTML file (default: output.html)')

# Parse command-line arguments
args = parser.parse_args()

subject_list_path = args.subject_list
qc_folder = args.qc_folder
output_file = args.output

# Load the list of subject IDs
with open(subject_list_path, 'r') as f:
    subjects = [line.strip() for line in f]

# Define the QC image suffixes
qc_image_suffixes = ['_aseg_acpc_QC.png', '_surfaces_wBrain_QC.png']

# Generate the HTML content
html_content = '<!DOCTYPE html>\n<html>\n<head>\n<meta charset="UTF-8">\n<title>QC Image Gallery</title>\n</head>\n<body>\n'

for subject in subjects:
    html_content += f'<h3>Subject ID: {subject}</h3>\n'
    for suffix in qc_image_suffixes:
        image_path = os.path.join(qc_folder, f'{subject}{suffix}')
        if os.path.exists(image_path):
            html_content += f'<img src="{image_path}" alt="{subject} - {suffix}" style="max-width:100%;"><br>\n'
        else:
            html_content += f'<p>Image not found: {image_path}</p>\n'
    html_content += '<br><br>\n'

html_content += '</body>\n</html>'

# Write the HTML content to a file
with open(output_file, 'w') as f:
    f.write(html_content)

print(f'HTML file generated: {output_file}')