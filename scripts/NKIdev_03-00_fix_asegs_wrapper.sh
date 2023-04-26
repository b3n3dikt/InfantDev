#!/bin/bash
file1=/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions_parallel.txt
#file1="/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions_2week_template.txt"
cores=2
scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
#code=NKIdev_03-01_fix_asegs_parallel.sh
code=NKIdev_03-01_fix_asegs_just_apply_warps_parallel.sh

Infant_templates=/home/bramirez/projects/ROI_sets/templates_all/Infant_templates
t1w_template_head=sub-OOPS_ses-20190509_T1w_acpc_dc_restore.nii.gz
t1w_template_brain=sub-OOPS_ses-20190509_T1w_acpc_dc_restore_brain.nii.gz
t1w_template_aseg=sub-OOPS_ses-20190509_T1w_acpc_dc_restore_aseg.nii.gz
base_data=/projects/NHP_processed/developmental_out/
out_base=/projects/NHP_processed/developmental_out/masks/anatomical/

parallel -j ${cores} ${scripts_path}/${code} {} ${Infant_templates} ${t1w_template_head} ${t1w_template_brain} ${t1w_template_aseg} ${base_data} ${out_base} ::: $(cat ${file1})




file1="/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions.txt"
#file1="/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions_2week_template.txt"
base_data=/projects/NHP_processed/developmental_out/
out_base=/projects/NHP_processed/developmental_out/masks/anatomical/
# # Get the number of subjects (lines) in the files (assuming both files have the same number of lines)
num_subjects=$(wc -l < "$file1")+1

# Loop through x number of subjects
i=0
for ((i=1; i<=num_subjects; i++)); do
  echo $i 

  # Read the ith line of file1 and file2
  line_file1=$(sed "${i}q;d" "$file1")
  echo ${line_file1}
  sesh=`echo $line_file1 | cut -d '/' -f 2-`
  sub=`echo $line_file1 | cut -d '/' -f 1`
  
  outpath=${out_base}/${sub}/${sesh}/
  #ls ${base_data}/${sub}/${sesh}/files
  #rm -rf ${base_data}/${sub}/${sesh}/files
  #rm ${outpath}/aseg_acpc.nii.gz
  #cp ${outpath}/ANTs_template2subHead_aseg_acpc_ml.nii.gz ${outpath}/aseg_acpc.nii.gz
  #ls -al ${outpath}/aseg_acpc.nii.gz
  ls -al ${base_data}/${sub}/${sesh}/files
  mkdir -p ${base_data}/temp_old_tries/${sub}/${sesh}/files_second_aseg_fix_first_mask
  mv ${base_data}/${sub}/${sesh}/files ${base_data}/temp_old_tries/${sub}/${sesh}/files_second_aseg_fix_first_mask/

done



#file1="/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions.txt"

## Updating Infant JLC folder with New Asegs
file1="/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions_2week_template.txt"

# # Get the number of subjects (lines) in the files (assuming both files have the same number of lines)
num_subjects=$(wc -l < "$file1")+1

# Loop through x number of subjects
i=0
for ((i=1; i<=num_subjects; i++)); do
  echo $i 

  # Read the ith line of file1 and file2
  line_file1=$(sed "${i}q;d" "$file1")
  echo ${line_file1}
  sesh=`echo $line_file1 | cut -d '/' -f 2-`
  sub=`echo $line_file1 | cut -d '/' -f 1`
  
  outpath=${out_base}/${sub}/${sesh}/
  #ls ${base_data}/${sub}/${sesh}/files
  #rm -rf ${base_data}/${sub}/${sesh}/files
  #rm ${outpath}/aseg_acpc.nii.gz
  JLC_T1=/home/bramirez/projects/ROI_sets/templates_all/InfantJointLabelCouncil/NKIDev_${sub}_${sesh}_T1w
  JLC_T2=/home/bramirez/projects/ROI_sets/templates_all/InfantJointLabelCouncil/NKIDev_${sub}_${sesh}_T2w

  cp ${outpath}/aseg_acpc.nii.gz ${JLC_T1}/Segmentation.nii.gz
  cp ${outpath}/aseg_acpc.nii.gz ${JLC_T2}/Segmentation.nii.gz
  cp ${outpath}/T1w_acpc_dc_restore_brain.nii.gz ${JLC_T1}/T1w_brain.nii.gz
  cp ${base_data}/${sub}/${sesh}/files/T1w/T2w_acpc_dc_restore_brain.nii.gz ${JLC_T2}/T1w_brain.nii.gz
  ls ${JLC_T1}
  ls ${JLC_T2}
  #cp ${outpath}/ANTs_template2subHead_aseg_acpc_ml.nii.gz ${outpath}/aseg_acpc.nii.gz
  #ls -al ${outpath}/aseg_acpc.nii.gz
  #mkdir -p ${base_data}/temp_old_tries/${sub}/${sesh}/files_first_aseg_fix
  #mv ${base_data}/${sub}/${sesh}/files ${base_data}/temp_old_tries/${sub}/${sesh}/files_first_aseg_fix/

done




file1="/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions.txt"
# # Get the number of subjects (lines) in the files (assuming both files have the same number of lines)
num_subjects=$(wc -l < "$file1")+1

# Loop through x number of subjects
i=0
for ((i=1; i<=num_subjects; i++)); do
  echo $i 

  # Read the ith line of file1 and file2
  line_file1=$(sed "${i}q;d" "$file1")
  echo ${line_file1}
  sesh=`echo $line_file1 | cut -d '/' -f 2-`
  sub=`echo $line_file1 | cut -d '/' -f 1`
  
  outpath=${out_base}/${sub}/${sesh}/
  ls ${base_data}/${sub}/${sesh}/files
  #rm -rf ${base_data}/${sub}/${sesh}/files
  #cp ${outpath}/ANTs_template2subHead_aseg_acpc_ml.nii.gz ${outpath}/aseg_acpc.nii.gz
  #mkdir -p ${base_data}/temp_old_tries/${sub}/${sesh}/files_first_aseg_fix
  #mv ${base_data}/${sub}/${sesh}/files ${base_data}/temp_old_tries/${sub}/${sesh}/files_first_aseg_fix/

done




# ## Biasfield correct input images
# file1=/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions_parallel.txt
# #file1="/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions_2week_template.txt"
# cores=2
# scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
# #code=NKIdev_03-01_fix_asegs_parallel.sh
# code=NKIdev_03-01_fix_asegs_just_apply_warps_parallel.sh

# Infant_templates=/home/bramirez/projects/ROI_sets/templates_all/Infant_templates
# t1w_template_head=sub-OOPS_ses-20190509_T1w_acpc_dc_restore.nii.gz
# t1w_template_brain=sub-OOPS_ses-20190509_T1w_acpc_dc_restore_brain.nii.gz
# t1w_template_aseg=sub-OOPS_ses-20190509_T1w_acpc_dc_restore_aseg.nii.gz
# base_data=/projects/NHP_processed/developmental_out/
# out_base=/projects/NHP_processed/developmental_out/masks/anatomical/

# parallel -j ${cores} ${scripts_path}/${code} {} ${Infant_templates} ${t1w_template_head} ${t1w_template_brain} ${t1w_template_aseg} ${base_data} ${out_base} ::: $(cat ${file1})



# file1=/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions_parallel.txt
# cores=3
# scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
# code=NKIdev_03-01_fix_asegs_parallel.sh
# Infant_templates=/home/bramirez/projects/ROI_sets/templates_all/Infant_templates
# t1w_template_head=${Infant_templates}/sub-OOPS_ses-20190509_T1w_acpc_dc_restore.nii.gz
# t1w_template_brain=${Infant_templates}/sub-OOPS_ses-20190509_T1w_acpc_dc_restore_brain.nii.gz
# t1w_template_aseg=${Infant_templates}/sub-OOPS_ses-20190509_T1w_acpc_dc_restore_aseg.nii.gz
# base_data=/projects/NHP_processed/developmental_out/
# out_base=/projects/NHP_processed/developmental_out/masks/anatomical/


# parallel -j ${cores} ${scripts_path}/learning_parallel_temp.sh {} ${Infant_templates} ${t1w_template_head} ${t1w_template_brain} ${t1w_template_aseg} ${base_data} ${out_base} ::: $(cat ${file1})


# cat ${file1}  | parallel -j ${cores} "${scripts_path}/${code}"

# parallel ./process_subjects.sh {} {1}.{2} ::: $(cat subjects.txt) ::: template1 template2 template3


# parallel -j ${cores} ${scripts_path}/learning_parallel_temp.sh {} ${Infant_templates} ${t1w_template_head} ${t1w_template_brain} ${t1w_template_aseg} ${base_data} $out_base{} ::: $(cat ${file1})

