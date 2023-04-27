import os
import glob
import sys
import re
from collections import defaultdict

def create_html_file(output_file, qc_files):
    with open(output_file, 'w') as f:
        f.write('<!DOCTYPE html>\n<html>\n<head>\n<style>\n')
        f.write('table {width: 100%;}\ntd {vertical-align: top;}\n')
        f.write('</style>\n</head>\n<body>\n')

        f.write('<table>\n<tr>\n')
        for i, qc_file_list in enumerate(qc_files):
            f.write('<td>Subject {}</td>\n'.format(i+1))
        f.write('</tr>\n')

        max_rows = max(len(qc_file_list) for qc_file_list in qc_files)
        for row in range(max_rows):
            f.write('<tr>\n')
            for qc_file_list in qc_files:
                if row < len(qc_file_list):
                    relative_path = os.path.relpath(qc_file_list[row], os.path.dirname(output_file))
                    print("Adding image:", qc_file_list[row])
                    f.write('<td><img src="{}" alt="{}" width="100%"></td>\n'.format(relative_path, os.path.basename(qc_file_list[row])))
                else:
                    f.write('<td></td>\n')
            f.write('</tr>\n')

        f.write('</table>\n</body>\n</html>\n')

def get_subjects_and_sessions(base_dir, qc_type):
    qc_files = glob.glob(os.path.join(base_dir, '*_*_*{}'.format(qc_type)))
    print("Matched files:", qc_files)
    subjects_sessions = defaultdict(set)

    pattern = re.compile(r'sub-(\d+)_ses-(\d+)_Ages_days_(\d+)_T1w_acpc_dc_brain_axial.png')

    for file in qc_files:
        basename = os.path.basename(file)
        match = pattern.match(basename)
        if match:
            subject, session, _ = match.groups()
            subjects_sessions[subject].add(session)

    return subjects_sessions

def main():
    if len(sys.argv) != 3:
        print("Usage: python script.py <base_dir> <qc_type>")
        sys.exit(1)

    base_dir = sys.argv[1]
    qc_type = sys.argv[2]
    output_base_dir = os.path.abspath(base_dir)

    subjects_sessions = get_subjects_and_sessions(base_dir, qc_type)
    print("Base directory:", base_dir)
    print("QC type:", qc_type)
    subjects = sorted(subjects_sessions.keys())

    pattern = re.compile(r'sub-(\d+)_ses-(\d+)_Ages_days_(\d+)_T1w_acpc_dc_brain_axial.png')

    qc_files = []

    for subject in subjects:
        subject_qc_files = sorted(glob.glob(os.path.join(base_dir, '{}_*_{}'.format(subject, qc_type))), key=lambda img: tuple(map(int, pattern.search(img).groups())))
        print("Subject {}: {}".format(subject, subject_qc_files))
        qc_files.append(subject_qc_files)

    output_file = os.path.join(output_base_dir, 'qc_images_{}.html'.format(qc_type.replace("*", "").replace(".png", "")))

    create_html_file(output_file, qc_files)

if __name__ == "__main__":
    main()
