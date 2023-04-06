fname=$1
cores=1
TemplateAge=4
#fname=/projects/NHP_processed/developmental_in_modified/sub-003/ses-035
fullsesh=`basename $fname`
#sesh=`echo $fullsesh | cut -c5-`
sesh=`echo $fullsesh | cut -d '-' -f 2-`
fullsub=`echo ${fname} | cut -d'/' -f $(($(echo ${fname} | awk -F'/' '{print NF}')-1))`
#subname=`echo $fullsub | cut -c5-`
subname=`echo $fullsub | cut -d '-' -f 2-`

INPUT=/projects/NHP_processed/developmental_in_modified
OUTPUT=/projects/NHP_processed/developmental_out
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
PreFreeSurfer=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/PreFreeSurfer
#MONKEY_PIPELINE=/ocean/projects/bio220020p/shared/PRIME-DE/DCAN/Monkey_pipeline/
fMRIVolume=/home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume
LICENSE=/home/bramirez/pipelines/freesurfer/license.txt
TEMPLATES=/home/bramirez/projects/ROI_sets/templates_all/
PARCELLATIONS=/home/bramirez/code/ROI_sets/Surface_schemes/Monkey/
sTEMPLATE_head=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_head.nii.gz 
sTEMPLATE_brain=/atlases/J_Macaque_${TemplateAge}mo_atlas_nACQ_194x252x160space_0.5mm_brain.nii.gz
#INFANT_TEMPLATE=/ocean/projects/bio220042p/shared/singularity_images/nhp-abcd-bids-pipeline_acpc_modified/opt/pipeline/global/templates
JLC=JointLabelCouncil_all
MASK=/projects/NHP_processed/developmental_out/masks/anatomical

#sub=$1
#ses=$(basename ${INPUT}/sub-${sub}/ses*)
#mask_file_name=${MASK}/sub-${sub}/${ses}/anat/*mask.nii.gz
#mask_file_name=$(basename $mask_file_name)
#readarray subs_below_3months < subj_list_sub_3months.txt
#cores=1





echo ${sesh}
if [ ! -d ${OUTPUT}/proc_times ]; then
  mkdir -p ${OUTPUT}/proc_times;
fi
echo "START" >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt
date >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt



echo "docker run -i --rm -v ${INPUT}:/input -v ${OUTPUT}:/output -v ${TEMPLATES}:/atlases -v ${PARCELLATIONS}:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v ${fMRIVolume}:/opt/pipeline/fMRIVolume -v ${MASK}:/masks -v /home/bramirez/pipelines/freesurfer/license.txt:/opt/freesurfer/license.txt dcanumn/nhp-abcd-bids-pipeline /input /output --participant-label ${subname} --session-id [ ${sesh} ] --ncpus ${cores} --study-template ${sTEMPLATE_head} ${sTEMPLATE_brain} --t1-brain-mask /masks/sub-${subname}/ses-${sesh}/T1w_average_pre_mask.nii.gz --multi-template-dir /atlases/${JLC} --hyper-normalization-method ROI_IPS --max-cortical-thickness 15 --freesurfer-license=/opt/freesurfer/license.txt " >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt

#sesh=20201015
#cores=1
#echo "DELETE THIS WHEN YOU HAVE ADDED THE PATHS TO THE NEWLY MADE ASEG FILES"
#docker run -i --rm -v ${INPUT}:/input -v ${OUTPUT}:/output -v ${TEMPLATES}:/atlases -v ${PARCELLATIONS}:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v ${fMRIVolume}:/opt/pipeline/fMRIVolume -v ${PreFreeSurfer}:/opt/pipeline/PreFreeSurfer -v ${MASK}:/masks -v /home/bramirez/pipelines/freesurfer/license.txt:/opt/freesurfer/license.txt dcanumn/nhp-abcd-bids-pipeline /input /output --participant-label ${subname} --session-id [ ${sesh} ] --ncpus ${cores} --study-template ${sTEMPLATE_head} ${sTEMPLATE_brain}--t1-brain-mask /masks/sub-${subname}/ses-${sesh}/T1w_average_pre_mask.nii.gz --multi-template-dir /atlases/${JLC} --hyper-normalization-method ROI_IPS --max-cortical-thickness 15 --freesurfer-license=/opt/freesurfer/license.txt --stage PreFreeSurfer

docker run -i --rm -v ${INPUT}:/input -v ${OUTPUT}:/output -v ${TEMPLATES}:/atlases -v ${PARCELLATIONS}:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v ${fMRIVolume}:/opt/pipeline/fMRIVolume -v ${PreFreeSurfer}:/opt/pipeline/PreFreeSurfer -v ${MASK}:/masks -v /home/bramirez/pipelines/freesurfer/license.txt:/opt/freesurfer/license.txt dcanumn/nhp-abcd-bids-pipeline /input /output --participant-label ${subname} --session-id [ ${sesh} ] --ncpus ${cores} --study-template ${sTEMPLATE_head} ${sTEMPLATE_brain} --t1-brain-mask /masks/sub-${subname}/ses-${sesh}/T1w_average_pre_mask.nii.gz --multi-template-dir /atlases/${JLC} --hyper-normalization-method ROI_IPS --max-cortical-thickness 15 --freesurfer-license=/opt/freesurfer/license.txt
#--print-commands-only

#--stage FreeSurfer
#--print-commands-only

echo "END" >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt

date >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt




# #dcanumn/nhp-abcd-bids-pipeline:v0.2.7
# docker run -i --rm -v ${INPUT}:/input -v ${OUTPUT}:/output -v /projects/NHP_processed/developmental_in:/projects/NHP_processed/developmental_in -v ${TEMPLATES}:/atlases -v ${PARCELLATIONS}:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v ${PreFreeSurfer}:/opt/pipeline/PreFreeSurfer -v ${fMRIVolume}:/opt/pipeline/fMRIVolume -v ${LICENSE}:/license dcanumn/nhp-abcd-bids-pipeline /input /output --participant-label ${subname} --session-id [ ${sesh} ] --ncpus ${cores} --multi-template-dir /atlases/${JLC} --hyper-normalization-method ROI_IPS --make-white-from-norm-t1 --single-pass-pial --max-cortical-thickness 15 --freesurfer-license=/license --print-commands-only

# docker run -i --rm -v ${INPUT}:/input -v ${OUTPUT}:/output -v ${SYMLINKIN}:${SYMLINKIN} -v /projects/NHP_processed/developmental_in:/projects/NHP_processed/developmental_in -v ${TEMPLATES}:/atlases -v ${PARCELLATIONS}:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v ${PreFreeSurfer}:/opt/pipeline/PreFreeSurfer -v ${fMRIVolume}:/opt/pipeline/fMRIVolume -v ${LICENSE}:/license dcanumn/nhp-abcd-bids-pipeline /input /output --participant-label ${subname} --session-id [ ${sesh} ] --ncpus ${cores} --multi-template-dir /atlases/${JLC} --hyper-normalization-method ROI_IPS --make-white-from-norm-t1 --single-pass-pial --max-cortical-thickness 15 --freesurfer-license=/license --print-commands-only



# ##
#docker run -it --rm -v ${INPUT}:/input -v ${OUTPUT}:/output -v ${TEMPLATES}:/atlases -v ${PARCELLATIONS}:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v ${fMRIVolume}:/opt/pipeline/fMRIVolume -v ${PreFreeSurfer}:/opt/pipeline/PreFreeSurfer -v ${MASK}:/masks -v /home/bramirez/pipelines/freesurfer/license.txt:/opt/freesurfer/license.txt  --entrypoint bash dcanumn/nhp-abcd-bids-pipeline
#dcanumn/nhp-abcd-bids-pipeline /input /output --participant-label ${subname} --session-id [ ${sesh} ] --ncpus ${cores} --t1-brain-mask /masks/sub-${subname}/ses-${sesh}/T1w_average_pre_mask.nii.gz --multi-template-dir /atlases/${JLC} --hyper-normalization-method ROI_IPS --max-cortical-thickness 15 --freesurfer-license=/opt/freesurfer/license.txt
# docker run -it --rm -v ${INPUT}:/input -v ${OUTPUT}:/output -v ${TEMPLATES}:/atlases -v ${PARCELLATIONS}:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v ${fMRIVolume}:/opt/pipeline/fMRIVolume -v ${LICENSE}:/license --entrypoint bash dcanumn/nhp-abcd-bids-pipeline

# sesh=$1
# cores=1
# subname=MILO
# echo ${sesh}

# echo "START" >> /projects/bramirez/data/dcanumn_bids_out/priors_usr_template/proc_times/${subname}_${sesh}.txt
# date >> /projects/bramirez/data/dcanumn_bids_out/priors_usr_template/proc_times/${subname}_${sesh}.txt



# echo "docker run -i --rm -v /projects/bramirez/data/monkey_bids_in:/input -v /projects/bramirez/data/dcanumn_bids_out/priors_usr_template:/output -v /home/bramirez/projects/ROI_sets/templates_all/:/atlases -v /home/bramirez/code/ROI_sets/Surface_schemes/Monkey/:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v /projects/bramirez/data/UNet_masks/regular_masks/yrk_masked/:/mask_priors -v /home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume:/opt/pipeline/fMRIVolume -v /home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/global/templates_custom:/opt/pipeline/global/templates -v /home/bramirez/pipelines/freesurfer/license.txt:/license dcanumn/nhp-abcd-bids-pipeline /input /output --participant-label ${subname} --session-id [ ${sesh} ] --ncpus ${cores} --t1-brain-mask /mask_priors/sub-${subname}/ses-${sesh}/anat/sub-${subname}_ses-${sesh}_T1w_pre_mask.nii.gz --study-template /atlases/J_Macaque_4mo_atlas_nACQ_194x252x160space_0.5mm_head.nii.gz /atlases/J_Macaque_4mo_atlas_nACQ_194x252x160space_0.5mm_brain.nii.gz --multi-template-dir /atlases/JointLabelCouncil_HFDLuteinOOPs --hyper-normalization-method ROI_IPS --make-white-from-norm-t1 --single-pass-pial --max-cortical-thickness 30 --freesurfer-license=/license" >> /projects/bramirez/data/dcanumn_bids_out/priors_usr_template/proc_times/${subname}_${sesh}.txt

# #sesh=20201015
# #cores=1
# #echo "DELETE THIS WHEN YOU HAVE ADDED THE PATHS TO THE NEWLY MADE ASEG FILES"
# docker run -i --rm -v /projects/bramirez/data/monkey_bids_in:/input -v /projects/bramirez/data/dcanumn_bids_out/priors_usr_template:/output -v /home/bramirez/projects/ROI_sets/templates_all/:/atlases -v /home/bramirez/code/ROI_sets/Surface_schemes/Monkey/:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v /projects/bramirez/data/UNet_masks/regular_masks/yrk_masked/:/mask_priors -v /home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume:/opt/pipeline/fMRIVolume -v /home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/global/templates_custom:/opt/pipeline/global/templates -v /home/bramirez/pipelines/freesurfer/license.txt:/license dcanumn/nhp-abcd-bids-pipeline /input /output --participant-label ${subname} --session-id [ ${sesh} ] --ncpus ${cores} --t1-brain-mask /mask_priors/sub-${subname}/ses-${sesh}/anat/sub-${subname}_ses-${sesh}_T1w_pre_mask.nii.gz --study-template /atlases/J_Macaque_4mo_atlas_nACQ_194x252x160space_0.5mm_head.nii.gz /atlases/J_Macaque_4mo_atlas_nACQ_194x252x160space_0.5mm_brain.nii.gz --multi-template-dir /atlases/JointLabelCouncil_HFDLuteinOOPs --hyper-normalization-method ROI_IPS --make-white-from-norm-t1 --single-pass-pial --max-cortical-thickness 30 --freesurfer-license=/license 
# #--stage FreeSurfer
# #--print-commands-only

# echo "END" >> /projects/bramirez/data/dcanumn_bids_out/priors_usr_template/proc_times/${subname}_${sesh}.txt

# date >> /projects/bramirez/data/dcanumn_bids_out/priors_usr_template/proc_times/${subname}_${sesh}.txt


# #docker run -i --rm -v /projects/bramirez/data/monkey_bids_in:/input -v /projects/bramirez/data/dcanumn_bids_out/run_w_prior_asegs:/output -v /home/bramirez/projects/ROI_sets/templates_all/:/atlases -v /home/bramirez/code/ROI_sets/Surface_schemes/Monkey/:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v /projects/bramirez/data/UNet_masks/regular_masks/monkey_bids_in/:/mask_priors -v /home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume:/opt/pipeline/fMRIVolume -v /home/bramirez/pipelines/freesurfer/license.txt:/license dcanumn/nhp-abcd-bids-pipeline /input /output --participant-label ${subname} --session-id [ ${sesh} ] --ncpus ${cores} --t1-brain-mask /mask_priors/sub-${subname}/ses-${sesh}/anat/sub-${subname}_ses-${sesh}_T1w_pre_mask.nii.gz --aseg /mask_priors/sub-${subname}/ses-${sesh}/anat/aseg_acpc.nii.gz --multi-template-dir /atlases/JointLabelCouncil_HFDLuteinOOPs --hyper-normalization-method ROI_IPS --make-white-from-norm-t1 --single-pass-pial --max-cortical-thickness 30 --freesurfer-license=/license 

# #docker run -i --rm -v /projects/bramirez/data/monkey_bids_in:/input -v /projects/bramirez/data/dcanumn_bids_out/run_w_prior_masks:/output -v /home/bramirez/projects/ROI_sets/templates_all/:/atlases -v /home/bramirez/code/ROI_sets/Surface_schemes/Monkey/:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v /projects/bramirez/data/UNet_masks/regular_masks/monkey_bids_in/:/mask_priors -v /home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume:/opt/pipeline/fMRIVolume -v /home/bramirez/pipelines/freesurfer/license.txt:/license dcanumn/nhp-abcd-bids-pipeline /input /output --participant-label ${subname} --session-id [ ${sesh} ] --ncpus ${cores} --t1-brain-mask /mask_priors/sub-${subname}/ses-${sesh}/anat/sub-${subname}_ses-${sesh}_T1w_pre_mask.nii.gz --multi-template-dir /atlases/JointLabelCouncil_HFDLutein${subname} --hyper-normalization-method ROI_IPS --make-white-from-norm-t1 --max-cortical-thickness 30 --freesurfer-license=/license 

# #docker run -it --rm -v /projects/bramirez/data/monkey_bids_in:/input -v /projects/bramirez/data/dcanumn_bids_out/run_w_prior_asegs:/output -v /home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume:/opt/pipeline/fMRIVolume -v /home/bramirez/projects/ROI_sets/templates_all/:/atlases -v /home/bramirez/code/ROI_sets/Surface_schemes/Monkey/:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v /projects/bramirez/data/UNet_masks/regular_masks/monkey_bids_in/:/mask_priors -v /home/bramirez/pipelines/freesurfer/license.txt:/license --entrypoint bash dcanumn/nhp-abcd-bids-pipeline 
# #docker run -it --rm -v /projects/bramirez/data/monkey_bids_in:/input -v /projects/bramirez/data/dcanumn_bids_out/:/output -v /home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume:/opt/pipeline/fMRIVolume -v /home/bramirez/projects/ROI_sets/templates_all/:/atlases -v /home/bramirez/code/ROI_sets/Surface_schemes/Monkey/:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v /projects/bramirez/data/UNet_masks/regular_masks/monkey_bids_in/:/mask_priors -v /home/bramirez/pipelines/freesurfer/license.txt:/license --entrypoint bash dcanumn/nhp-abcd-bids-pipeline 

# #docker run -it --rm -v /projects/bramirez/data/monkey_bids_in:/input -v /projects/bramirez/data/dcanumn_bids_out/priors_usr_template:/output -v /home/bramirez/projects/ROI_sets/templates_all/:/atlases -v /home/bramirez/code/ROI_sets/Surface_schemes/Monkey/:/opt/dcan-tools/dcan_bold_proc/templates/parcellations -v /projects/bramirez/data/UNet_masks/regular_masks/monkey_bids_in/:/mask_priors -v /home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/fMRIVolume:/opt/pipeline/fMRIVolume -v /home/bramirez/pipelines/dcan-macaque-pipeline-jsbr/global/templates_custom:/opt/pipeline/global/templates -v /home/bramirez/pipelines/freesurfer/license.txt:/license  --entrypoint bash dcanumn/nhp-abcd-bids-pipeline 
