#!/bin/bash 

subject_list=$1
#subject_list=/home/bramirez/projects/InfantDevelopment/NKIdev/info/subs_and_sessions_temp.txt
subject_list=/home/bramirez/projects/InfantDevelopment/NKIdev/info/rerunning_infant_with_InfantJLC_subs_and_sessions.txt
base_data=/projects/NHP_processed/developmental_out/
base_out=/projects/NHP_processed/developmental_out/QC_images/
imageout=/projects/NHP_processed/developmental_out/QC_images/anat_processed_QC_images_20230421
scene_files=/projects/NHP_processed/developmental_out/QC_images/scene_files/

if [ ! -d ${imageout} ]; then
  mkdir -p ${imageout};
fi
#processed_folder=/projects/NHP_processed/developmental_out/
#mask_folder=/projects/NHP_processed/developmental_out/masks/anatomical/
#UNet_models=/home/bramirez/projects/InfantDevelopment/NKIdev/files/UNet/models
#/projects/NHP_processed/developmental_out/QC_images/scene_files/checking_T1w_masks.scene
#/home/bramirez/projects/InfantDevelopment/NKIdev/info/subs_and_sessions.txt
#line=sub-003/ses-018
while read -r line
do
  echo ${line}
  sesh=`echo $line | cut -d '/' -f 2-`
  echo $sesh
  sub=`echo $line | cut -d '/' -f 1`
  echo $sub
  rm ${scene_files}/example_files/T1w_image.nii.gz
  rm ${scene_files}/example_files/T1w_image_mask.nii.gz
  rm ${scene_files}/example_files//MNINonLinear/aseg_acpc.nii.gz
  rm ${scene_files}/example_files//MNINonLinear/ribbon.nii.gz
  rm ${scene_files}/example_files//MNINonLinear/T1w_acpc_dc_restore_brain.nii.gz
  rm ${scene_files}/example_files//MNINonLinear/T1w_acpc_dc_restore.nii.gz
  rm ${scene_files}/example_files//MNINonLinear/T1w_restore_brain.nii.gz
  rm ${scene_files}/example_files//MNINonLinear/T1w_restore.nii.gz
  rm ${scene_files}/example_files//MNINonLinear/T2w_restore_brain.nii.gz
  rm ${scene_files}/example_files//MNINonLinear/T2w_restore.nii.gz
  rm ${scene_files}/example_files//MNINonLinear/wmparc.nii.gz
  rm -rf ${scene_files}/example_files/MNINonLinear/fsaverage_LR32k
  
  cp ${base_data}/${line}/files/T1w/aseg_acpc.nii.gz ${scene_files}/example_files/MNINonLinear/aseg_acpc.nii.gz
  cp ${base_data}/${line}/files/MNINonLinear/ribbon.nii.gz ${scene_files}/example_files/MNINonLinear/ribbon.nii.gz
  cp ${base_data}/${line}/files/T1w/T1w_acpc_dc_restore_brain.nii.gz ${scene_files}/example_files/MNINonLinear/T1w_acpc_dc_restore_brain.nii.gz
  cp ${base_data}/${line}/files/T1w/T1w_acpc_dc_restore.nii.gz ${scene_files}/example_files/MNINonLinear/T1w_acpc_dc_restore.nii.gz
  cp ${base_data}/${line}/files/MNINonLinear/T1w_restore_brain.nii.gz ${scene_files}/example_files/MNINonLinear/T1w_restore_brain.nii.gz
  cp ${base_data}/${line}/files/MNINonLinear/T1w_restore.nii.gz ${scene_files}/example_files/MNINonLinear/T1w_restore.nii.gz
  cp ${base_data}/${line}/files//MNINonLinear/T2w_restore_brain.nii.gz ${scene_files}/example_files/MNINonLinear/T2w_restore_brain.nii.gz
  cp ${base_data}/${line}/files/MNINonLinear/T2w_restore.nii.gz ${scene_files}/example_files/MNINonLinear/T2w_restore.nii.gz
  cp ${base_data}/${line}/files/MNINonLinear/wmparc.nii.gz ${scene_files}/example_files/MNINonLinear/wmparc.nii.gz
  cp -r ${base_data}/${line}/files/MNINonLinear/fsaverage_LR32k ${scene_files}/example_files/MNINonLinear/fsaverage_LR32k
  
  #wb_command -volume-label-export-table wmparc.nii.gz 1 wmparc_table.txt
  wb_command -volume-label-import ${scene_files}/example_files/MNINonLinear/aseg_acpc.nii.gz ${scene_files}/example_files/wmparc_table.txt ${scene_files}/example_files/MNINonLinear/aseg_acpc.nii.gz
  subID=${sub:4:4}
  echo ${subID}
  rename "s/${subID}/001/" ${scene_files}/example_files/MNINonLinear/fsaverage_LR32k/*
                           
  #wb_command -show-scene  -use-window-size ${scene_files}/checking_T1w_masks.scene 1 ${imageout}/sag.png 1000 800
  #wb_command -show-scene  -use-window-size ${scene_files}/checking_T1w_masks.scene 2 ${imageout}/cor.png 1000 800
  #wb_command -show-scene  -use-window-size ${scene_files}/checking_T1w_masks.scene 3 ${imageout}/ax.png 1000 800
  #convert -append ${imageout}/ax.png ${imageout}/sag.png ${imageout}/cor.png ${imageout}/${sub}_${sesh}_mask_qc.png
  wb_command -show-scene  -use-window-size ${scene_files}/Anat_QC_outputs.scene 1 ${imageout}/${sub}_${sesh}_surfaces_wHead_QC.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/Anat_QC_outputs.scene 2 ${imageout}/${sub}_${sesh}_surfaces_wBrain_QC.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/Anat_QC_outputs.scene 3 ${imageout}/${sub}_${sesh}_aseg_acpc_QC.png 1000 800
  #wb_command -show-scene  -use-window-size ${scene_files}/Anat_QC_outputs.scene 4 ${imageout}/${sub}_${sesh}_04.png 1000 800
  #wb_command -show-scene  -use-window-size ${scene_files}/Anat_QC_outputs.scene 5 ${imageout}/${sub}_${sesh}_05.png 1000 800


done < ${subject_list}



### SCRATCH 
#inpath=/home/bramirez/projects/PRIME-DE/UNet/updated_data/site-uwmadison/sub-2354/anat/sub-2354_T1w_pre_mask.nii.gz
#inpath=/home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/site-uwmadison/sub-1009/ses-None/files/MNINonLinear/T1w_restore.nii.gz
#/home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/site-uwmadison/sub-1004/ses-None/files/MNINonLinear/T1w_restore.nii.gz
# filename=`basename ${inpath}`
# echo ${filename}
# MNINonLinear_path=`dirname ${inpath}`
# echo $MNINonLinear_path
# fsaverage_LR32k_path=${MNINonLinear_path}/fsaverage_LR32k

# files_path=`dirname ${MNINonLinear_path}`
# echo $files_path
# ses_path=`dirname ${files_path}`
# ses=`basename ${ses_path}` 
# echo $ses_path
# echo $ses
# sub_path=`dirname ${ses_path}`
# sub=`basename ${sub_path}` 
# echo $sub_path
# echo $sub


# rm -rf /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/example_files/MNINonLinear/fsaverage_LR32k
# rm -rf /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/example_files/MNINonLinear/T1w_restore.nii.gz
# rm -rf /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/example_files/MNINonLinear/T2w_restore.nii.gz
# rm -rf /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/example_files/MNINonLinear/ribbon.nii.gz
# rm -rf /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/example_files/MNINonLinear/wmparc.nii.gz

# cp -r ${fsaverage_LR32k_path} /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/example_files/MNINonLinear/ 
# cp ${MNINonLinear_path}/T1w_restore.nii.gz /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/example_files/MNINonLinear/T1w_restore.nii.gz
# cp ${MNINonLinear_path}/T2w_restore.nii.gz /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/example_files/MNINonLinear/T2w_restore.nii.gz
# cp ${MNINonLinear_path}/ribbon.nii.gz /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/example_files/MNINonLinear/ribbon.nii.gz
# cp -r ${MNINonLinear_path}/wmparc.nii.gz /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/example_files/MNINonLinear/wmparc.nii.gz
# subID=${sub:4:4}
# echo ${subID}
# rename "s/${subID}/1001/" /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/example_files/MNINonLinear/fsaverage_LR32k/*ii
# wb_command -show-scene -use-window-size /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/wb_view_scene_images.scene 1 /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/site-uwmadison/myelinmap/site-uwmadison_sub-${subID}_ses-001_myelinmap.png 1000 800
# wb_command -show-scene -use-window-size /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/wb_view_scene_images.scene 2 /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/site-uwmadison/corthickness/site-uwmadison_sub-${subID}_ses-001_corthickness.png 1000 800
# wb_command -show-scene -use-window-size /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/wb_view_scene_images.scene 3 /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/site-uwmadison/pialcurvature/site-uwmadison_sub-${subID}_ses-001_pialcurvature.png 1000 800
# wb_command -show-scene -use-window-size /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/wb_view_scene_images.scene 4 /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/site-uwmadison/axial/site-uwmadison_sub-${subID}_ses-001_axial.png 1000 800
# wb_command -show-scene -use-window-size /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/wb_view_scene_images.scene 5 /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/site-uwmadison/sagital/site-uwmadison_sub-${subID}_ses-001_saggital.png 1000 800
# wb_command -show-scene -use-window-size /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/wb_view_scene_images.scene 6 /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/site-uwmadison/coronal/site-uwmadison_sub-${subID}_ses-001_coronal.png 1000 800
# wb_command -show-scene -use-window-size /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/wb_view_scene_images.scene 8 /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/site-uwmadison/ribbon/site-uwmadison_sub-${subID}_ses-001_ribbon.png 1000 800
# wb_command -show-scene -use-window-size /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/scene_file/wb_view_scene_images.scene 9 /home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/QC_images/site-uwmadison/wmparc/site-uwmadison_sub-${subID}_ses-001_wmparc.png 1000 800


