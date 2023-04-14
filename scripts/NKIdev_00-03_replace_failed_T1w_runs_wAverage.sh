
## Making symlinks for denoising 
infopath=/home/bramirez/projects/InfantDevelopment/NKIdev/info
scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
data_in=/projects/NHP_processed/developmental_in_modified
base_data=/projects/NHP_processed/developmental_out/


#line=sub-001/ses-003

while read -r line
do
  echo ${line}
  sesh=`echo $line | cut -d '/' -f 2-`
  echo $sesh
  sub=`echo $line | cut -d '/' -f 1`
  echo $sub

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

