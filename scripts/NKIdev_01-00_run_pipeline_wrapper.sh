
#https://linuxize.com/post/how-to-use-linux-screen/ 
#screen #starts a screen
# screen ctr ad #closes screen
# screen -r tab tab # opens screen again
# screen exit #closes screen for good
#screen -S session_name

#!/bin/bash

## Running infants with manual asegs and masks and single pass pial 
scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
code=NKIdev_01-04_pipeline_command_universal.sh
TemplateAge=4

file1=/home/bramirez/projects/InfantDevelopment/NKIdev/info/rerunning_infant_with_InfantJLC_subs_and_sessions.txt
pcores=3
dcores=1
INPUT=/projects/NHP_processed/developmental_in_modified
OUTPUT=/projects/NHP_processed/developmental_out
#if you want to use biasfieldcorrection use 
PreFreeSurfer=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/modified_stages/PreFreeSurfer
#else use 
#PreFreeSurfer=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/PreFreeSurfer
fMRIVolume=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume
LICENSE=/home/bramirez/pipelines/freesurfer/license.txt
TEMPLATES=/home/bramirez/projects/ROI_sets/templates_all/
PARCELLATIONS=/home/bramirez/code/ROI_sets/Surface_schemes/Monkey/
sTEMPLATE_head=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_head.nii.gz 
sTEMPLATE_brain=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_brain.nii.gz
JLC=InfantJointLabelCouncil
MASK=/projects/NHP_processed/developmental_out/masks/anatomical
T1wMask=1
T2wMask=1
ASEG=1
HYPER_NORM_METHOD=ROI_IPS
MAX_CORTICAL_THICKNESS=30
MAKE_WHITE_FROM_NORM_T1=1
SINGLE_PASS_PIAL=1
PrintCommandsOnly=1

parallel -j ${pcores} ${scripts_path}/${code} {} ${dcores} ${INPUT} ${OUTPUT} ${PreFreeSurfer} ${fMRIVolume} ${LICENSE} ${TEMPLATES} ${PARCELLATIONS} ${sTEMPLATE_head} ${sTEMPLATE_brain} ${JLC} ${MASK} ${T1wMask} ${T2wMask} ${ASEG} ${HYPER_NORM_METHOD} ${MAX_CORTICAL_THICKNESS} ${MAKE_WHITE_FROM_NORM_T1} ${SINGLE_PASS_PIAL} ${PrintCommandsOnly} ::: $(cat ${file1})


## Re running older sub 2 with fixed T2 issue, by inputting the T2w masks. 

scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
code=NKIdev_01-04_pipeline_command_universal.sh
TemplateAge=11

file1=/home/bramirez/projects/InfantDevelopment/NKIdev/info/subs_and_sessions_adult_sub2.txt
pcores=6
dcores=1
INPUT=/projects/NHP_processed/developmental_in_modified
OUTPUT=/projects/NHP_processed/developmental_out
PreFreeSurfer=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/PreFreeSurfer
fMRIVolume=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume
LICENSE=/home/bramirez/pipelines/freesurfer/license.txt
TEMPLATES=/home/bramirez/projects/ROI_sets/templates_all/
PARCELLATIONS=/home/bramirez/code/ROI_sets/Surface_schemes/Monkey/
sTEMPLATE_head=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_head.nii.gz 
sTEMPLATE_brain=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_brain.nii.gz
JLC=JointLabelCouncil_all
MASK=/projects/NHP_processed/developmental_out/masks/anatomical
T1wMask=1
T2wMask=1
ASEG=
HYPER_NORM_METHOD=ROI_IPS
MAX_CORTICAL_THICKNESS=30
MAKE_WHITE_FROM_NORM_T1=
SINGLE_PASS_PIAL=
PrintCommandsOnly=



parallel -j ${pcores} ${scripts_path}/${code} --fname {} --dcores ${dcores} --INPUT ${INPUT} --OUTPUT ${OUTPUT} --PreFreeSurfer ${PreFreeSurfer} --fMRIVolume ${fMRIVolume} --LICENSE ${LICENSE} --TEMPLATES ${TEMPLATES} --PARCELLATIONS ${PARCELLATIONS} --sTEMPLATE_head ${sTEMPLATE_head} --sTEMPLATE_brain ${sTEMPLATE_brain} --JLC ${JLC} --MASK ${MASK} --T1wMask ${T1wMask} --T2wMask ${T2wMask} --ASEG "${ASEG}" --HYPER_NORM_METHOD ${HYPER_NORM_METHOD} --MAX_CORTICAL_THICKNESS ${MAX_CORTICAL_THICKNESS} --MAKE_WHITE_FROM_NORM_T1 "${MAKE_WHITE_FROM_NORM_T1}" --SINGLE_PASS_PIAL "${SINGLE_PASS_PIAL}" --PrintCommandsOnly ${PrintCommandsOnly} ::: $(cat ${file1})

#fname=sub-003/ses-001
#${scripts_path}/${code} --fname ${fname} --dcores ${dcores} --INPUT ${INPUT} --OUTPUT ${OUTPUT} --PreFreeSurfer ${PreFreeSurfer} --fMRIVolume ${fMRIVolume} --LICENSE ${LICENSE} --TEMPLATES ${TEMPLATES} --PARCELLATIONS ${PARCELLATIONS} --sTEMPLATE_head ${sTEMPLATE_head} --sTEMPLATE_brain ${sTEMPLATE_brain} --JLC ${JLC} --MASK ${MASK} --T1wMask ${T1wMask} --T2wMask ${T2wMask} --ASEG "${ASEG}" --HYPER_NORM_METHOD ${HYPER_NORM_METHOD} --MAX_CORTICAL_THICKNESS ${MAX_CORTICAL_THICKNESS} --MAKE_WHITE_FROM_NORM_T1 "${MAKE_WHITE_FROM_NORM_T1}" --SINGLE_PASS_PIAL "${SINGLE_PASS_PIAL}" --PrintCommandsOnly ${PrintCommandsOnly}


scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
code=NKIdev_01-04_pipeline_command_universal.sh
TemplateAge=11

file1=/home/bramirez/projects/InfantDevelopment/NKIdev/info/subs_and_sessions_adult_sub2.txt
pcores=3
dcores=1
INPUT=/projects/NHP_processed/developmental_in_modified
OUTPUT=/projects/NHP_processed/developmental_out
PreFreeSurfer=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/PreFreeSurfer
fMRIVolume=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume
LICENSE=/home/bramirez/pipelines/freesurfer/license.txt
TEMPLATES=/home/bramirez/projects/ROI_sets/templates_all/
PARCELLATIONS=/home/bramirez/code/ROI_sets/Surface_schemes/Monkey/
sTEMPLATE_head=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_head.nii.gz 
sTEMPLATE_brain=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_brain.nii.gz
JLC=JointLabelCouncil_all
MASK=/projects/NHP_processed/developmental_out/masks/anatomical
T1wMask=1
T2wMask=1
ASEG=
HYPER_NORM_METHOD=ROI_IPS
MAX_CORTICAL_THICKNESS=30
MAKE_WHITE_FROM_NORM_T1=""
SINGLE_PASS_PIAL=""
PrintCommandsOnly=1

fname=sub-003/ses-001
${scripts_path}/${code} ${fname} ${dcores} ${INPUT} ${OUTPUT} ${PreFreeSurfer} ${fMRIVolume} ${LICENSE} ${TEMPLATES} ${PARCELLATIONS} ${sTEMPLATE_head} ${sTEMPLATE_brain} ${JLC} ${MASK} ${T1wMask} ${T2wMask} ${ASEG} ${HYPER_NORM_METHOD} ${MAX_CORTICAL_THICKNESS} ${MAKE_WHITE_FROM_NORM_T1} ${SINGLE_PASS_PIAL} ${PrintCommandsOnly}


scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
code=NKIdev_01-04_pipeline_command_universal.sh
TemplateAge=11

file1=/home/bramirez/projects/InfantDevelopment/NKIdev/info/subs_and_sessions_adult_sub2.txt
pcores=3
dcores=1
INPUT=/projects/NHP_processed/developmental_in_modified
OUTPUT=/projects/NHP_processed/developmental_out
PreFreeSurfer=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/PreFreeSurfer
fMRIVolume=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume
LICENSE=/home/bramirez/pipelines/freesurfer/license.txt
TEMPLATES=/home/bramirez/projects/ROI_sets/templates_all/
PARCELLATIONS=/home/bramirez/code/ROI_sets/Surface_schemes/Monkey/
sTEMPLATE_head=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_head.nii.gz 
sTEMPLATE_brain=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_brain.nii.gz
JLC=InfantJointLabelCouncil
MASK=/projects/NHP_processed/developmental_out/masks/anatomical
T1wMask=1
T2wMask=1
ASEG=
HYPER_NORM_METHOD=ROI_IPS
MAX_CORTICAL_THICKNESS=30
MAKE_WHITE_FROM_NORM_T1=""
SINGLE_PASS_PIAL=""
PrintCommandsOnly=1

fname=sub-003/ses-001
${scripts_path}/${code} ${fname} ${dcores} ${INPUT} ${OUTPUT} ${PreFreeSurfer} ${fMRIVolume} ${LICENSE} ${TEMPLATES} ${PARCELLATIONS} ${sTEMPLATE_head} ${sTEMPLATE_brain} ${JLC} ${MASK} ${T1wMask} ${T2wMask} ${ASEG} ${HYPER_NORM_METHOD} ${MAX_CORTICAL_THICKNESS} ${MAKE_WHITE_FROM_NORM_T1} ${SINGLE_PASS_PIAL} ${PrintCommandsOnly}

parallel -j ${pcores} ${scripts_path}/${code} {} ${dcores} ${INPUT} ${OUTPUT} ${PreFreeSurfer} ${fMRIVolume} ${LICENSE} ${TEMPLATES} ${PARCELLATIONS} ${sTEMPLATE_head} ${sTEMPLATE_brain} ${JLC} ${MASK} ${T1wMask} ${T2wMask} ${ASEG} ${HYPER_NORM_METHOD} ${MAX_CORTICAL_THICKNESS} ${MAKE_WHITE_FROM_NORM_T1} ${SINGLE_PASS_PIAL} ${PrintCommandsOnly} ::: $(cat ${file1})



scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
code=NKIdev_01-04_pipeline_command_universal.sh
TemplateAge=11

file1=/home/bramirez/projects/InfantDevelopment/NKIdev/info/subs_and_sessions_adult_sub2.txt
pcores=3
dcores=1
INPUT=/projects/NHP_processed/developmental_in_modified
OUTPUT=/projects/NHP_processed/developmental_out
PreFreeSurfer=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/PreFreeSurfer
fMRIVolume=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume
LICENSE=/home/bramirez/pipelines/freesurfer/license.txt
TEMPLATES=/home/bramirez/projects/ROI_sets/templates_all/
PARCELLATIONS=/home/bramirez/code/ROI_sets/Surface_schemes/Monkey/
sTEMPLATE_head=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_head.nii.gz 
sTEMPLATE_brain=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_brain.nii.gz
JLC=InfantJointLabelCouncil
MASK=/projects/NHP_processed/developmental_out/masks/anatomical
T1wMask=1
T2wMask=1
ASEG=""
HYPER_NORM_METHOD=ROI_IPS
MAX_CORTICAL_THICKNESS=30
MAKE_WHITE_FROM_NORM_T1=1
SINGLE_PASS_PIAL=1
PrintCommandsOnly=1

parallel -j ${pcores} ${scripts_path}/${code} {} ${dcores} ${INPUT} ${OUTPUT} ${PreFreeSurfer} ${fMRIVolume} ${LICENSE} ${TEMPLATES} ${PARCELLATIONS} ${sTEMPLATE_head} ${sTEMPLATE_brain} ${JLC} ${MASK} ${T1wMask} ${T2wMask} ${ASEG} ${HYPER_NORM_METHOD} ${MAX_CORTICAL_THICKNESS} ${MAKE_WHITE_FROM_NORM_T1} ${SINGLE_PASS_PIAL} ${PrintCommandsOnly} ::: $(cat ${file1})


#!/bin/bash


scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
code=NKIdev_03-01_fix_asegs_parallel.sh
TemplateAge=4

file1=/home/bramirez/projects/InfantDevelopment/NKIdev/info/rerunning_infant_with_InfantJLC_subs_and_sessions.txt
pcores=3
dcores=1
INPUT=/projects/NHP_processed/developmental_in_modified
OUTPUT=/projects/NHP_processed/developmental_out
PreFreeSurfer=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/PreFreeSurfer
fMRIVolume=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume
LICENSE=/home/bramirez/pipelines/freesurfer/license.txt
TEMPLATES=/home/bramirez/projects/ROI_sets/templates_all/
PARCELLATIONS=/home/bramirez/code/ROI_sets/Surface_schemes/Monkey/
sTEMPLATE_head=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_head.nii.gz 
sTEMPLATE_brain=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_brain.nii.gz
JLC=InfantJointLabelCouncil
MASK=/projects/NHP_processed/developmental_out/masks/anatomical
T1wMask=1
T2wMask=1
ASEG=1

parallel -j ${pcores} ${scripts_path}/${code} {} ${dcores} ${INPUT} ${OUTPUT} ${PreFreeSurfer} ${fMRIVolume} ${LICENSE} ${TEMPLATES} ${PARCELLATIONS} ${sTEMPLATE_head} ${sTEMPLATE_brain} ${JLC} ${MASK} ${T1wMask} ${T2wMask} ${ASEG} ::: $(cat ${file1})




I am trying to write a bash code (/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-00_run_pipeline_wrapper.sh) that has different inputs, and depending on those inputs it runs the subjects from 'file1' in parallel using 'dcores' number of cores. However, the code it runs (/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-04_pipeline_command_universal.sh) should take the inputs and depending on if the inputs exist, if will include them in the docker run command. If one of them is empty it will not include it. In my next message I will show you what I have so far for the wrapper. And then another messgae what I have for the code it should run. 

So, the NKIdev_01-00_run_pipeline_wrapper.sh wrapper will look something like this

#!/bin/bash


scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
code=NKIdev_03-01_fix_asegs_parallel.sh
TemplateAge=4

file1=/home/bramirez/projects/InfantDevelopment/NKIdev/info/rerunning_infant_with_InfantJLC_subs_and_sessions.txt
pcores=3
dcores=1
INPUT=/projects/NHP_processed/developmental_in_modified
OUTPUT=/projects/NHP_processed/developmental_out
PreFreeSurfer=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/PreFreeSurfer
fMRIVolume=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume
LICENSE=/home/bramirez/pipelines/freesurfer/license.txt
TEMPLATES=/home/bramirez/projects/ROI_sets/templates_all/
PARCELLATIONS=/home/bramirez/code/ROI_sets/Surface_schemes/Monkey/
sTEMPLATE_head=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_head.nii.gz 
sTEMPLATE_brain=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_brain.nii.gz
JLC=InfantJointLabelCouncil
MASK=/projects/NHP_processed/developmental_out/masks/anatomical
T1wMask=1
T2wMask=1
ASEG=1

parallel -j ${pcores} ${scripts_path}/${code} {} ${dcores} ${INPUT} ${OUTPUT} ${PreFreeSurfer} ${fMRIVolume} ${LICENSE} ${TEMPLATES} ${PARCELLATIONS} ${sTEMPLATE_head} ${sTEMPLATE_brain} ${JLC} ${MASK} ${T1wMask} ${T2wMask} ${ASEG} ::: $(cat ${file1})




#!/bin/bash
fname=$1
cores=$2
INPUT=$3
OUTPUT=$4
PreFreeSurfer=$5
fMRIVolume=$6
LICENSE=$7
TEMPLATES=$8
PARCELLATIONS=$9
sTEMPLATE_head=$10 
sTEMPLATE_brain=$11
JLC=$12
MASK=$13
T1wMask=$14
T2wMask=$15
ASEG=$16

#fname=sub-001/ses-003
#fname=/projects/NHP_processed/developmental_in_modified/sub-003/ses-035
fullsesh=`basename $fname`
#sesh=`echo $fullsesh | cut -c5-`
sesh=`echo $fullsesh | cut -d '-' -f 2-`
fullsub=`echo ${fname} | cut -d'/' -f $(($(echo ${fname} | awk -F'/' '{print NF}')-1))`
#subname=`echo $fullsub | cut -c5-`
subname=`echo $fullsub | cut -d '-' -f 2-`


docker run -i --rm -v ${INPUT}:/input -v ${OUTPUT}:/output -v ${TEMPLATES}:/atlases -v ${PARCELLATIONS}:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v ${fMRIVolume}:/opt/pipeline/fMRIVolume -v ${PreFreeSurfer}:/opt/pipeline/PreFreeSurfer -v ${MASK}:/masks -v /home/bramirez/pipelines/freesurfer/license.txt:/opt/freesurfer/license.txt dcanumn/nhp-abcd-bids-pipeline /input /output --participant-label ${subname} --session-id [ ${sesh} ] --ncpus ${cores} --t1-brain-mask /masks/sub-${subname}/ses-${sesh}/T1w_average_pre_mask.nii.gz --t2-brain-mask /masks/sub-${subname}/ses-${sesh}/T2w_average_pre_mask.nii.gz --aseg /masks/sub-${subname}/ses-${sesh}/aseg_acpc.nii.gz --multi-template-dir /atlases/${JLC} --hyper-normalization-method ROI_IPS --make-white-from-norm-t1 --single-pass-pial --max-cortical-thickness 30 --freesurfer-license=/opt/freesurfer/license.txt


--t1-brain-mask

parallel -j ${cores} ${scripts_path}/${code} {} ${Infant_templates} ${t1w_template_head} ${t1w_template_brain} ${t1w_template_aseg} ${base_data} ${out_base} ::: $(cat ${file1})


docker run -i --rm -v ${INPUT}:/input -v ${OUTPUT}:/output -v ${TEMPLATES}:/atlases -v ${PARCELLATIONS}:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v ${fMRIVolume}:/opt/pipeline/fMRIVolume -v ${PreFreeSurfer}:/opt/pipeline/PreFreeSurfer -v ${MASK}:/masks -v /home/bramirez/pipelines/freesurfer/license.txt:/opt/freesurfer/license.txt dcanumn/nhp-abcd-bids-pipeline /input /output --participant-label ${subname} --session-id [ ${sesh} ] --ncpus ${cores} --t1-brain-mask /masks/sub-${subname}/ses-${sesh}/T1w_average_pre_mask.nii.gz --t2-brain-mask /masks/sub-${subname}/ses-${sesh}/T2w_average_pre_mask.nii.gz --aseg /masks/sub-${subname}/ses-${sesh}/aseg_acpc.nii.gz --multi-template-dir /atlases/${JLC} --hyper-normalization-method ROI_IPS --make-white-from-norm-t1 --single-pass-pial --max-cortical-thickness 30 --freesurfer-license=/opt/freesurfer/license.txt


cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/rerunning_infant_with_InfantJLC_subs_and_sessions.txt | parallel -j 10 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-03_pipeline_command_third_pass_with_masks_and_asegs.sh'

#fname=sub-001/ses-003
fullsesh=`basename $fname`
#sesh=`echo $fullsesh | cut -c5-`
sesh=`echo $fullsesh | cut -d '-' -f 2-`
fullsub=`echo ${fname} | cut -d'/' -f $(($(echo ${fname} | awk -F'/' '{print NF}')-1))`
#subname=`echo $fullsub | cut -c5-`
subname=`echo $fullsub | cut -d '-' -f 2-`


#SYMLINKIN=/projects/NHP_processed/developmental_in/sub-${subname}/ses-${sesh}/func/
#SYMLINKOUT=/projects/NHP_processed/developmental_in_modified/sub-${subname}/ses-${sesh}/func/


# sesh=20210907
# subname=MILO
# INPUT=/projects/bramirez/data/monkey_bids_in
# OUTPUT=/projects/bramirez/data/dcanumn_bids_out
# SYMLINKIN=/projects/NHP_processed/developmental_in/sub-${subname}/ses-${sesh}/func/
# SYMLINKOUT=/projects/NHP_processed/developmental_in_modified/sub-${subname}/ses-${sesh}/func/

#SYMLINKBIND="-v /projects/NHP_processed/developmental_in/sub-${subname}/ses-${sesh}/func:/projects/NHP_processed/developmental_in_modified/sub-${subname}/ses-${sesh}/func"
#PIPELINE=/ocean/projects/bio220042p/shared/singularity_images/nhp-abcd-bids-pipeline_latest.sif


file1=/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions_parallel.txt
cores=8
scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
code=NKIdev_03-01_fix_asegs_parallel.sh
Infant_templates=/home/bramirez/projects/ROI_sets/templates_all/Infant_templates
t1w_template_head=sub-OOPS_ses-20190509_T1w_acpc_dc_restore.nii.gz
t1w_template_brain=sub-OOPS_ses-20190509_T1w_acpc_dc_restore_brain.nii.gz
t1w_template_aseg=sub-OOPS_ses-20190509_T1w_acpc_dc_restore_aseg.nii.gz
base_data=/projects/NHP_processed/developmental_out/
out_base=/projects/NHP_processed/developmental_out/masks/anatomical/

parallel -j ${cores} ${scripts_path}/${code} {} ${Infant_templates} ${t1w_template_head} ${t1w_template_brain} ${t1w_template_aseg} ${base_data} ${out_base} ::: $(cat ${file1})





#step 1, run initial part of pipeline to get T1w average
cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/all_sessions.txt  | parallel -j 10 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-01_pipeline_command_first_pass_sub-001.sh'

#the run UNet masking to get masks 
#/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_02_01_Unet_masking.sh 
/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_02_02_UNet_masking_qc.sh /home/bramirez/projects/InfantDevelopment/NKIdev/info/subs_and_sessions_temp.txt
python /home/bramirez/projects/InfantDevelopment/NKIdev/scripts/generate_anat_processed_QC_html.py /home/bramirez/projects/InfantDevelopment/NKIdev/info/sub-XX_ses-XX_list.txt /projects/NHP_processed/developmental_out/QC_images/anat_processed_QC_images -o /projects/NHP_processed/developmental_out/QC_images/anat_processed_QC_images/QC_images.html

/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/generate_anat_processed_QC_html.py
/home/bramirez/projects/InfantDevelopment/NKIdev/info/sub-XX_ses-XX_list.txt


#then rerun pipeline with correct masks 
#cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/all_sessions.txt  | parallel -j 12 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-02_pipeline_command_second_pass_with_masks.sh'
cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/all_sessions_temp.txt  | parallel -j 12 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-02_pipeline_command_second_pass_with_masks.sh'
#/home/bramirez/projects/InfantDevelopment/NKIdev/info/all_sessions.txt
/home/bramirez/projects/InfantDevelopment/NKIdev/info/all_sessions_testing.txt
cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/all_sessions_testing.txt  | parallel -j 2 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-01_pipeline_command_first_pass_sub-001.sh'

cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/failed_sessions.txt  | parallel -j 12 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-02_pipeline_command_second_pass_with_masks.sh'

cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/rerunning_infant_with_InfantJLC_subs_and_sessions.txt | parallel -j 15 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-02_pipeline_command_second_pass_with_masks.sh'


cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/rerunning_infant_with_InfantJLC_subs_and_sessions.txt | parallel -j 10 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-03_pipeline_command_third_pass_with_masks_and_asegs.sh'

/home/bramirez/projects/InfantDevelopment/NKIdev/info/rerunning_infant_with_InfantJLC_subs_and_sessions.txt
cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/all_sessions.txt  | parallel -j 10 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-01_pipeline_command_first_pass_sub-001.sh'
#chmod 777 /home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-01_pipeline_command_first_pass_sub-001.sh
#/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-00_run_pipeline_wrapper.sh

cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/failed_sessions.txt  | parallel -j 15 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-02_pipeline_command_second_pass_with_masks.sh'



cd /home/bramirez/projects/PRIME-DE/scripts
# setting up folders in home dir
cat /home/bramirez/projects/PRIME-DE/info/site-uwmadison_sublist_testing.txt  | parallel -j 10 './fakeT2_fix_json_inHomedir_command.sh'
#setting up folder in raw dir
cat /home/bramirez/projects/PRIME-DE/info/site-uwmadison_sublist_testing.txt  | parallel -j 10 './fakeT2_fix_json_command.sh'

cat /home/bramirez/projects/PRIME-DE/info/site-uwmadison_sublist_testing.txt  | parallel -j 16 './dcanumn_pipeline_command.sh'


cd /projects/bramirez/data/scripts
cat /projects/bramirez/data/info/OOPs_session_dates.txt | parallel -j 10 './dcanumn_pipeline_command_OOPs.sh'



cd /projects/bramirez/data/scripts
cat /projects/bramirez/data/info/OOPs_session_dates_input_aseg.txt | parallel -j 6 './dcanumn_pipeline_command_OOPs_manAseg.sh'
echo "done with input aseg" 

echo "starting with rest"



cd /projects/bramirez/data/scripts
sleep 24h
cat /projects/bramirez/data/info/OOPs_session_dates_no_aseg.txt | parallel -j 10 './dcanumn_pipeline_command_OOPs.sh'
echo "done with rest"

echo "done with rest again"



#Academic tradition requires you to cite works you base your article on.
#When using programs that use GNU Parallel to process data for publication
#please cite:

#  O. Tange (2011): GNU Parallel - The Command-Line Power Tool,
#  ;login: The USENIX Magazine, February 2011:42-47.

#This helps funding further development; AND IT WON'T COST YOU A CENT.
#If you pay 10000 EUR you should feel free to use GNU Parallel without citing.

#To silence this citation notice: run 'parallel --citation'.
sleep 5s
echo "done sleeping" 
echo "done sleeping2" 


cd /projects/bramirez/data/scripts
./dcanumn_pipeline_command_OOPs_manAseg.sh 20190509

cat /projects/bramirez/data/info/OOPs_session_dates_input_aseg.txt | parallel -j 6 './dcanumn_pipeline_command_OOPs_manAseg.sh'
echo "done with input aseg" 



bramirez@tank:/projects/bramirez/data/scripts$ ./dcanumn_pipeline_command_OOPs_manAsegT1T2masks.sh 20190509


cd /projects/bramirez/data/scripts
./dcanumn_pipeline_command_OOPs_manAsegT1T2masks_usrtemp.sh 20190509

cat /projects/bramirez/data/info/OOPs_session_dates_input_aseg.txt | parallel -j 5 './dcanumn_pipeline_command_OOPs_manAsegT1masks_usrtemp.sh'
echo "done with input aseg" 


cd /projects/bramirez/data/scripts
sleep 6h
cat /projects/bramirez/data/info/OOPs_session_dates_no_aseg.txt | parallel -j 10 './dcanumn_pipeline_command_OOPs_manT1masks_usrtemp.sh'
echo "done with input aseg" 
echo "done sleeping2" 

cd /projects/bramirez/data/scripts

subject=MILO

cat /projects/bramirez/data/info/${subject}_session_dates_complete.txt | parallel -j 8 './dcanumn_pipeline_command_MILO_usrtemp.sh'


cd /projects/bramirez/data/scripts

subject=PETRA

cat /projects/bramirez/data/info/${subject}_session_dates_complete.txt | parallel -j 8 './dcanumn_pipeline_command_PETRA_usrtemp.sh'




cd /projects/bramirez/data/scripts

subject=PETRA

cat /projects/bramirez/data/info/${subject}_session_dates_complete.txt | parallel -j 8 './dcanumn_pipeline_command_PETRA_manT1T2_usrtemp.sh'

cd /projects/bramirez/data/scripts

subject=MILO

cat /projects/bramirez/data/info/${subject}_session_dates_complete.txt | parallel -j 8 './dcanumn_pipeline_command_MILO_manT1T2_usrtemp.sh'


cd /projects/bramirez/data/scripts

subject=PETRA

cat /projects/bramirez/data/info/${subject}_session_dates_testing.txt | parallel -j 8 './dcanumn_pipeline_command_PETRA_manT1T2_usrtemp.sh'

cd /projects/bramirez/data/scripts

subject=PETRA

cat /projects/bramirez/data/info/${subject}_session_dates_testing2.txt | parallel -j 4 './dcanumn_pipeline_command_PETRA_manT1T2_pial_usrtemp.sh'

