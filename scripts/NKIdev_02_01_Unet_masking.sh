#fname=$1
processed_folder=/projects/NHP_processed/developmental_out/
mask_folder=/projects/NHP_processed/developmental_out/masks/anatomical/
UNet_models=/home/bramirez/projects/InfantDevelopment/NKIdev/files/UNet/models
#/home/bramirez/projects/InfantDevelopment/NKIdev/files/UNet/models/Model_adding_sub-001_sub-003
model=Model_adding_sub-001_sub-003_model-19-epoch
if [ ! -d ${mask_folder} ]; then
  mkdir -p ${mask_folder};
fi
#sleep 24h 
while read -r fname
do
  #fname=sub-001/ses-002
  sub=`echo ${fname} | cut -d'/' -f $(($(echo ${fname} | awk -F'/' '{print NF}')-1))`
  ses=`echo ${fname} | cut -d'/' -f $(($(echo ${fname} | awk -F'/' '{print NF}')))`
  
  if [ ! -d ${mask_folder}/${fname} ]; then
    mkdir -p ${mask_folder}/${fname};
  fi
  if [ -f ${mask_folder}/${fname}/T1w_average_pre_mask.nii.gz ]; then
    echo "${mask_folder}/${fname}/T1w_average_pre_mask.nii.gz exists already, deleting"
    mv ${mask_folder}/${fname}/T1w_average_pre_mask.nii.gz ${mask_folder}/${fname}/T1w_average_pre_mask_firstattempt.nii.gz
  fi
  
  docker run \
  -v ${processed_folder}/${fname}/files/masks/:/input \
  -v ${mask_folder}/${fname}/:/output \
  -v ${UNet_models}/:/models \
  sandywangrest/deepbet \
  muSkullStrip.py \
  -in /input/T1w_average.nii.gz \
  -model /models/${model} \
  -out /output
  
done < /home/bramirez/projects/InfantDevelopment/NKIdev/info/subs_and_sessions.txt




docker run \
           -v /home2/bramirez/projects/InfantDevelopment/NKIdev/files/UNet/Training/T1w:/TrainT1w \
           -v /home2/bramirez/projects/InfantDevelopment/NKIdev/files/UNet/Training/masks:/TrainMsk \
           -v /home2/bramirez/projects/InfantDevelopment/NKIdev/files/UNet/models/Model_adding_sub-001_sub-003/:/Results \
           sandywangrest/deepbet \
           trainSs_UNet.py \
               -trt1w /TrainT1w \
               -trmsk /TrainMsk \
               -out /Results \
               -init /Results/OOPs4_Petra1-Milo1_model-39-epoch



# #mkdir -p ${mask_folder}
# /projects/NHP_processed/developmental_out/masks/anatomical/
# /projects/NHP_processed/developmental_out/sub-001/ses-001/files/masks/T1w_average.nii.gz



# /projects/NHP_processed/developmental_out/masks/anatomical
# #fname=/projects/NHP_processed/developmental_in_modified/sub-003/ses-035
# fullsesh=`basename $fname`
# #sesh=`echo $fullsesh | cut -c5-`
# sesh=`echo $fullsesh | cut -d '-' -f 2-`
# fullsub=`echo ${fname} | cut -d'/' -f $(($(echo ${fname} | awk -F'/' '{print NF}')-1))`
# #subname=`echo $fullsub | cut -c5-`
# subname=`echo $fullsub | cut -d '-' -f 2-`



# /home/projects/PRIME-DE/site-uwmadison/sub-1001/anat/
# /home/bramirez/projects/PRIME-DE/UNet/site-uwmadison/sub-1001/anat

# base_data=/home/projects/PRIME-DE/site-uwmadison
# base_out=/home/bramirez/projects/PRIME-DE/UNet/site-uwmadison


# while read -r line
# do
#   echo ${line}
#   mkdir ${base_out}/${line}
#   mkdir ${base_out}/${line}/anat
#   ln -s ${base_data}/${line}/anat/${line}_T1w.nii.gz ${base_out}/${line}/anat/${line}_T1w.nii.gz
  
# done < /home/bramirez/projects/PRIME-DE/UNet/site-uwmadison/sublist.txt


# while read -r line
# do
#   echo ${line}
#   rm ${base_out}/${line}/anat/${line}_T1w_pre_mask.nii.gz
#   docker run \
#   -v ${base_data}/${line}/anat/:/input \
#   -v ${base_out}/${line}/anat/:/output \
#   -v /home/bramirez/projects/PRIME-DE/UNet/models/:/models \
#   sandywangrest/deepbet \
#   muSkullStrip.py \
#   -in /input/${line}_T1w.nii.gz \
#   -model /models/model-39-epoch \
#   -out /output
  
# done < /home/bramirez/projects/PRIME-DE/UNet/site-uwmadison/sublist.txt

# #fox20-fat-model-37-epoch




# docker run \
#            -v /home/bramirez/projects/PRIME-DE/UNet/manual_masks/site-uwmadison/adding_manual_masks/TrainT1w:/TrainT1w \
#            -v /home/bramirez/projects/PRIME-DE/UNet/manual_masks/site-uwmadison/adding_manual_masks/TrainMsk:/TrainMsk \
#            -v /home/bramirez/projects/PRIME-DE/UNet/models/:/Results \
#            sandywangrest/deepbet \
#            trainSs_UNet.py \
#                -trt1w /TrainT1w \
#                -trmsk /TrainMsk \
#                -out /Results \
#                -init /Results/model-37e-fox40
              
# -init /initial_model_to_start_with
#   #-model /models/model-37e-fox40 \

# while read -r line
# do
#   echo ${line}
#   docker run \
#   -v ${base_out}/${line}/anat/:/input \
#   -v /home/bramirez/projects/PRIME-DE/UNet/models/:/models \
#   sandywangrest/deepbet \
#   muSkullStrip.py \
#   -in /input/${line}_T1w.nii.gz \
#   -model /models/model-37e-fox40 \
#   -out /input
  
# done < /home/bramirez/projects/PRIME-DE/UNet/site-uwmadison/sublist_testing.txt




# while read -r line
# do
#   echo ${line}
#   mkdir ${base_out}/${line}
#   mkdir ${base_out}/${line}/anat
#   ln -s ${base_data}/${line}/anat/${line}_T1w.nii.gz ${base_out}/${line}/anat/${line}_T1w.nii.gz
#   docker run --gpus all \
#   -v ${base_out}/${line}/anat/:/input \
#   -v /home/bramirez/projects/PRIME-DE/UNet/models/:/models \
#   sandywangrest/deepbet \
#   muSkullStrip.py \
#   -in /input/${line}_T1w.nii.gz \
#   -model /models/model-37e-fox40 \
#   -out /input
  
# done < /home/bramirez/projects/PRIME-DE/UNet/site-uwmadison/sublist_testing.txt





# line=sub-1002

# ls "${base_data}/${line}/anat/${line}_T1w.nii.gz"
# /sub-1002/anat/sub-1002_T1w.nii.gz
# /sub-1002/anat/sub-1002_T1w.nii.gz
# docker run --gpus all \
#            -v (Path of T1w images for training):/TrainT1w \
#            -v (Path of T1w masks for training):/TrainMsk \
#            -v (Path of trained model and log):/Results \
#            sandywangrest/deepbet \
#            trainSs_UNet.py \
#                -trt1w /TrainT1w \
#                -trmsk /TrainMsk \
#                -out /Results
#                (optional arguments)
               
               
# docker run --gpus all \
#            -v (Path of T1w images for training):/TrainT1w \
#            -v (Path of T1w masks for training):/TrainMsk \
#            -v (Path of trained model and log):/Results \
#            sandywangrest/deepbet \
#            trainSs_UNet.py \
#                -trt1w /TrainT1w \
#                -trmsk /TrainMsk \
#                -out /Results
#                (optional arguments)
