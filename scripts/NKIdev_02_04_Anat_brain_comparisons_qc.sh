#!/bin/bash 

file1=$1
file2=$2
file3=$3
file4=$4
file1="/home/bramirez/projects/InfantDevelopment/NKIdev/info/anat_comparison_file1.txt"
file2="/home/bramirez/projects/InfantDevelopment/NKIdev/info/anat_comparison_file2.txt"
file3="/home/bramirez/projects/InfantDevelopment/NKIdev/info/anat_comparison_file3.txt"
file4="/home/bramirez/projects/InfantDevelopment/NKIdev/info/anat_comparison_file4.txt"
#subject_list=/home/bramirez/projects/InfantDevelopment/NKIdev/info/subs_and_sessions_temp.txt
subject_list1=/home/bramirez/projects/InfantDevelopment/NKIdev/info/rerunning_infant_with_InfantJLC_subs_and_sessions.txt
base_data=/projects/NHP_processed/developmental_out/
base_out=/projects/NHP_processed/developmental_out/QC_images/
imageout=/projects/NHP_processed/developmental_out/QC_images/BrainAgeComparisons
old_attempts=/projects/NHP_processed/developmental_out/QC_images/old_attempts
scene_files=/projects/NHP_processed/developmental_out/QC_images/scene_files/

if [ ! -d ${imageout} ]; then
  mkdir -p ${imageout};
else
  var=`date +"%FORMAT_STRING"`
  now=`date +"%T_%m_%d_%Y"`
  now=`date +"%Y-%m-%d-%H%M"`
  echo "${now}"
  imageout_dir=`basename ${imageout}`
  mv ${imageout} ${old_attempts}/${imageout_dir}_${now}
fi
# Get the number of subjects (lines) in the files (assuming both files have the same number of lines)
num_subjects=$(wc -l < "$file1")+1

# Loop through x number of subjects
i=0
for ((i=1; i<=num_subjects; i++)); do
  echo $i 

  # Read the ith line of file1 and file2
  line_file1=$(sed "${i}q;d" "$file1")
  echo ${line_file1}
  sesh1=`echo $line_file1 | cut -d '/' -f 2-`
  sub1=`echo $line_file1 | cut -d '/' -f 1`
  #SUB2
  line_file2=$(sed "${i}q;d" "$file2")
  echo ${line_file2}
  sesh2=`echo $line_file2 | cut -d '/' -f 2-`
  sub2=`echo $line_file2 | cut -d '/' -f 1`
  #SUB3
  line_file3=$(sed "${i}q;d" "$file3")
  echo ${line_file3}
  sesh3=`echo $line_file3 | cut -d '/' -f 2-`
  sub3=`echo $line_file3 | cut -d '/' -f 1`
  line_file4=$(sed "${i}q;d" "$file4")
  ages=$(sed "${i}q;d" "$file4")
  #ages="Ages_days_32_887_NaN"
  # Split the string using awk
  Age1=$(echo "$ages" | awk -F '_' '{print $1 "_" $2 "_" $3}')
  Age2=$(echo "$ages" | awk -F '_' '{print $1 "_" $2 "_" $4}')
  Age3=$(echo "$ages" | awk -F '_' '{print $1 "_" $2 "_" $5}')
  # Print the new variables to verify the values
  echo "$Age1" # Ages_days_32
  echo "$Age2" # Ages_days_887
  echo "$Age3" # Ages_days_NaN
  #T1w acpc dc restore brain
  rm ${scene_files}/example_files/Brain_1.nii.gz
  rm ${scene_files}/example_files/Brain_2.nii.gz
  rm ${scene_files}/example_files/Brain_3.nii.gz
  cp ${base_data}/${line_file1}/files/T1w/T1w_acpc_dc_restore_brain.nii.gz ${scene_files}/example_files/Brain_1.nii.gz
  cp ${base_data}/${line_file2}/files/T1w/T1w_acpc_dc_restore_brain.nii.gz ${scene_files}/example_files/Brain_2.nii.gz
  cp ${base_data}/${line_file3}/files/T1w/T1w_acpc_dc_restore_brain.nii.gz ${scene_files}/example_files/Brain_3.nii.gz
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 1 ${imageout}/${line_file4}_T1w_acpc_dc_brain_compare.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 2 ${imageout}/${sub1}_${sesh1}_${Age1}_T1w_acpc_dc_brain_all_views.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 3 ${imageout}/${sub1}_${sesh1}_${Age1}_T1w_acpc_dc_brain_axial.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 4 ${imageout}/${sub2}_${sesh2}_${Age2}_T1w_acpc_dc_brain_all_views.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 5 ${imageout}/${sub2}_${sesh2}_${Age2}_T1w_acpc_dc_brain_axial.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 6 ${imageout}/${sub3}_${sesh3}_${Age3}_T1w_acpc_dc_brain_all_views.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 7 ${imageout}/${sub3}_${sesh3}_${Age3}_T1w_acpc_dc_brain_axial.png 1000 800

  #T2w acpc dc restore brain
  rm ${scene_files}/example_files/Brain_1.nii.gz
  rm ${scene_files}/example_files/Brain_2.nii.gz
  rm ${scene_files}/example_files/Brain_3.nii.gz
  cp ${base_data}/${line_file1}/files/T1w/T2w_acpc_dc_restore_brain.nii.gz ${scene_files}/example_files/Brain_1.nii.gz
  cp ${base_data}/${line_file2}/files/T1w/T2w_acpc_dc_restore_brain.nii.gz ${scene_files}/example_files/Brain_2.nii.gz
  cp ${base_data}/${line_file3}/files/T1w/T2w_acpc_dc_restore_brain.nii.gz ${scene_files}/example_files/Brain_3.nii.gz
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 1 ${imageout}/${line_file4}_T2w_acpc_dc_brain_compare.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 2 ${imageout}/${sub1}_${sesh1}_${Age1}_T2w_acpc_dc_brain_all_views.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 3 ${imageout}/${sub1}_${sesh1}_${Age1}_T2w_acpc_dc_brain_axial.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 4 ${imageout}/${sub2}_${sesh2}_${Age2}_T2w_acpc_dc_brain_all_views.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 5 ${imageout}/${sub2}_${sesh2}_${Age2}_T2w_acpc_dc_brain_axial.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 6 ${imageout}/${sub3}_${sesh3}_${Age3}_T2w_acpc_dc_brain_all_views.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 7 ${imageout}/${sub3}_${sesh3}_${Age3}_T2w_acpc_dc_brain_axial.png 1000 800
  
  #T1w acpc dc restore head
  rm ${scene_files}/example_files/Brain_1.nii.gz
  rm ${scene_files}/example_files/Brain_2.nii.gz
  rm ${scene_files}/example_files/Brain_3.nii.gz
  cp ${base_data}/${line_file1}/files/T1w/T1w_acpc_dc_restore.nii.gz ${scene_files}/example_files/Brain_1.nii.gz
  cp ${base_data}/${line_file2}/files/T1w/T1w_acpc_dc_restore.nii.gz ${scene_files}/example_files/Brain_2.nii.gz
  cp ${base_data}/${line_file3}/files/T1w/T1w_acpc_dc_restore.nii.gz ${scene_files}/example_files/Brain_3.nii.gz
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 1 ${imageout}/${line_file4}_T1w_acpc_dc_head_compare.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 2 ${imageout}/${sub1}_${sesh1}_${Age1}_T1w_acpc_dc_head_all_views.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 3 ${imageout}/${sub1}_${sesh1}_${Age1}_T1w_acpc_dc_head_axial.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 4 ${imageout}/${sub2}_${sesh2}_${Age2}_T1w_acpc_dc_head_all_views.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 5 ${imageout}/${sub2}_${sesh2}_${Age2}_T1w_acpc_dc_head_axial.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 6 ${imageout}/${sub3}_${sesh3}_${Age3}_T1w_acpc_dc_head_all_views.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 7 ${imageout}/${sub3}_${sesh3}_${Age3}_T1w_acpc_dc_head_axial.png 1000 800
  
  #T2w acpc dc restore head
  rm ${scene_files}/example_files/Brain_1.nii.gz
  rm ${scene_files}/example_files/Brain_2.nii.gz
  rm ${scene_files}/example_files/Brain_3.nii.gz
  cp ${base_data}/${line_file1}/files/T1w/T2w_acpc_dc_restore.nii.gz ${scene_files}/example_files/Brain_1.nii.gz
  cp ${base_data}/${line_file2}/files/T1w/T2w_acpc_dc_restore.nii.gz ${scene_files}/example_files/Brain_2.nii.gz
  cp ${base_data}/${line_file3}/files/T1w/T2w_acpc_dc_restore.nii.gz ${scene_files}/example_files/Brain_3.nii.gz
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 1 ${imageout}/${line_file4}_T2w_acpc_dc_head_compare.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 2 ${imageout}/${sub1}_${sesh1}_${Age1}_T2w_acpc_dc_head_all_views.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 3 ${imageout}/${sub1}_${sesh1}_${Age1}_T2w_acpc_dc_head_axial.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 4 ${imageout}/${sub2}_${sesh2}_${Age2}_T2w_acpc_dc_head_all_views.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 5 ${imageout}/${sub2}_${sesh2}_${Age2}_T2w_acpc_dc_head_axial.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 6 ${imageout}/${sub3}_${sesh3}_${Age3}_T2w_acpc_dc_head_all_views.png 1000 800
  wb_command -show-scene  -use-window-size ${scene_files}/comparing_brains_across_subject_ages.scene 7 ${imageout}/${sub3}_${sesh3}_${Age3}_T2w_acpc_dc_head_axial.png 1000 800
  
done
python3 /home/bramirez/projects/InfantDevelopment/NKIdev/scripts/create_brain_images_qc_html.py /projects/NHP_processed/developmental_out/QC_images/BrainAgeComparisons/ T1w_acpc_dc_brain_axial.png
python3 /home/bramirez/projects/InfantDevelopment/NKIdev/scripts/create_brain_images_qc_html.py /projects/NHP_processed/developmental_out/QC_images/BrainAgeComparisons/ T2w_acpc_dc_brain_axial.png
#python /home/bramirez/projects/InfantDevelopment/NKIdev/scripts/Make_sub-XXX_ses-XXX_three_column_html.py ${imageout} _T1w_acpc_dc_brain_axial.png
#python /home/bramirez/projects/InfantDevelopment/NKIdev/scripts/Make_sub-XXX_ses-XXX_three_column_html.py /projects/NHP_processed/developmental_out/QC_images/BrainAgeComparisons _T1w_acpc_dc_brain_axial.png

#python /home/bramirez/projects/InfantDevelopment/NKIdev/scripts/create_qc_html.py /projects/NHP_processed/developmental_out/QC_images/BrainAgeComparisons/
#python3 /home/bramirez/projects/InfantDevelopment/NKIdev/scripts/create_brain_images_qc_html.py /projects/NHP_processed/developmental_out/QC_images/BrainAgeComparisons/ T1w_acpc_dc_brain_axial.png

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


