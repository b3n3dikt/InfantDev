
## Making symlinks for denoising 
infopath=/home/bramirez/projects/InfantDevelopment/NKIdev/info
scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
data_in=/projects/NHP_processed/developmental_in_modified
base_data=/projects/NHP_processed/developmental_out/


#line=sub-001/ses-003
TXw=T2w
while read -r line
do
  echo ${line}
  sesh=`echo $line | cut -d '/' -f 2-`
  echo $sesh
  sub=`echo $line | cut -d '/' -f 1`
  echo $sub

  mv ${data_in}/${line}/anat/${sub}_${sesh}_run-1_${TXw}.json ${data_in}/${line}/anat/temp.json
  rm -rf ${data_in}/${line}/anat/${sub}_${sesh}_*_${TXw}.*
  cp -r ${base_data}/${line}/files/masks/${TXw}_average.nii.gz ${data_in}/${line}/anat/${sub}_${sesh}_run-1_${TXw}.nii.gz
  mv ${data_in}/${line}/anat/temp.json ${data_in}/${line}/anat/${sub}_${sesh}_run-1_${TXw}.json
  
done < /home/bramirez/projects/InfantDevelopment/NKIdev/info/failed_sessions_subs_and_sessions.txt



## Making symlinks for denoising 
infopath=/home/bramirez/projects/InfantDevelopment/NKIdev/info
scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
data_in=/projects/NHP_processed/developmental_in_modified
base_data=/projects/NHP_processed/developmental_out/


#line=sub-001/ses-003
TXw=T2w
while read -r line
do
  echo ${line}
  sesh=`echo $line | cut -d '/' -f 2-`
  echo $sesh
  sub=`echo $line | cut -d '/' -f 1`
  echo $sub
  cp -r ${base_data}/${line}/files/masks/${TXw}_brain_mask.nii.gz ${base_data}/masks/anatomical/${line}/${TXw}_average_pre_mask.nii.gz
  
done < /home/bramirez/projects/InfantDevelopment/NKIdev/info/subs_and_sessions.txt
#

#/home/bramirez/projects/InfantDevelopment/NKIdev/info/subs_and_sessions.txt
#ls /projects/NHP_processed/developmental_out/sub-003/ses-0*/files/masks/T2w_brain_mask.nii.gz |wc
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

