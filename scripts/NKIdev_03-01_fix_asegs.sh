
## Making symlinks for denoising 
infopath=/home/bramirez/projects/InfantDevelopment/NKIdev/info
scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
data_in=/projects/NHP_processed/developmental_in_modified
old_data=/projects/bramirez/data/dcanumn_bids_out/priors_usr_template/
#sub-MILO/ses-20210907/files/T1w/T1w_acpc_dc_brain.nii.gz
base_data=/projects/NHP_processed/developmental_out/
#/projects/NHP_processed/developmental_out/masks/anatomical/sub-001/ses-001
out_base=/projects/NHP_processed/developmental_out/masks/anatomical/
#line=sub-001/ses-003
#orig_line=sub-MILO/ses-20210907




#!/bin/bash


file1="/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions.txt"
file2="/home/bramirez/projects/InfantDevelopment/NKIdev/info/Original_aseg_paths.txt"
# Get the number of subjects (lines) in the files (assuming both files have the same number of lines)
num_subjects=$(wc -l < "$file1")+1

# Loop through x number of subjects
i=0
for ((i=1; i<=num_subjects; i++)); do
  echo $i 

  # Read the ith line of file1 and file2
  line_file1=$(sed "${i}q;d" "$file1")
  echo ${line_file1}
  sesh=`echo $line_file1 | cut -d '/' -f 2-`
  echo $sesh
  sub=`echo $line_file1 | cut -d '/' -f 1`
  echo $sub
  line_file2=$(sed "${i}q;d" "$file2")

  # Extract osub and osesh using grep and a regular expression
  osub=$(echo "$line_file2" | grep -oP '(?<=/)(sub-[a-zA-Z0-9]+)(?=/)')
  osesh=$(echo "$line_file2" | grep -oP '(?<=/)(ses-[a-zA-Z0-9]+)(?=/)')
  # Print the extracted values
  echo "osub: $osub"
  echo "osesh: $osesh"

  t1w_ref=${base_data}/${sub}/${sesh}/files/T1w/T1w_acpc_dc_brain.nii.gz
  t1w_orig=${old_data}/${osub}/${osesh}/files/T1w/T1w_acpc_dc_brain.nii.gz
  
  aseg_orig=${line_file2}/anat/stepwarp_aseg_ml.nii.gz

  echo "Line $i from file1: $line_file1"
  outpath=${out_base}/${sub}/${sesh}/
  #flirt -dof 6 -in ${subject}_b.nii.gz -ref $reference_image -o ${subject}_b_rot2ref.nii.gz -omat ${subject}_b_rot2ref.mat
  flirt -dof 6 -in ${t1w_orig} -ref ${t1w_ref} -omat ${outpath}/orig2new.mat -o ${outpath}/T1w_acpc_dc_brain_orig2new.nii.gz
  applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref} --premat=${outpath}/orig2new.mat -o ${outpath}/aseg_acpc.nii.gz
  #echo "Line $i from file2: $line_file2"
done


while read -r line
do
  echo ${line}
  sesh=`echo $line | cut -d '/' -f 2-`
  echo $sesh
  sub=`echo $line | cut -d '/' -f 1`
  echo $sub
  Osesh=`echo $orig_line | cut -d '/' -f 2-`
  echo $Osesh
  Osub=`echo $orig_line | cut -d '/' -f 1`
  echo $Osub

  t1w_ref=${base_data}/${line}/files/T1w/T1w_acpc_dc_brain.nii.gz
  t1w_orig=${old_data}/${orig_line}/files/T1w/T1w_acpc_dc_brain.nii.gz
  aseg_orig=${old_data}/${orig_line}/files/T1w/aseg_acpc.nii.gz
outpath=/home/bramirez/projects/InfantDevelopment/NKIdev/files/tmp_testing
flirt -dof 6 -in ${subject}_b.nii.gz -ref $reference_image -o ${subject}_b_rot2ref.nii.gz -omat ${subject}_b_rot2ref.mat
  flirt -dof 6 -in ${t1w_orig} -ref ${t1w_ref} -omat ${outpath}/orig2new.mat -o ${outpath}/orig2new.nii.gz
  applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref} --premat=${outpath}/orig2new.mat -o ${outpath}/aseg_orig2new2.nii.gz

  mv ${data_in}/${line}/anat/${sub}_${sesh}_run-1_T1w.json ${data_in}/${line}/anat/temp.json
  rm -rf ${data_in}/${line}/anat/${sub}_${sesh}_*_T1w.*
  cp -r ${base_data}/${line}/files/masks/T1w_average.nii.gz ${data_in}/${line}/anat/${sub}_${sesh}_run-1_T1w.nii.gz
  mv ${data_in}/${line}/anat/temp.json ${data_in}/${line}/anat/${sub}_${sesh}_run-1_T1w.json
  
done < /home/bramirez/projects/InfantDevelopment/NKIdev/info/failed_sessions_subs_and_sessions.txt


# ## Making symlinks for denoising 
# infopath=/home/bramirez/projects/InfantDevelopment/NKIdev/info
# scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
# data_in=/projects/NHP_processed/developmental_in_modified
# base_data=/projects/NHP_processed/developmental_out/


# #line=sub-001/ses-003

# while read -r line
# do
#   echo ${line}
#   sesh=`echo $line | cut -d '/' -f 2-`
#   echo $sesh
#   sub=`echo $line | cut -d '/' -f 1`
#   echo $sub

  
#   rm -rf ${base_data}/${line}/files/T1w
#   rm -rf ${base_data}/${line}/files/T2w
#   rm -rf ${base_data}/${line}/files/MNINonLinear

  
# done < /home/bramirez/projects/InfantDevelopment/NKIdev/info/failed_sessions_subs_and_sessions.txt

