#/home/projects/PRIME-DE/site-uwmadison/sub-1001/anat/
#/home/bramirez/projects/PRIME-DE/UNet/site-uwmadison/sub-1001/anat

base_data=/home/projects/PRIME-DE/site-uwmadison
base_out=/home/bramirez/projects/PRIME-DE/UNet/site-uwmadison
imageout=/home/bramirez/projects/PRIME-DE/UNet/site-uwmadison/mask_QC_images

while read -r line
do
  echo ${line}
  rm /home/bramirez/projects/PRIME-DE/UNet/scripts/scene_files/example_files/T1w_image.nii.gz
  rm /home/bramirez/projects/PRIME-DE/UNet/scripts/scene_files/example_files/T1w_image_mask.nii.gz
  
  cp ${base_out}/${line}/anat/${line}_T1w.nii.gz /home/bramirez/projects/PRIME-DE/UNet/scripts/scene_files/example_files/T1w_image.nii.gz
  cp ${base_out}/${line}/anat/${line}_T1w_pre_mask.nii.gz /home/bramirez/projects/PRIME-DE/UNet/scripts/scene_files/example_files/T1w_image_mask.nii.gz
  wb_command -show-scene  -use-window-size /home/bramirez/projects/PRIME-DE/UNet/scripts/scene_files/checking_T1w_masks.scene 1 ${imageout}/sag.png 1000 800
  wb_command -show-scene  -use-window-size /home/bramirez/projects/PRIME-DE/UNet/scripts/scene_files/checking_T1w_masks.scene 2 ${imageout}/cor.png 1000 800
  wb_command -show-scene  -use-window-size /home/bramirez/projects/PRIME-DE/UNet/scripts/scene_files/checking_T1w_masks.scene 3 ${imageout}/ax.png 1000 800
  convert -append ${imageout}/ax.png ${imageout}/sag.png ${imageout}/cor.png ${imageout}/${line}.png
done < /home/bramirez/projects/PRIME-DE/UNet/site-uwmadison/sublist.txt


