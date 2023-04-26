#!/bin/bash 

subject_list=$1
#subject_list=/home/bramirez/projects/InfantDevelopment/NKIdev/info/subs_and_sessions.txt
base_data=/projects/NHP_processed/developmental_out/
base_out=/projects/NHP_processed/developmental_out/QC_images/
imageout=/projects/NHP_processed/developmental_out/QC_images/mask_QC_images_v2
scene_files=/projects/NHP_processed/developmental_out/QC_images/scene_files/

if [ ! -d ${imageout} ]; then
  mkdir -p ${imageout};
fi
#processed_folder=/projects/NHP_processed/developmental_out/
#mask_folder=/projects/NHP_processed/developmental_out/masks/anatomical/
#UNet_models=/home/bramirez/projects/InfantDevelopment/NKIdev/files/UNet/models
#/projects/NHP_processed/developmental_out/QC_images/scene_files/checking_T1w_masks.scene
#/home/bramirez/projects/InfantDevelopment/NKIdev/info/subs_and_sessions.txt
#line=sub-003/ses-028
while read -r line
do
  echo ${line}
  sesh=`echo $line | cut -d '/' -f 2-`
  echo $sesh
  sub=`echo $line | cut -d '/' -f 1`
  echo $sub
  rm ${scene_files}/example_files/T1w_image.nii.gz
  rm ${scene_files}/example_files/T1w_image_mask.nii.gz
  
  cp ${base_data}/${line}/files/masks/T1w_average.nii.gz ${scene_files}/example_files/T1w_image.nii.gz
  cp ${base_data}/${line}/files/masks/brain_mask.nii.gz ${scene_files}/example_files/T1w_image_mask.nii.gz
  fslmaths ${scene_files}/example_files/T1w_image.nii.gz -mas ${scene_files}/example_files/T1w_image_mask.nii.gz ${scene_files}/example_files/T1w_image_brain.nii.gz
  
  flirt -dof 6 -in ${scene_files}/example_files/T1w_image_brain.nii.gz -ref ${scene_files}/example_files/MacaqueYerkes19_T1w_0.5mm_brain.nii.gz -omat ${scene_files}/example_files/brain2atlas.mat -out ${scene_files}/example_files/T1w_image_brain.nii.gz
  flirt -interp nearestneighbour -in ${scene_files}/example_files/T1w_image_mask.nii.gz -ref ${scene_files}/example_files/MacaqueYerkes19_T1w_0.5mm_brain.nii.gz -o ${scene_files}/example_files/T1w_image_mask.nii.gz -applyxfm -init ${scene_files}/example_files/brain2atlas.mat
  flirt -interp sinc -in ${scene_files}/example_files/T1w_image.nii.gz -ref ${scene_files}/example_files/MacaqueYerkes19_T1w_0.5mm.nii.gz -o ${scene_files}/example_files/T1w_image.nii.gz -applyxfm -init ${scene_files}/example_files/brain2atlas.mat
                           
  #wb_command -show-scene  -use-window-size ${scene_files}/checking_T1w_masks.scene 1 ${imageout}/sag.png 1000 800
  #wb_command -show-scene  -use-window-size ${scene_files}/checking_T1w_masks.scene 2 ${imageout}/cor.png 1000 800
  #wb_command -show-scene  -use-window-size ${scene_files}/checking_T1w_masks.scene 3 ${imageout}/ax.png 1000 800
  #convert -append ${imageout}/ax.png ${imageout}/sag.png ${imageout}/cor.png ${imageout}/${sub}_${sesh}_mask_qc.png
  wb_command -show-scene  -use-window-size ${scene_files}/checking_T1w_masks.scene 4 ${imageout}/${sub}_${sesh}_all_views_mask_qc.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/checking_T1w_masks.scene 5 ${imageout}/${sub}_${sesh}_all_views_wide_format_mask_qc.png 1000 800

done < ${subject_list}


