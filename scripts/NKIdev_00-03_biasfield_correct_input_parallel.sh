#!/bin/bash

line_file1=$1
base_data=$2
base_masks=$3
base_out=$4
line_file1=sub-001/ses-001
base_data=/projects/NHP_processed/developmental_in_modified/
base_masks=/projects/NHP_processed/developmental_out/masks/anatomical/
base_out=/projects/NHP_processed/developmental_in_bnbfc
current_date_time=$(date '+%Y-%m-%d_%H-%M-%S')
echo ${line_file1}
sesh=`echo $line_file1 | cut -d '/' -f 2-`
sub=`echo $line_file1 | cut -d '/' -f 1`

echo " " >> /home/bramirez/projects/InfantDevelopment/NKIdev/info/running_biasfield_parallel_log.txt
echo " New attempt on ${current_date_time} " >> /home/bramirez/projects/InfantDevelopment/NKIdev/info/running_biasfield_parallel_log.txt
echo " " >> /home/bramirez/projects/InfantDevelopment/NKIdev/info/running_biasfield_parallel_log.txt
echo "Processing subject: ${base_data}/${line_file1}/anat using this mask: ${base_masks} on ${current_date_time} " >> /home/bramirez/projects/InfantDevelopment/NKIdev/info/running_biasfield_parallel_log.txt



echo ${sesh}
if [ ! -d ${base_out}/${line_file1} ]; then
  mkdir -p ${base_out}/${line_file1};
fi
if [ ! -d ${base_out}/${line_file1}/func ]; then
  ln -s ${base_data}/${line_file1}/func ${base_out}/${line_file1}/func;
fi
if [ ! -d ${base_out}/${line_file1}/fmap ]; then
  ln -s ${base_data}/${line_file1}/fmap ${base_out}/${line_file1}/fmap;
fi
if [ ! -d ${base_out}/${line_file1}/anat ]; then
  cp -r ${base_data}/${line_file1}/anat ${base_out}/${line_file1}/anat;
fi


# Add your processing code here

 
# file1=/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions_parallel.txt
# i=1
# line_file1=$(sed "${i}q;d" "$file1")
# #file1="/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions.txt"
#line_file1=sub-001/ses-001
# scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
# Infant_templates=/home/bramirez/projects/ROI_sets/templates_all/Infant_templates
# t1w_template_head=${Infant_templates}/sub-OOPS_ses-20190509_T1w_acpc_dc_restore.nii.gz
# t1w_template_brain=${Infant_templates}/sub-OOPS_ses-20190509_T1w_acpc_dc_restore_brain.nii.gz
# t1w_template_aseg=${Infant_templates}/sub-OOPS_ses-20190509_T1w_acpc_dc_restore_aseg.nii.gz
# base_data=/projects/NHP_processed/developmental_out/
# out_base=/projects/NHP_processed/developmental_out/masks/anatomical/


echo ${line_file1}
sesh=`echo $line_file1 | cut -d '/' -f 2-`
sub=`echo $line_file1 | cut -d '/' -f 1`
#reference
t1w_sub_brain=${base_data}/${sub}/${sesh}/files/T1w/T1w_acpc_dc_restore_brain.nii.gz
t1w_sub_head=${base_data}/${sub}/${sesh}/files/T1w/T1w_acpc_dc_restore.nii.gz
#input to reg to subject

outpath=${out_base}/${sub}/${sesh}/

ls ${Infant_templates}/${t1w_template_head}
ls ${Infant_templates}/${t1w_template_brain}
ls ${Infant_templates}/${t1w_template_aseg}
ls ${t1w_sub_head}
ls ${t1w_sub_brain}
ls ${outpath}
#copying to masks folder for now, so we have a reference of what T1w was used for aseg, incase acpc alignment changed
cp ${t1w_sub_head} ${outpath}/T1w_acpc_dc_restore.nii.gz
cp ${t1w_sub_brain} ${outpath}/T1w_acpc_dc_restore_brain.nii.gz
flirt -dof 6 -in ${Infant_templates}/${t1w_template_brain} -ref ${t1w_sub_brain} -omat ${outpath}/temp_rot2sub_brain.mat -o ${outpath}/temp_rot2sub_brain.nii.gz
flirt -in ${Infant_templates}/${t1w_template_head} -ref ${t1w_sub_head} -o ${outpath}/temp_rot2sub_head.nii.gz -applyxfm -init ${outpath}/temp_rot2sub_brain.mat
flirt -in ${Infant_templates}/${t1w_template_aseg} -ref ${t1w_sub_brain} -o ${outpath}/temp_aseg_rot2sub_brain.nii.gz -applyxfm -init ${outpath}/temp_rot2sub_brain.mat -interp nearestneighbour
#Convert fsl .mat to Ants txt
c3d_affine_tool -ref ${t1w_sub_brain} -src ${Infant_templates}/${t1w_template_brain} ${outpath}/temp_rot2sub_brain.mat -fsl2ras -oitk ${outpath}/temp_rot2sub_brain_fsl2ants.txt

ANTS 3 -m  CC[${t1w_sub_head},${outpath}/temp_rot2sub_head.nii.gz,1,5] -t SyN[0.25] -r Gauss[3,0] -o ${outpath}/ANTSrotatlhead2subhead_ -i 50x60x30 --use-Histogram-Matching  --number-of-affine-iterations 10000x10000x10000x10000x10000 --MI-option 32x16000
#apply warp atlas -> sub_rot2atl
antsApplyTransforms -d 3 -i ${Infant_templates}/${t1w_template_aseg} -t ${outpath}/ANTSrotatlhead2subhead_Warp.nii.gz ${outpath}/ANTSrotatlhead2subhead_Affine.txt ${outpath}/temp_rot2sub_brain_fsl2ants.txt -r ${t1w_sub_head} -o ${outpath}/ANTs_template2subHead_aseg_acpc_ml.nii.gz -n MultiLabel[0.38,4]

antsApplyTransforms -d 3 -i ${Infant_templates}/${t1w_template_aseg} -t ${outpath}/ANTSrotatlhead2subhead_Warp.nii.gz ${outpath}/ANTSrotatlhead2subhead_Affine.txt ${outpath}/temp_rot2sub_brain_fsl2ants.txt -r ${t1w_sub_head} -o ${outpath}/ANTs_template2subHead_aseg_acpc_nn.nii.gz -n NearestNeighbor

## Doing FNIRT Warp
fnirt --in=${outpath}/temp_rot2sub_head.nii.gz --ref=${t1w_sub_head} --cout=${outpath}/FNIRT_template2subHead_warp_cout.nii.gz --iout=${outpath}/FNIRT_template2subHead_warp_iout.nii.gz --fout=${outpath}/FNIRT_template2subHead_warp_fout.nii.gz --jout=${outpath}/FNIRT_template2subHead_warp_jout.nii.gz --warpres=5,5,5
applywarp --ref=${t1w_sub_head} \
          --in=${outpath}/temp_aseg_rot2sub_brain.nii.gz \
          --warp=${outpath}/FNIRT_template2subHead_warp_cout.nii.gz \
          --out=${outpath}/FNIRT_rottemplate2subHead_aseg_acpc_nn_test.nii.gz \
          --interp=nn

fnirt --in=${t1w_template_head} \
      --ref=${t1w_sub_head} \
      --aff=${outpath}/temp_rot2sub_brain.mat \
      --cout=${outpath}/FNIRT_template2subHead_combined_warp_cout.nii.gz \
      --iout=${outpath}/FNIRT_template2subHead_combined_warp_iout.nii.gz \

applywarp --ref=${t1w_sub_head} \
          --in=${Infant_templates}/${t1w_template_aseg} \
          --warp=${outpath}/FNIRT_template2subHead_combined_warp_cout.nii.gz \
          --out=${outpath}/FNIRT_template2subHead_aseg_acpc_nn_test.nii.gz \
          --interp=nn



  ### SCRATCH BELOW


#registering OOPs infant asegs to early subject acpc brains, using for loop instead of parallel

# scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
# Infant_templates=/home/bramirez/projects/ROI_sets/templates_all/Infant_templates
# base_data=/projects/NHP_processed/developmental_out/
# out_base=/projects/NHP_processed/developmental_out/masks/anatomical/

# file1="/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions.txt"
# # Get the number of subjects (lines) in the files (assuming both files have the same number of lines)
# num_subjects=$(wc -l < "$file1")+1

# # Loop through x number of subjects
# i=0
# for ((i=1; i<=num_subjects; i++)); do
#   echo $i 

#   # Read the ith line of file1 and file2
#   line_file1=$(sed "${i}q;d" "$file1")
#   echo ${line_file1}
#   sesh=`echo $line_file1 | cut -d '/' -f 2-`
#   sub=`echo $line_file1 | cut -d '/' -f 1`
#   #reference
#   t1w_sub_brain=${base_data}/${sub}/${sesh}/files/T1w/T1w_acpc_dc_restore_brain.nii.gz
#   t1w_sub_head=${base_data}/${sub}/${sesh}/files/T1w/T1w_acpc_dc_restore.nii.gz
#   #input to reg to subject
#   t1w_template_head=${Infant_templates}/sub-OOPS_ses-20190509_T1w_acpc_dc_restore.nii.gz
#   t1w_template_brain=${Infant_templates}/sub-OOPS_ses-20190509_T1w_acpc_dc_restore_brain.nii.gz
#   t1w_template_aseg=${Infant_templates}/sub-OOPS_ses-20190509_T1w_acpc_dc_restore_aseg.nii.gz
#   outpath=${out_base}/${sub}/${sesh}/

#   ls ${Infant_templates}/${t1w_template_head}
#   ls ${Infant_templates}/${t1w_template_brain}
#   ls ${Infant_templates}/${t1w_template_aseg}
#   ls ${t1w_sub_head}
#   ls ${t1w_sub_brain}
#   ls ${outpath}
#   #copying to masks folder for now, so we have a reference of what T1w was used for aseg, incase acpc alignment changed
#   cp ${t1w_sub_head} ${outpath}/T1w_acpc_dc_restore.nii.gz
#   cp ${t1w_sub_brain} ${outpath}/T1w_acpc_dc_restore_brain.nii.gz
#   flirt -dof 6 -in ${Infant_templates}/${t1w_template_brain} -ref ${t1w_sub_brain} -omat ${outpath}/temp_rot2sub_brain.mat -o ${outpath}/temp_rot2sub_brain.nii.gz
#   flirt -in ${Infant_templates}/${t1w_template_head} -ref ${t1w_sub_head} -o ${outpath}/temp_rot2sub_head.nii.gz -applyxfm -init ${outpath}/temp_rot2sub_brain.mat
#   flirt -in ${Infant_templates}/${t1w_template_aseg} -ref ${t1w_sub_brain} -o ${outpath}/temp_aseg_rot2sub_brain.nii.gz -applyxfm -init ${outpath}/temp_rot2sub_brain.mat -interp nearestneighbour
#   #Convert fsl .mat to Ants txt
#   c3d_affine_tool -ref ${t1w_sub_brain} -src ${Infant_templates}/${t1w_template_brain} ${outpath}/temp_rot2sub_brain.mat -fsl2ras -oitk ${outpath}/temp_rot2sub_brain_fsl2ants.txt

#   ANTS 3 -m  CC[${t1w_sub_head},${outpath}/temp_rot2sub_head.nii.gz,1,5] -t SyN[0.25] -r Gauss[3,0] -o ${outpath}/ANTSrotatlhead2subhead_ -i 50x60x30 --use-Histogram-Matching  --number-of-affine-iterations 10000x10000x10000x10000x10000 --MI-option 32x16000
#   #apply warp atlas -> sub_rot2atl
#   antsApplyTransforms -d 3 -i ${Infant_templates}/${t1w_template_aseg} -t ${outpath}/ANTSrotatlhead2subhead_Warp.nii.gz ${outpath}/ANTSrotatlhead2subhead_Affine.txt ${outpath}/temp_rot2sub_brain_fsl2ants.txt -r ${t1w_sub_head} -o ${outpath}/ANTs_template2subHead_aseg_acpc_ml.nii.gz -n MultiLabel[0.38,4]
  
#   antsApplyTransforms -d 3 -i ${Infant_templates}/${t1w_template_aseg} -t ${outpath}/ANTSrotatlhead2subhead_Warp.nii.gz ${outpath}/ANTSrotatlhead2subhead_Affine.txt ${outpath}/temp_rot2sub_brain_fsl2ants.txt -r ${t1w_sub_head} -o ${outpath}/ANTs_template2subHead_aseg_acpc_nn.nii.gz -n NearestNeighbor

#   ## Doing FNIRT Warp
#   fnirt --in=${outpath}/temp_rot2sub_head.nii.gz --ref=${t1w_sub_head} --cout=${outpath}/FNIRT_template2subHead_warp_cout.nii.gz --iout=${outpath}/FNIRT_template2subHead_warp_iout.nii.gz --fout=${outpath}/FNIRT_template2subHead_warp_fout.nii.gz --jout=${outpath}/FNIRT_template2subHead_warp_jout.nii.gz --warpres=5,5,5

#   #applying fnirt warp later cuz I don't know if this command works and dont want it to crash. 
#   #applywarp --rel --interp=nn -i ${outpath}/temp_aseg_rot2sub_brain.nii.gz -r ${t1w_ref_head} -o ${outpath}/FNIRT_rottemplate2subHead_aseg_acpc_nn.nii.gz --interp nn
#   #applywarp --rel --interp=nn -i ${Infant_templates}/${t1w_template_aseg} -r ${t1w_ref_head} --warp=${outpath}/FNIRT_template2subHead_warp_cout.nii.gz --premat=${outpath}/temp_rot2sub_brain.mat -o ${outpath}/FNIRT_template2subHead_aseg_acpc_nn.nii.gz --interp nn 
  
# done

  

#   ## Initial linear register aseg from old tries, didn't work as well so went with flirt, fnirt ants registration above. 


# infopath=/home/bramirez/projects/InfantDevelopment/NKIdev/info
# scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
# data_in=/projects/NHP_processed/developmental_in_modified
# old_data=/projects/bramirez/data/dcanumn_bids_out/priors_usr_template/
# #sub-MILO/ses-20210907/files/T1w/T1w_acpc_dc_brain.nii.gz
# base_data=/projects/NHP_processed/developmental_out/
# #/projects/NHP_processed/developmental_out/masks/anatomical/sub-001/ses-001
# out_base=/projects/NHP_processed/developmental_out/masks/anatomic
# #!/bin/bash


# file1="/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions.txt"
# file2="/home/bramirez/projects/InfantDevelopment/NKIdev/info/Original_aseg_paths.txt"
# # Get the number of subjects (lines) in the files (assuming both files have the same number of lines)
# num_subjects=$(wc -l < "$file1")+1

# # Loop through x number of subjects
# i=0
# for ((i=1; i<=num_subjects; i++)); do
#   echo $i 

#   # Read the ith line of file1 and file2
#   line_file1=$(sed "${i}q;d" "$file1")
#   echo ${line_file1}
#   sesh=`echo $line_file1 | cut -d '/' -f 2-`
#   echo $sesh
#   sub=`echo $line_file1 | cut -d '/' -f 1`
#   echo $sub
#   line_file2=$(sed "${i}q;d" "$file2")

#   # Extract osub and osesh using grep and a regular expression
#   osub=$(echo "$line_file2" | grep -oP '(?<=/)(sub-[a-zA-Z0-9]+)(?=/)')
#   osesh=$(echo "$line_file2" | grep -oP '(?<=/)(ses-[a-zA-Z0-9]+)(?=/)')
#   # Print the extracted values
#   echo "osub: $osub"
#   echo "osesh: $osesh"

#   t1w_ref=${base_data}/${sub}/${sesh}/files/T1w/T1w_acpc_dc_brain.nii.gz
#   t1w_orig=${old_data}/${osub}/${osesh}/files/T1w/T1w_acpc_dc_brain.nii.gz
#   t1w_ref_head=${base_data}/${sub}/${sesh}/files/T1w/T1w_acpc_dc_restore.nii.gz
#   t1w_orig_head=${old_data}/${osub}/${osesh}/files/T1w/T1w_acpc_dc_restore.nii.gz

#   aseg_orig=${line_file2}/anat/stepwarp_aseg_ml.nii.gz
   
#   echo "Line $i from file1: $line_file1"
#   outpath=${out_base}/${sub}/${sesh}/
#   #flirt -dof 12 -in ${t1w_orig_head} -ref ${t1w_ref_head} -omat ${outpath}/orig2new_head.mat -o ${outpath}/T1w_acpc_dc_restore_orig2new.nii.gz
#   #applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref_head} --premat=${outpath}/orig2new_head.mat -o ${outpath}/aseg_acpc_head.nii.gz
  
#   flirt -dof 6 -in ${t1w_orig_head} -ref ${t1w_ref_head} -omat ${outpath}/orig2new_head_6.mat -o ${outpath}/T1w_acpc_dc_restore_orig2new_6.nii.gz
#   applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref_head} --premat=${outpath}/orig2new_head_6.mat -o ${outpath}/aseg_acpc_head_6.nii.gz

#   #flirt -dof 6 -in ${t1w_orig} -ref ${t1w_ref} -omat ${outpath}/orig2new.mat -o ${outpath}/T1w_acpc_dc_brain_orig2new.nii.gz
#   #applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref} --premat=${outpath}/orig2new.mat -o ${outpath}/aseg_acpc.nii.gz
#   flirt -dof 12 -in ${t1w_orig} -ref ${t1w_ref} -omat ${outpath}/orig2new_12.mat -o ${outpath}/T1w_acpc_dc_brain_orig2new_12.nii.gz
#   applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref} --premat=${outpath}/orig2new_12.mat -o ${outpath}/aseg_acpc_12.nii.gz
#   #echo "Line $i from file2: $line_file2"
# done


# # Done

# removing old tries from linear registration 
# rm -r /projects/NHP_processed/developmental_out/masks/anatomical/sub-*/ses-*/orig2new_head.mat
# rm -r /projects/NHP_processed/developmental_out/masks/anatomical/sub-*/ses-*/T1w_acpc_dc_restore_orig2new.nii.gz
# rm -r /projects/NHP_processed/developmental_out/masks/anatomical/sub-*/ses-*/aseg_acpc_head.nii.gz
# rm -r /projects/NHP_processed/developmental_out/masks/anatomical/sub-*/ses-*/orig2new.mat
# rm -r /projects/NHP_processed/developmental_out/masks/anatomical/sub-*/ses-*/T1w_acpc_dc_brain_orig2new.nii.gz
# rm -r /projects/NHP_processed/developmental_out/masks/anatomical/sub-*/ses-*/aseg_acpc.nii.gz
# rm -r /projects/NHP_processed/developmental_out/masks/anatomical/sub-*/ses-*/orig2new_head_6.mat
# rm -r /projects/NHP_processed/developmental_out/masks/anatomical/sub-*/ses-*/T1w_acpc_dc_restore_orig2new_6.nii.gz
# rm -r /projects/NHP_processed/developmental_out/masks/anatomical/sub-*/ses-*/aseg_acpc_head_6.nii.gz
# rm -r /projects/NHP_processed/developmental_out/masks/anatomical/sub-*/ses-*/orig2new_12.mat
# rm -r /projects/NHP_processed/developmental_out/masks/anatomical/sub-*/ses-*/T1w_acpc_dc_brain_orig2new_12.nii.gz
# rm -r /projects/NHP_processed/developmental_out/masks/anatomical/sub-*/ses-*/aseg_acpc_12.nii.gz

  
#   antsApplyTransforms -d 3 -i ${atl_brain}.nii.gz -t atl2T1rotWarp.nii.gz atl2T1rotAffine.txt -r ${sub}_rot2atl.nii.gz -o atl2T1rot_deforemdImage.nii.gz

#   applywarp --rel --interp=sinc -i ${Infant_templates}/${t1w_template_aseg} -r ${t1w_ref_head} --premat=${outpath}/orig2new_head_6.mat -o ${outpath}/aseg_acpc_head_6.nii.gz


#   t1w_orig=${old_data}/${osub}/${osesh}/files/T1w/T1w_acpc_dc_brain.nii.gz
#   t1w_ref_head=${base_data}/${sub}/${sesh}/files/T1w/T1w_acpc_dc_restore.nii.gz
#   t1w_orig_head=${old_data}/${osub}/${osesh}/files/T1w/T1w_acpc_dc_restore.nii.gz

#   aseg_orig=${line_file2}/anat/stepwarp_aseg_ml.nii.gz

#   echo "Line $i from file1: $line_file1"
#   #flirt -dof 12 -in ${t1w_orig_head} -ref ${t1w_ref_head} -omat ${outpath}/orig2new_head.mat -o ${outpath}/T1w_acpc_dc_restore_orig2new.nii.gz
#   #applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref_head} --premat=${outpath}/orig2new_head.mat -o ${outpath}/aseg_acpc_head.nii.gz
  
#   flirt -dof 6 -in ${t1w_orig_head} -ref ${t1w_ref_head} -omat ${outpath}/orig2new_head_6.mat -o ${outpath}/T1w_acpc_dc_restore_orig2new_6.nii.gz
#   applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref_head} --premat=${outpath}/orig2new_head_6.mat -o ${outpath}/aseg_acpc_head_6.nii.gz

#   #flirt -dof 6 -in ${t1w_orig} -ref ${t1w_ref} -omat ${outpath}/orig2new.mat -o ${outpath}/T1w_acpc_dc_brain_orig2new.nii.gz
#   #applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref} --premat=${outpath}/orig2new.mat -o ${outpath}/aseg_acpc.nii.gz
#   flirt -dof 12 -in ${t1w_orig} -ref ${t1w_ref} -omat ${outpath}/orig2new_12.mat -o ${outpath}/T1w_acpc_dc_brain_orig2new_12.nii.gz
#   applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref} --premat=${outpath}/orig2new_12.mat -o ${outpath}/aseg_acpc_12.nii.gz
#   #echo "Line $i from file2: $line_file2"
# done
# #make a list of T2w things you want to register to. 


# Registering OOPs to Emory 
# OOPsT1w_head=
# ## Registering good OOPs to MILO and PETRA

# file1="/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions.txt"
# file2="/home/bramirez/projects/InfantDevelopment/NKIdev/info/Original_aseg_paths.txt"
# # Get the number of subjects (lines) in the files (assuming both files have the same number of lines)
# num_subjects=$(wc -l < "$file1")+1

# # Loop through x number of subjects
# i=0
# for ((i=1; i<=num_subjects; i++)); do
#   echo $i 

#   # Read the ith line of file1 and file2
#   line_file1=$(sed "${i}q;d" "$file1")
#   echo ${line_file1}
#   sesh=`echo $line_file1 | cut -d '/' -f 2-`
#   echo $sesh
#   sub=`echo $line_file1 | cut -d '/' -f 1`
#   echo $sub
#   line_file2=$(sed "${i}q;d" "$file2")

#   # Extract osub and osesh using grep and a regular expression
#   osub=$(echo "$line_file2" | grep -oP '(?<=/)(sub-[a-zA-Z0-9]+)(?=/)')
#   osesh=$(echo "$line_file2" | grep -oP '(?<=/)(ses-[a-zA-Z0-9]+)(?=/)')
#   # Print the extracted values
#   echo "osub: $osub"
#   echo "osesh: $osesh"

#   t1w_ref=${base_data}/${sub}/${sesh}/files/T1w/T1w_acpc_dc_brain.nii.gz
#   t1w_orig=${old_data}/${osub}/${osesh}/files/T1w/T1w_acpc_dc_brain.nii.gz
#   t1w_ref_head=${base_data}/${sub}/${sesh}/files/T1w/T1w_acpc_dc_restore.nii.gz
#   t1w_orig_head=${old_data}/${osub}/${osesh}/files/T1w/T1w_acpc_dc_restore.nii.gz

#   aseg_orig=${line_file2}/anat/stepwarp_aseg_ml.nii.gz

#   echo "Line $i from file1: $line_file1"
#   outpath=${out_base}/${sub}/${sesh}/
#   #flirt -dof 12 -in ${t1w_orig_head} -ref ${t1w_ref_head} -omat ${outpath}/orig2new_head.mat -o ${outpath}/T1w_acpc_dc_restore_orig2new.nii.gz
#   #applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref_head} --premat=${outpath}/orig2new_head.mat -o ${outpath}/aseg_acpc_head.nii.gz
  
#   flirt -dof 6 -in ${t1w_orig_head} -ref ${t1w_ref_head} -omat ${outpath}/orig2new_head_6.mat -o ${outpath}/T1w_acpc_dc_restore_orig2new_6.nii.gz
#   applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref_head} --premat=${outpath}/orig2new_head_6.mat -o ${outpath}/aseg_acpc_head_6.nii.gz

#   #flirt -dof 6 -in ${t1w_orig} -ref ${t1w_ref} -omat ${outpath}/orig2new.mat -o ${outpath}/T1w_acpc_dc_brain_orig2new.nii.gz
#   #applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref} --premat=${outpath}/orig2new.mat -o ${outpath}/aseg_acpc.nii.gz
#   flirt -dof 12 -in ${t1w_orig} -ref ${t1w_ref} -omat ${outpath}/orig2new_12.mat -o ${outpath}/T1w_acpc_dc_brain_orig2new_12.nii.gz
#   applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref} --premat=${outpath}/orig2new_12.mat -o ${outpath}/aseg_acpc_12.nii.gz
#   #echo "Line $i from file2: $line_file2"
# done




# ## non linear warp 

# #flirt -dof 6 -in ${t2w_brain} -ref ${t1w_brain} -omat ${outpath}/T2brain2T1wbrain.mat -o ${outpath}/tmp.nii.gz
# #applywarp --rel --interp=nn -i ${t2w_mask} -r ${t1w_brain} --premat=${outpath}/T2brain2T1wbrain.mat -o ${outpath}/${t2w_mask}
# #applywarp --rel --interp=sinc -i ${t2w_head} -r ${t1w_head} --premat=${outpath}/T2brain2T1wbrain.mat -o ${outpath}/${t2w_head}
# ## if sinc doesn't work, try spline for the head. 

# while read -r line
# do
#   echo ${line}
#   sesh=`echo $line | cut -d '/' -f 2-`
#   echo $sesh
#   sub=`echo $line | cut -d '/' -f 1`
#   echo $sub
#   Osesh=`echo $orig_line | cut -d '/' -f 2-`
#   echo $Osesh
#   Osub=`echo $orig_line | cut -d '/' -f 1`
#   echo $Osub

#   t1w_ref=${base_data}/${line}/files/T1w/T1w_acpc_dc_brain.nii.gz
#   t1w_orig=${old_data}/${orig_line}/files/T1w/T1w_acpc_dc_brain.nii.gz
#   aseg_orig=${old_data}/${orig_line}/files/T1w/aseg_acpc.nii.gz
# outpath=/home/bramirez/projects/InfantDevelopment/NKIdev/files/tmp_testing
# flirt -dof 6 -in ${subject}_b.nii.gz -ref $reference_image -o ${subject}_b_rot2ref.nii.gz -omat ${subject}_b_rot2ref.mat
#   flirt -dof 6 -in ${t1w_orig} -ref ${t1w_ref} -omat ${outpath}/orig2new.mat -o ${outpath}/orig2new.nii.gz
#   applywarp --rel --interp=nn -i ${aseg_orig} -r ${t1w_ref} --premat=${outpath}/orig2new.mat -o ${outpath}/aseg_orig2new2.nii.gz

#   mv ${data_in}/${line}/anat/${sub}_${sesh}_run-1_T1w.json ${data_in}/${line}/anat/temp.json
#   rm -rf ${data_in}/${line}/anat/${sub}_${sesh}_*_T1w.*
#   cp -r ${base_data}/${line}/files/masks/T1w_average.nii.gz ${data_in}/${line}/anat/${sub}_${sesh}_run-1_T1w.nii.gz
#   mv ${data_in}/${line}/anat/temp.json ${data_in}/${line}/anat/${sub}_${sesh}_run-1_T1w.json
  
# done < /home/bramirez/projects/InfantDevelopment/NKIdev/info/failed_sessions_subs_and_sessions.txt


# # ## Making symlinks for denoising 
# # infopath=/home/bramirez/projects/InfantDevelopment/NKIdev/info
# # scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
# # data_in=/projects/NHP_processed/developmental_in_modified
# # base_data=/projects/NHP_processed/developmental_out/


# # #line=sub-001/ses-003

# # while read -r line
# # do
# #   echo ${line}
# #   sesh=`echo $line | cut -d '/' -f 2-`
# #   echo $sesh
# #   sub=`echo $line | cut -d '/' -f 1`
# #   echo $sub

  
# #   rm -rf ${base_data}/${line}/files/T1w
# #   rm -rf ${base_data}/${line}/files/T2w
# #   rm -rf ${base_data}/${line}/files/MNINonLinear

  
# # done < /home/bramirez/projects/InfantDevelopment/NKIdev/info/failed_sessions_subs_and_sessions.txt

