import os
import re

html = open("index.html", "w")
html.write("<html><body>")

directory = 'images'
images = os.listdir(directory)
pattern = re.compile(r'sub-(\d+)_ses-(\d+)_Ages_days_(\d+)_T1w_acpc_dc_brain_axial.png')
sorted_images = sorted(images, key=lambda img: tuple(map(int, pattern.search(img).groups())))

for image in sorted_images:
    html.write(f'<p>{image}</p>')
    html.write(f'<img src="{os.path.join(directory, image)}" width="300" height="300"/>')

html.write("</body></html>")
html.close()