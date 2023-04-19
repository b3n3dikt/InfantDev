#!/bin/bash

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --fname) fname="$2"; shift; shift ;;
    --dcores) cores="$2"; shift; shift ;;
    --INPUT) INPUT="$2"; shift; shift ;;
    --OUTPUT) OUTPUT="$2"; shift; shift ;;
    --PreFreeSurfer) PreFreeSurfer="$2"; shift; shift ;;
    --fMRIVolume) fMRIVolume="$2"; shift; shift ;;
    --LICENSE) LICENSE="$2"; shift; shift ;;
    --TEMPLATES) TEMPLATES="$2"; shift; shift ;;
    --PARCELLATIONS) PARCELLATIONS="$2"; shift; shift ;;
    --sTEMPLATE_head) sTEMPLATE_head="$2"; shift; shift ;;
    --sTEMPLATE_brain) sTEMPLATE_brain="$2"; shift; shift ;;
    --JLC) JLC="$2"; shift; shift ;;
    --MASK) MASK="$2"; shift; shift ;;
    --T1wMask) T1wMask="$2"; shift; shift ;;
    --T2wMask) T2wMask="$2"; shift; shift ;;
    --ASEG) ASEG="$2"; shift; shift ;;
    --HYPER_NORM_METHOD) HYPER_NORM_METHOD="$2"; shift; shift ;;
    --MAX_CORTICAL_THICKNESS) MAX_CORTICAL_THICKNESS="$2"; shift; shift ;;
    --MAKE_WHITE_FROM_NORM_T1) MAKE_WHITE_FROM_NORM_T1="$2"; shift; shift ;;
    --SINGLE_PASS_PIAL) SINGLE_PASS_PIAL="$2"; shift; shift ;;
    --PrintCommandsOnly) PrintCommandsOnly="$2"; shift; shift ;;
    *) echo "Unknown option: $key"; shift ;;
  esac
done


# #!/bin/bash
# fname=$1
# cores=$2
# INPUT=$3
# OUTPUT=$4
# PreFreeSurfer=$5
# fMRIVolume=$6
# LICENSE=$7
# TEMPLATES=$8
# PARCELLATIONS=$9
# sTEMPLATE_head=${10}
# sTEMPLATE_brain=${11}
# JLC=${12}
# MASK=${13}
# T1wMask=${14}
# T2wMask=${15}
# ASEG=${16}
# HYPER_NORM_METHOD=${17}
# MAX_CORTICAL_THICKNESS=${18}
# MAKE_WHITE_FROM_NORM_T1=${19}
# SINGLE_PASS_PIAL=${20}
# PrintCommandsOnly=${21}


fullsesh=`basename $fname`
sesh=`echo $fullsesh | cut -d '-' -f 2-`
fullsub=`echo ${fname} | cut -d'/' -f $(($(echo ${fname} | awk -F'/' '{print NF}')-1))`
subname=`echo $fullsub | cut -d '-' -f 2-`


cmd="docker run -i --rm"

if [ -n "${PreFreeSurfer}" ]; then
  cmd+=" -v ${PreFreeSurfer}:/opt/pipeline/PreFreeSurfer"
fi

if [ -n "${fMRIVolume}" ]; then
  cmd+=" -v ${fMRIVolume}:/opt/pipeline/fMRIVolume"
fi

cmd+=" -v ${INPUT}:/input -v ${OUTPUT}:/output -v ${LICENSE}:/opt/freesurfer/license.txt"

if [ -n "${TEMPLATES}" ]; then
  cmd+=" -v ${TEMPLATES}:/atlases"
fi

if [ -n "${PARCELLATIONS}" ]; then
  cmd+=" -v ${PARCELLATIONS}:/opt/dcan-tools/dcan_bold_proc/templates/parcellations"
fi

if [ -n "${MASK}" ]; then
  cmd+=" -v ${MASK}:/masks"
fi

cmd+=" dcanumn/nhp-abcd-bids-pipeline /input /output --participant-label ${subname} --session-id [ ${sesh} ] --ncpus ${cores}"

if [ ! -z "${T1wMask}" ]; then
  cmd+=" --t1-brain-mask /masks/sub-${subname}/ses-${sesh}/T1w_average_pre_mask.nii.gz"
fi

if [ ! -z "${T2wMask}" ]; then
  cmd+=" --t2-brain-mask /masks/sub-${subname}/ses-${sesh}/T2w_average_pre_mask.nii.gz"
fi

if [ ! -z "${ASEG}" ]; then
  cmd+=" --aseg /masks/sub-${subname}/ses-${sesh}/aseg_acpc.nii.gz"
fi

if [ -n "${JLC}" ]; then
  cmd+=" --multi-template-dir /atlases/${JLC}"
fi

if [ -n "${HYPER_NORM_METHOD}" ]; then
  cmd+=" --hyper-normalization-method ${HYPER_NORM_METHOD}"
fi

if [ -n "${MAKE_WHITE_FROM_NORM_T1}" ]; then
  cmd+=" --make-white-from-norm-t1"
fi

if [ -n "${SINGLE_PASS_PIAL}" ]; then
  cmd+=" --single-pass-pial"
fi

if [ -n "${MAX_CORTICAL_THICKNESS}" ]; then
  cmd+=" --max-cortical-thickness ${MAX_CORTICAL_THICKNESS}"
fi

cmd+=" --freesurfer-license=/opt/freesurfer/license.txt"

if [ ! -z "$PrintCommandsOnly" ]; then
  cmd+=" --print-commands-only"
fi



echo ${sesh}
if [ ! -d ${OUTPUT}/proc_times ]; then
  mkdir -p ${OUTPUT}/proc_times;
fi
echo "START" >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt
date >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt
echo $cmd >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt 


eval $cmd

echo "END" >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt

date >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt




# fname=$1
# echo "fname is: ${fname}"
# #fname=sub-003/ses-001
# cores=$2
# INPUT=$3
# echo "INPUT is: ${INPUT}"

# OUTPUT=$4
# PreFreeSurfer=$5
# fMRIVolume=$6
# LICENSE=$7
# TEMPLATES=$8
# PARCELLATIONS=$9
# sTEMPLATE_head=$10 
# sTEMPLATE_brain=$11
# JLC=$12
# echo "JLC is: ${JLC}"
# MASK=$13
# echo "MASK is: ${MASK}"
# T1wMask=$14
# T2wMask=$15
# ASEG=$16
# HYPER_NORM_METHOD=$17
# MAX_CORTICAL_THICKNESS=$18
# MAKE_WHITE_FROM_NORM_T1=$19
# SINGLE_PASS_PIAL=$20
# PrintCommandsOnly=$21

# fullsesh=`basename $fname`
# sesh=`echo $fullsesh | cut -d '-' -f 2-`
# fullsub=`echo ${fname} | cut -d'/' -f $(($(echo ${fname} | awk -F'/' '{print NF}')-1))`
# subname=`echo $fullsub | cut -d '-' -f 2-`

# cmd="docker run -i --rm -v ${INPUT}:/input -v ${OUTPUT}:/output"

# if [ ! -z "$TEMPLATES" ]; then
#   cmd+=" -v ${TEMPLATES}:/atlases"
# fi

# if [ ! -z "$PARCELLATIONS" ]; then
#   cmd+=" -v ${PARCELLATIONS}:/opt/dcan-tools/dcan_bold_proc/templates/parcellations"
# fi

# if [ ! -z "$fMRIVolume" ]; then
#   cmd+=" -v ${fMRIVolume}:/opt/pipeline/fMRIVolume"
# fi

# if [ ! -z "$PreFreeSurfer" ]; then
#   cmd+=" -v ${PreFreeSurfer}:/opt/pipeline/PreFreeSurfer"
# fi

if [ ! -z "$MASK" ]; then
   cmd+=" -v ${MASK}:/masks"
fi

# cmd+=" -v /home/bramirez/pipelines/freesurfer/license.txt:/opt/freesurfer/license.txt dcanumn/nhp-abcd-bids-pipeline /input /output --participant-label ${subname} --session-id [ ${sesh} ] --ncpus ${cores}"

# if [ ! -z "$T1wMask" ]; then
#   cmd+=" --t1-brain-mask /masks/sub-${subname}/ses-${sesh}/T1w_average_pre_mask.nii.gz"
# fi

# if [ ! -z "$T2wMask" ]; then
#   cmd+=" --t2-brain-mask /masks/sub-${subname}/ses-${sesh}/T2w_average_pre_mask.nii.gz"
# fi

# if [ ! -z "$ASEG" ]; then
#   cmd+=" --aseg /masks/sub-${subname}/ses-${sesh}/aseg_acpc.nii.gz"
# fi

# if [ ! -z "$JLC" ]; then
#   cmd+=" --multi-template-dir /atlases/${JLC}"
# fi

# if [ ! -z "$HYPER_NORM_METHOD" ]; then
#   cmd+=" --hyper-normalization-method ${HYPER_NORM_METHOD}"
# fi

# if [ ! -z "$MAKE_WHITE_FROM_NORM_T1" ]; then
#   cmd+=" --make-white-from-norm-t1"
# fi

# if [ ! -z "$SINGLE_PASS_PIAL" ]; then
#   cmd+=" --single-pass-pial"
# fi

# if [ ! -z "$MAX_CORTICAL_THICKNESS" ]; then
#   cmd+=" --max-cortical-thickness ${MAX_CORTICAL_THICKNESS}"
# fi

# cmd+=" --freesurfer-license=/opt/freesurfer/license.txt"

# if [ ! -z "$PrintCommandsOnly" ]; then
#   cmd+=" --print-commands-only"
# fi


# echo ${sesh}
# if [ ! -d ${OUTPUT}/proc_times ]; then
#   mkdir -p ${OUTPUT}/proc_times;
# fi
# echo "START" >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt
# date >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt
# echo $cmd >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt 


# eval $cmd

# echo "END" >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt

# date >> ${OUTPUT}/proc_times/${subname}_${sesh}.txt



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
