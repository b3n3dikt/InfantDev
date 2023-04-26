
## Making symlinks for denoising 
infopath=/home/bramirez/projects/InfantDevelopment/NKIdev/info
scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
data_in=/projects/NHP_processed/developmental_in_modified
cd $data_in

for s in $(seq -f "%03g" 1 3); do
  
  sname=`echo $macaque_names | cut -d " " -f  $s`
  sesDates=`ls -d sub-${s}/ses-*`
  j=000
  for ss in ${sesDates}; do
    j=$((j+001))
    printf -v ssnum "%03d" $j
    sesDate=`echo $ss | cut -d '/' -f 2`
    
    pushd sub-${s}/ses-${ssnum}/anat/
    T1w=`ls *T1w*.nii.gz`

    nT1w=`ls *T1w*.nii.gz | wc -l`
    runmax=1
    if [ "$nT1w" -gt "$runmax" ]; then
      echo "multiple runs"
      for fname in ${T1w}; do
        
        ${ANTSPATH}${ANTSPATH:+/}DenoiseImage -d 3 -n Rician -i ${fname} -v -o ${fname}

      done
    else
      echo "run not identified"
      for fname in ${T1w}; do
        vols=`3dinfo -nt $fname`
        ${ANTSPATH}${ANTSPATH:+/}DenoiseImage -d 3 -n Rician -i ${fname} -v -o ${fname}
      done
    fi
    T2w=`ls *T2w*.nii.gz`
    nT2w=`ls *T2w*.nii.gz | wc -l`
    
    runmax=1
    if [ "$nT2w" -gt "$runmax" ]; then
      echo "multiple runs"
      for fname in ${T2w}; do
        vols=`3dinfo -nt $fname`
        ${ANTSPATH}${ANTSPATH:+/}DenoiseImage -d 3 -n Rician -i ${fname} -v -o ${fname}
      done
    else
      echo "run not identified"
      for fname in ${T2w}; do
        ${ANTSPATH}${ANTSPATH:+/}DenoiseImage -d 3 -n Rician -i ${fname} -v -o ${fname}
      done
    fi
    
    
    popd
    
    #echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${nT1w},${nT2w},${nrest},${nrev} " >> ${infopath}/ID_change_log.csv
  done
  #popd
done




#scratch below


N4BiasFieldCorrection \
			-d 3 \
			-i ${subject}_iso.nii.gz \
			-s 4 \
			-b [180] \
			-c [50x50x50x50, 0.00001 ] \
			-o [${subject}_b.nii.gz , ${subject}_BiasField.nii.gz] 
			


#Go through each func file identify if it has 16 volumes if it doesn move to fmap folder. 
infopath=/home/bramirez/projects/InfantDevelopment/NKIdev/info
scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
data_in=/projects/NHP_processed/developmental_in

macaque_names="MILO OOPS PETRA"
## Getting CSV for each session
blank=""
#echo "${blank}" > ${infopath}/ID_change_log.csv
echo "${blank}" > ${infopath}/All_files_change_log.csv
echo "Orig_subID,Renamed_subID,Orig_ses,Renamed_ses,num_T1w,numT2w,numRest,numRev" > ${infopath}/ID_change_log.csv


for s in $(seq -f "%03g" 1 3); do
  sname=`echo $macaque_names | cut -d " " -f  $s`
  sesDates=`ls -d sub-${s}/ses-*`
  j=000
  for ss in ${sesDates}; do
    j=$((j+001))
    printf -v ssnum "%03d" $j
    sesDate=`echo $ss | cut -d '/' -f 2`
    pushd ${ss}/anat/
    T1w=`ls *T1w*.nii.gz`
    nT1w=`ls *T1w*.nii.gz | wc -l`
    T2w=`ls *T2w*.nii.gz`
    nT2w=`ls *T2w*.nii.gz | wc -l`
    popd
    pushd ${ss}/func/
    rest=`ls *.nii.gz`
    nrest=0
    nrev=0
    for rr in ${rest}; do
      vols=`3dinfo -nt $rr`

      if [ "$vols" == "16" ]; then 
        #echo $vols
        #echo "fmap"
        nrev=$((nrev+1))

      elif  [ "$vols" == "400" ]; then 
        #echo "regular"
        nrest=$((nrest+1))
        #echo $nrest
      fi
    done

    popd
    echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${nT1w},${nT2w},${nrest},${nrev} " >> ${infopath}/ID_change_log.csv
  done
  #popd
done


## getting CSV for all files


macaque_names="MILO OOPS PETRA"
## Getting CSV for each session
blank=""
#echo "${blank}" > ${infopath}/ID_change_log.csv
echo "Orig_subID,Orig_ses,Original_file,Renamed_subID,Renamed_ses,Renamed_file,nvols,type,image_folder,image_type" > ${infopath}/All_files_name_change_log.csv
echo "Orig_subID,Orig_ses,Original_file,Renamed_subID,Renamed_ses,Renamed_file,nvols,type,image_folder,image_type" > ${infopath}/fmap_files_name_change_log.csv
echo "Orig_subID,Orig_ses,Original_file,Renamed_subID,Renamed_ses,Renamed_file,nvols,type,image_folder,image_type" > ${infopath}/func_files_name_change_log.csv
echo "Orig_subID,Orig_ses,Original_file,Renamed_subID,Renamed_ses,Renamed_file,nvols,type,image_folder,image_type" > ${infopath}/anat_files_name_change_log.csv
#echo "Orig_subID,Renamed_subID,Orig_ses,Renamed_ses,num_T1w,numT2w,numRest,numRev" > ${infopath}/ID_change_log.csv

for s in $(seq -f "%03g" 1 3); do
  sname=`echo $macaque_names | cut -d " " -f  $s`
  sesDates=`ls -d sub-${s}/ses-*`
  j=000
  for ss in ${sesDates}; do
    j=$((j+001))
    printf -v ssnum "%03d" $j
    sesDate=`echo $ss | cut -d '/' -f 2`
    pushd ${ss}/anat/
    T1w=`ls *T1w*.nii.gz`

    nT1w=`ls *T1w*.nii.gz | wc -l`
    runmax=1
    if [ "$nT1w" -gt "$runmax" ]; then
      echo "multiple runs"
      for fname in ${T1w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 4-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T1w"
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.${ext}"
        
        echo "sub-${sname},${sesDate},${fname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/All_files_name_change_log.csv
        echo "sub-${sname},${sesDate},${fname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/anat_files_name_change_log.csv
        ftype="json"
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.json"
        echo "sub-${sname},${sesDate},${jname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/All_files_name_change_log.csv
        echo "sub-${sname},${sesDate},${jname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/anat_files_name_change_log.csv
      done
    else
      echo "run not identified"
      for fname in ${T1w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        #run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 3-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T1w"
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.${ext}"
        echo "sub-${sname},${sesDate},${fname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/All_files_name_change_log.csv        
        echo "sub-${sname},${sesDate},${fname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/anat_files_name_change_log.csv
        ftype="json"
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.json"
        echo "sub-${sname},${sesDate},${jname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/All_files_name_change_log.csv
        echo "sub-${sname},${sesDate},${jname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/anat_files_name_change_log.csv
      done
    fi
    T2w=`ls *T2w*.nii.gz`
    nT2w=`ls *T2w*.nii.gz | wc -l`
    
    runmax=1
    if [ "$nT2w" -gt "$runmax" ]; then
      echo "multiple runs"
      for fname in ${T2w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 4-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T2w"
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.${ext}"
        
        echo "sub-${sname},${sesDate},${fname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/All_files_name_change_log.csv
        echo "sub-${sname},${sesDate},${fname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/anat_files_name_change_log.csv
        ftype="json"
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.json"
        echo "sub-${sname},${sesDate},${jname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/All_files_name_change_log.csv
        echo "sub-${sname},${sesDate},${jname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/anat_files_name_change_log.csv        
      done
    else
      echo "run not identified"
      for fname in ${T2w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        #run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 3-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T2w"
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.${ext}"
        
        echo "sub-${sname},${sesDate},${fname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/All_files_name_change_log.csv
        echo "sub-${sname},${sesDate},${fname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/anat_files_name_change_log.csv
        ftype="json"
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.json"
        echo "sub-${sname},${sesDate},${jname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/All_files_name_change_log.csv
        echo "sub-${sname},${sesDate},${jname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/anat_files_name_change_log.csv
      done
    fi
    
    
    popd
    pushd ${ss}/func/
    rest=`ls *.nii.gz`
    nrest=0
    nrev=0
    for fname in ${rest}; do
      vols=`3dinfo -nt $fname`
      
      if [ "$vols" == "16" ]; then 
        #echo $vols
        #echo "fmap"
        nrev=$((nrev+1))
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 4`
        ending=`echo $fname | cut -d '_' -f 5-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="fmap"
        imagefile="rev-EPI"

        newname="sub-${s}_ses-${ssnum}_${task}_acq-${nrev}_dir-AP_epi.nii.gz"

        echo "sub-${sname},${sesDate},${fname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/All_files_name_change_log.csv
        echo "sub-${sname},${sesDate},${fname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/fmap_files_name_change_log.csv
        ftype="json"
        newname="sub-${s}_ses-${ssnum}_${task}_acq-${nrev}_dir-AP_epi.json"

        echo "sub-${sname},${sesDate},${jname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/All_files_name_change_log.csv
        echo "sub-${sname},${sesDate},${jname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/fmap_files_name_change_log.csv
      else 
        #echo "regular"
        nrest=$((nrest+1))
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 4`
        ending=`echo $fname | cut -d '_' -f 5-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="func"
        imagefile="bold"
        newname="sub-${s}_ses-${ssnum}_${task}_run-${nrest}_${scan}.${ext}"

        echo "sub-${sname},${sesDate},${fname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/All_files_name_change_log.csv
        echo "sub-${sname},${sesDate},${fname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/func_files_name_change_log.csv
        ftype="json"
        newname="sub-${s}_ses-${ssnum}_${task}_run-${nrest}_${scan}.json"

        echo "sub-${sname},${sesDate},${jname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/All_files_name_change_log.csv
        echo "sub-${sname},${sesDate},${jname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/func_files_name_change_log.csv

      fi
    done

    popd
    #echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${nT1w},${nT2w},${nrest},${nrev} " >> ${infopath}/ID_change_log.csv
  done
  #popd
done


## Once you made the csv, take out idetifying informating and rename/move files accordingly
for s in $(seq -f "%03g" 3 3); do

  sname=`echo $macaque_names | cut -d " " -f  $s`
  sesDates=`ls -d sub-${s}/ses-*`
  j=000
  for ss in ${sesDates}; do
    j=$((j+001))
    printf -v ssnum "%03d" $j
    sesDate=`echo $ss | cut -d '/' -f 2`
    mv ${ss} sub-${s}/ses-${ssnum}
    pushd sub-${s}/ses-${ssnum}/anat/
    T1w=`ls *T1w*.nii.gz`

    nT1w=`ls *T1w*.nii.gz | wc -l`
    runmax=1
    if [ "$nT1w" -gt "$runmax" ]; then
      echo "multiple runs"
      for fname in ${T1w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 4-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T1w"
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.${ext}"
        mv ${fname} ${newname}
        3drefit -denote ${newname} 
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.json"
        mv ${jname} ${newname}
      done
    else
      echo "run not identified"
      for fname in ${T1w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        #run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 3-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T1w"
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.${ext}"
        
        mv ${fname} ${newname}
        3drefit -denote ${newname} 
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.json"

        mv ${jname} ${newname}
      done
    fi
    T2w=`ls *T2w*.nii.gz`
    nT2w=`ls *T2w*.nii.gz | wc -l`
    
    runmax=1
    if [ "$nT2w" -gt "$runmax" ]; then
      echo "multiple runs"
      for fname in ${T2w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 4-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T2w"
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.${ext}"
        
        mv ${fname} ${newname}
        3drefit -denote ${newname} 
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.json"
        mv ${jname} ${newname}
      done
    else
      echo "run not identified"
      for fname in ${T2w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        #run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 3-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T2w"
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.${ext}"
        
        mv ${fname} ${newname}
        3drefit -denote ${newname} 
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.json"
        mv ${jname} ${newname}
      done
    fi
    
    
    popd
    pushd sub-${s}/ses-${ssnum}/func/
    rest=`ls *.nii.gz`
    nrest=0
    nrev=0
    for fname in ${rest}; do
      vols=`3dinfo -nt $fname`
      
      if [ "$vols" == "16" ]; then 
        #echo $vols
        #echo "fmap"
        nrev=$((nrev+1))
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 4`
        ending=`echo $fname | cut -d '_' -f 5-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="fmap"
        imagefile="rev-EPI"

        newname="sub-${s}_ses-${ssnum}_${task}_acq-${nrev}_dir-AP_epi.nii.gz"
        mkdir ../fmap
        mv ${fname} ../fmap/${newname}
        3drefit -denote ../fmap/${newname} 

        newname="sub-${s}_ses-${ssnum}_${task}_acq-${nrev}_dir-AP_epi.json"
        mv ${jname} ../fmap/${newname}

      elif  [ "$vols" == "400" ]; then 
        #echo "regular"
        nrest=$((nrest+1))
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 4`
        ending=`echo $fname | cut -d '_' -f 5-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="func"
        imagefile="bold"
        newname="sub-${s}_ses-${ssnum}_${task}_run-${nrest}_${scan}.${ext}"

        mv ${fname} ${newname}
        3drefit -denote ${newname} 

        newname="sub-${s}_ses-${ssnum}_${task}_run-${nrest}_${scan}.json"

        mv ${jname} ${newname}

      fi
    done

    popd
    #echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${nT1w},${nT2w},${nrest},${nrev} " >> ${infopath}/ID_change_log.csv
  done
  #popd
done


## Making symlinks for denoising 
infopath=/home/bramirez/projects/InfantDevelopment/NKIdev/info
scripts_path=/home/bramirez/projects/InfantDevelopment/NKIdev/scripts
data_in=/projects/NHP_processed/developmental_in_modified

for s in $(seq -f "%03g" 1 3); do
  mkdir ${data_in}/sub-${s}
  sname=`echo $macaque_names | cut -d " " -f  $s`
  sesDates=`ls -d sub-${s}/ses-*`
  j=000
  for ss in ${sesDates}; do
    j=$((j+001))
    printf -v ssnum "%03d" $j
    sesDate=`echo $ss | cut -d '/' -f 2`
    mkdir ${data_in}/sub-${s}/ses-${ssnum}
    mkdir ${data_in}/sub-${s}/ses-${ssnum}/anat
    mkdir ${data_in}/sub-${s}/ses-${ssnum}/func
    mkdir ${data_in}/sub-${s}/ses-${ssnum}/fmap
    pushd sub-${s}/ses-${ssnum}/anat/
    T1w=`ls *T1w*.nii.gz`

    nT1w=`ls *T1w*.nii.gz | wc -l`
    runmax=1
    if [ "$nT1w" -gt "$runmax" ]; then
      echo "multiple runs"
      for fname in ${T1w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 4-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T1w"
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.${ext}"
        cp ${fname} ${data_in}/sub-${s}/ses-${ssnum}/anat/${newname}
        #3drefit -denote ${newname} 
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.json"
        cp ${jname} ${data_in}/sub-${s}/ses-${ssnum}/anat/${newname}
      done
    else
      echo "run not identified"
      for fname in ${T1w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        #run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 3-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T1w"
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.${ext}"
        
        cp ${fname} ${data_in}/sub-${s}/ses-${ssnum}/anat/${newname}
        #3drefit -denote ${newname} 
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.json"

        cp ${jname} ${data_in}/sub-${s}/ses-${ssnum}/anat/${newname}
      done
    fi
    T2w=`ls *T2w*.nii.gz`
    nT2w=`ls *T2w*.nii.gz | wc -l`
    
    runmax=1
    if [ "$nT2w" -gt "$runmax" ]; then
      echo "multiple runs"
      for fname in ${T2w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 4-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T2w"
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.${ext}"
        
        cp ${fname} ${data_in}/sub-${s}/ses-${ssnum}/anat/${newname}
        #3drefit -denote ${newname} 
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.json"
        cp ${jname} ${data_in}/sub-${s}/ses-${ssnum}/anat/${newname}
      done
    else
      echo "run not identified"
      for fname in ${T2w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        #run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 3-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T2w"
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.${ext}"
        
        cp ${fname} ${data_in}/sub-${s}/ses-${ssnum}/anat/${newname}
        #3drefit -denote ${newname} 
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.json"
        cp ${jname} ${data_in}/sub-${s}/ses-${ssnum}/anat/${newname}
      done
    fi
    
    
    popd
    pushd sub-${s}/ses-${ssnum}/func/
    rest=`ls *.nii.gz`
    nrest=0
    nrev=0
    for fname in ${rest}; do
      vols=`3dinfo -nt $fname`
      
      if [ "$vols" == "16" ]; then 
        echo $vols
        echo "THIS SHOULD NOT BE IN HERE SOMETHING IS WRONG"
        nrev=$((nrev+1))
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 4`
        ending=`echo $fname | cut -d '_' -f 5-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="fmap"
        imagefile="rev-EPI"

        newname="sub-${s}_ses-${ssnum}_${task}_acq-${nrev}_dir-AP_epi.nii.gz"
        #mkdir ../fmap
        #mv ${fname} ../fmap/${newname}
        #3drefit -denote ../fmap/${newname} 

        newname="sub-${s}_ses-${ssnum}_${task}_acq-${nrev}_dir-AP_epi.json"
        #mv ${jname} ../fmap/${newname}

      else 
        #echo "regular"
        nrest=$((nrest+1))
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 4`
        ending=`echo $fname | cut -d '_' -f 5-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="func"
        imagefile="bold"
        newname="sub-${s}_ses-${ssnum}_${task}_run-${nrest}_${scan}.${ext}"
        ln -s ${fname} ${data_in}/sub-${s}/ses-${ssnum}/func/${newname}
        #mv ${fname} ${newname}
        #3drefit -denote ${newname} 

        newname="sub-${s}_ses-${ssnum}_${task}_run-${nrest}_${scan}.json"

        ln -s ${jname} ${data_in}/sub-${s}/ses-${ssnum}/func/${newname}

      fi
    done

    popd
    pushd sub-${s}/ses-${ssnum}/fmap/
    rest=`ls *.nii.gz`
    nrest=0
    nrev=0
    for fname in ${rest}; do
      vols=`3dinfo -nt $fname`
      
      if [ "$vols" == "16" ]; then
        nrev=$((nrev+1))
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 4`
        ending=`echo $fname | cut -d '_' -f 5-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="fmap"
        imagefile="rev-EPI"

        newname="sub-${s}_ses-${ssnum}_${task}_acq-${nrev}_dir-AP_epi.nii.gz"
        ln -s ${fname} ${data_in}/sub-${s}/ses-${ssnum}/fmap/${newname}
        #mv ${fname} ../fmap/${newname}
        #3drefit -denote ../fmap/${newname} 

        newname="sub-${s}_ses-${ssnum}_${task}_acq-${nrev}_dir-AP_epi.json"
        ln -s ${jname} ${data_in}/sub-${s}/ses-${ssnum}/fmap/${newname}

        #mv ${jname} ../fmap/${newname}

      else 
        echo "THERE IS A NON FMAP FILE IN FMAP FOLDER"
        nrest=$((nrest+1))
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 4`
        ending=`echo $fname | cut -d '_' -f 5-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="func"
        imagefile="bold"
        newname="sub-${s}_ses-${ssnum}_${task}_run-${nrest}_${scan}.${ext}"
        #ln -s ${fname} ${data_in}/sub-${s}/ses-${ssnum}/func/${newname}
        #mv ${fname} ${newname}
        #3drefit -denote ${newname} 

        newname="sub-${s}_ses-${ssnum}_${task}_run-${nrest}_${scan}.json"

        #ln -s ${jname} ${data_in}/sub-${s}/ses-${ssnum}/func/${newname}

      fi
    done

    popd
    #echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${nT1w},${nT2w},${nrest},${nrev} " >> ${infopath}/ID_change_log.csv
  done
  #popd
done

#instead of moving or copying data do 3drefit -denote input.nii.gz -prefix output.nii.gz

### SCRATCH



for s in $(seq -f "%03g" 1 3); do
  sname=`echo $macaque_names | cut -d " " -f  $s`
  sesDates=`ls -d sub-${s}/ses-*`
  j=000
  for ss in ${sesDates}; do
    j=$((j+001))
    printf -v ssnum "%03d" $j
    sesDate=`echo $ss | cut -d '/' -f 2`
    pushd ${ss}/anat/
    T1w=`ls *T1w*.nii.gz`

    nT1w=`ls *T1w*.nii.gz | wc -l`
    runmax=1
    if [ "$nT1w" -gt "$runmax" ]; then
      echo "multiple runs"
      for fname in ${T1w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 4-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T1w"
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.${ext}"
        
        echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${ftype},${imagefolder},${imagefile},${fname},${newname},${vols}" >> ${infopath}/All_files_change_log.csv
        ftype="json"
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.json"
        echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${ftype},${imagefolder},${imagefile},${jname},${newname},${vols}" >> ${infopath}/All_files_change_log.csv
      done
    else
      echo "run not identified"
      for fname in ${T1w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        #run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 3-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T1w"
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.${ext}"
        
        echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${ftype},${imagefolder},${imagefile},${fname},${newname},${vols}" >> ${infopath}/All_files_change_log.csv
        ftype="json"
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.json"
        echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${ftype},${imagefolder},${imagefile},${jname},${newname},${vols}" >> ${infopath}/All_files_change_log.csv
      done
    fi
    T2w=`ls *T2w*.nii.gz`
    nT2w=`ls *T2w*.nii.gz | wc -l`
    
    runmax=1
    if [ "$nT2w" -gt "$runmax" ]; then
      echo "multiple runs"
      for fname in ${T2w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 4-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T2w"
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.${ext}"
        
        echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${ftype},${imagefolder},${imagefile},${fname},${newname},${vols}" >> ${infopath}/All_files_change_log.csv
        ftype="json"
        newname="sub-${s}_ses-${ssnum}_${run}_${scan}.json"
        echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${ftype},${imagefolder},${imagefile},${jname},${newname},${vols}" >> ${infopath}/All_files_change_log.csv
      done
    else
      echo "run not identified"
      for fname in ${T2w}; do
        vols=`3dinfo -nt $fname`
        #could turn this into its own function to simplyfy later
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        #task=`echo $fname | cut -d '_' -f 3`
        #run=`echo $fname | cut -d '_' -f 3`
        ending=`echo $fname | cut -d '_' -f 3-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="anat"
        imagefile="T2w"
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.${ext}"
        
        echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${ftype},${imagefolder},${imagefile},${fname},${newname},${vols}" >> ${infopath}/All_files_name_change_log.csv
        ftype="json"
        newname="sub-${s}_ses-${ssnum}_run-1_${scan}.json"
        echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${ftype},${imagefolder},${imagefile},${jname},${newname},${vols}" >> ${infopath}/All_files_name_change_log.csv
      done
    fi
    
    
    popd
    pushd ${ss}/func/
    rest=`ls *.nii.gz`
    nrest=0
    nrev=0
    for fname in ${rest}; do
      vols=`3dinfo -nt $fname`
      
      if [ "$vols" == "16" ]; then 
        #echo $vols
        #echo "fmap"
        nrev=$((nrev+1))
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 4`
        ending=`echo $fname | cut -d '_' -f 5-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="fmap"
        imagefile="rev-EPI"

        newname="sub-${s}_ses-${ssnum}_${task}_acq-${nrev}_dir-AP_epi.nii.gz"

        echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${ftype},${imagefolder},${imagefile},${fname},${newname},${vols}" >> ${infopath}/All_files_name_change_log.csv
        ftype="json"
        newname="sub-${s}_ses-${ssnum}_${task}_acq-${nrev}_dir-AP_epi.json"

        echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${ftype},${imagefolder},${imagefile},${jname},${newname},${vols}" >> ${infopath}/All_files_name_change_log.csv

      elif  [ "$vols" == "400" ]; then 
        #echo "regular"
        nrest=$((nrest+1))
        sub=`echo $fname | cut -d '_' -f 1`
        ses=`echo $fname | cut -d '_' -f 2`
        task=`echo $fname | cut -d '_' -f 3`
        run=`echo $fname | cut -d '_' -f 4`
        ending=`echo $fname | cut -d '_' -f 5-`
        ext=`echo $ending | cut -d '.' -f 2-`
        scan=`echo $ending | cut -d '.' -f 1`
        noext=`echo $fname | cut -d '.' -f 1`
        jname="${noext}.json"
        #echo $sub $ses $run $scan $ending $ext
        ftype="nifti"
        imagefolder="func"
        imagefile="bold"
        newname="sub-${s}_ses-${ssnum}_${task}_run-${nrest}_${scan}.${ext}"

        echo "sub-${sname},${sesDate},${fname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/All_files_name_change_log.csv
        ftype="json"
        newname="sub-${s}_ses-${ssnum}_${task}_run-${nrest}_${scan}.json"

        echo "sub-${sname},${sesDate},${jname},sub-${s},ses-${ssnum},${newname},${vols},${ftype},${imagefolder},${imagefile}" >> ${infopath}/All_files_name_change_log.csv

      fi
    done

    popd
    #echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum},${nT1w},${nT2w},${nrest},${nrev} " >> ${infopath}/ID_change_log.csv
  done
  #popd
done

/home/bramirez/projects/ROI_sets/Surface_schemes/Monkey/Xu_CrossSpecies_labels/labels_10k_original
//home/bramirez/projects/ROI_sets/fsaverage_LR/MAJOM.L.white.10k_fs_LR.surf.gii
http://atom.childmind.org/home/bramirez/projects/PRIME-DE/data_BIDS_dcanumn_out/site-templates/sub-MacaqueYerkes19/ses-v12/files/T1w/MacaqueYerkes19_1mm/surf/lh.white
runmax=1
nT1w=0
if [ "$nT1w" -gt "$runmax" ]; then
  echo "t1 greatter"
else
  echo "tw lesser"
fi

fname=sub-OOPS_ses-20220331_task-REST_run-3_bold.nii.gz
fname=sub-OOPS_ses-20220331_task-REST_run-4_dir-rev_bold.nii.gz
#sub-001/ses-20211005/func/sub-MILO_ses-20211005_task-REST_run-5_dir-rev_bold.nii.gz
sub=`echo $fname | cut -d '_' -f 1`
ses=`echo $fname | cut -d '_' -f 2`
task=`echo $fname | cut -d '_' -f 3`
run=`echo $fname | cut -d '_' -f 4`
ending=`echo $fname | cut -d '_' -f 5-`
ext=`echo $ending | cut -d '.' -f 2-`
scan=`echo $ending | cut -d '.' -f 1`
echo $sub $ses $task $run $scan $ending $ext
subnum=1
sesnum=2
test="sub-${subnum}_ses-${sesnum}_${task}_${run}_${scan}.${ext}"
fname=sub-OOPS_ses-20220331_task-REST_run-3_bold.nii.gz







rest=`ls *.nii.gz`
nrest=0
nrev=0
for rr in ${rest}; do
  vols=`3dinfo -nt $rr`

  if [ "$vols" == "16" ]; then 
    #echo $vols
    #echo "fmap"
    nrev=$((nrev+1))

  elif  [ "$vols" == "400" ]; then 
    #echo "regular"
    nrest=$((nrest+1))
    #echo $nrest
  fi
done

echo $nrest $nrev

3dinfo -nt *.nii.gz


echo "${blank}" > ${infopath}/ID_change_log.csv
echo "${blank}" > ${infopath}/All_files_change_log.csv

for s in $(seq -f "%03g" 1 3); do
  sname=`echo $macaque_names | cut -d " " -f  $s`
  echo "sub-${sname},sub-${s}" >> ${infopath}/ID_change_log.csv
  #pushd sub-${s}
  sesDates=`ls -d sub-${s}/ses-*`
  j=000
  for ss in ${sesDates}; do
    j=$((j+001))
    printf -v ssnum "%03d" $j
    sesDate=`echo $ss | cut -d '/' -f 2`
    echo "sub-${sname},sub-${s},${sesDate},ses-${ssnum} " >> ${infopath}/ID_change_log.csv
    pushd ${ss}/anat/
    T1w=`ls *T1w*.nii.gz`
    nT1w`ls *T1w*.nii.gz | wc -l`


  done
  #popd
done


nsubs=`ls |wc -l`
for s in $(seq -f "%03g" 1 $nsubs); do
  echo $s
  nses=`ls -d sub-${s}/* |wc -l`
  echo $nses
  for ss in $(seq -f "%03g" 1 $nses); do
  echo
done

macaque_names="MILO OOPS PETRA"
test=`echo $macaque_names | cut -d " " -f  $s`

test=`echo $macaque_names | cut -d " " -f  $snum`

mnames=("MILO","OOPS","PETRA")
snum=0
for s in ${macaque_names}; do
  snum=$((snum+1))
  echo ${s}
  echo ${snum}

done
snum=
for s in $(seq -f "%03g" 1 3); do
  echo $s
  echo "sub-${s}"
  ls sub-${s}
  #pushd sub-${s}
  sesDates=`ls -d sub-${s}/ses-*`
  j=000
  for ss in ${sesDates}; do
    j=$((j+001))
    printf -v ssnum "%03d" $j
    echo ${ss}
    echo ${ssnum}
  done
  #popd
done


data_list=${list_dir}/scan197_runs_data.list
monkey_list=${list_dir}/scan197_runs_subject.list

run_list=${list_dir}/scan197_run.list
run_orig_list=${list_dir}/scan197_run_orig.list
sesh_list=${list_dir}/scan197_run_sesh.list
FD_list=${list_dir}/scan197_FD30.list

rm -f ${data_list} ${monkey_list} ${run_list} ${run_orig_list} ${FD_list}

for sub in ${macaque_names}; do
fname=sub-OOPS_ses-20220331_task-REST_run-3_bold.nii.gz
fname=sub-OOPS_ses-20220331_task-REST_run-4_dir-rev_bold.nii.gz
sub=`echo $fname | cut -d '_' -f 1`
ses=`echo $fname | cut -d '_' -f 2`
task=`echo $fname | cut -d '_' -f 3`
run=`echo $fname | cut -d '_' -f 4`
ending=`echo $fname | cut -d '_' -f 5-`
ext=`echo $ending | cut -d '.' -f 2-`
scan=`echo $ending | cut -d '.' -f 1`
echo $sub $ses $task $run $scan $ending $ext
subnum=1
sesnum=2
test="sub-${subnum}_ses-${sesnum}_${task}_${run}_${scan}.${ext}"
fname=sub-OOPS_ses-20220331_task-REST_run-3_bold.nii.gz

prefix=`echo $fname | cut -d '_' -f 1-4`
sub-OOPS/ses-20220331/func/sub-OOPS_ses-20220331_task-REST_run-3_bold.nii.gz
400
sub-OOPS/ses-20220331/func/sub-OOPS_ses-20220331_task-REST_run-4_dir-rev_bold.nii.gz
Oops denoised good QC, acpc space 
dcanumn_bids_in
ses-20190509
ses-20190523
ses-20190606
ses-20190618
ses-20190702
ses-20190718
ses-20190801
ses-20190815
ses-20190829
ses-20190912
ses-20190926

not bfc monkey_bids_in/sub-OOPS
ses-20191010
ses-20191024
ses-20191107
ses-20191121
ses-20191205
ses-20191217
ses-20191230
ses-20200114
ses-20200128
ses-20200211
ses-20200225
ses-20200310
ses-20200623
ses-20200721
ses-20200818
ses-20200915
ses-20201015


Milo dcanumn_bids_in/sub-MILO
ses-20210907
ses-20210921
ses-20211005
ses-20211019
ses-20211104
ses-20211116
ses-20211130
ses-20220222
ses-20220308
ses-20220322

ses-20210907
ses-20210921
ses-20211005
ses-20211019
ses-20211104
ses-20211116
ses-20211130
	ses-20211216
	ses-20211228
	ses-20220111
	ses-20220125
	ses-20220208
ses-20220222
ses-20220308
ses-20220322

ses-20220405
ses-20220419
ses-20220505
ses-20220517
ses-20220602
ses-20220616
ses-20220628
ses-20220712
ses-20220726
ses-20220823
ses-20220906
ses-20221101
ses-20221201
ses-20221222

PETRA dcanumn_bids_in/sub-PETRA denoised not acpc
ses-20210622
ses-20210706
ses-20210720
ses-20210803
ses-20210817
ses-20210831
ses-20210914
ses-20210928
ses-20211012
ses-20211026
ses-20211109
ses-20211123
ses-20211207
ses-20211221
ses-20220215
ses-20220301
ses-20220315
ses-20220329



ses-20210622
ses-20210706
ses-20210720
ses-20210803
ses-20210817
ses-20210831
ses-20210914
ses-20210928
ses-20211012
ses-20211026
ses-20211109
ses-20211123
ses-20211207
ses-20211221

ses-20220215
ses-20220301
ses-20220315
ses-20220329
ses-20220412
ses-20220426
ses-20220510
ses-20220514
ses-20220524
ses-20220607
ses-20220621
ses-20220719
ses-20220818
ses-20220913
ses-20221011
ses-20221103
ses-20221206
ses-20230105

ses-20210622
ses-20210706
ses-20210720
ses-20210803
ses-20210817
ses-20210831
ses-20210914
ses-20210928
ses-20211012
ses-20211026
ses-20211109
ses-20211123
ses-20211207
ses-20211221

ses-20220104
ses-20220118
ses-20220201
ses-20220215
ses-20220301
ses-20220315
ses-20220329

ses-20220412
ses-20220426
ses-20220510
ses-20220514
ses-20220524
ses-20220607
ses-20220621
ses-20220719
ses-20220818
ses-20220913
ses-20221011
ses-20221103
ses-20221206
ses-20230105


for i in `ls sub*/ses*/func/*run-*.nii.gz`;do
  echo ${i} >> /projects/bramirez/data/info/NKI_dev_func_nvols.csv
  fslnvols ${i} >> /projects/bramirez/data/info/NKI_dev_func_nvols.csv
done

for i in `ls sub*/ses*/anat/*T1w*.nii.gz`;do
  echo ${i} >> /projects/bramirez/data/info/NKI_dev_T1w_nvols.csv
  fslnvols ${i} >> /projects/bramirez/data/info/NKI_dev_T1w_nvols.csv
done
for i in `ls sub*/ses*/anat/*T2w*.nii.gz`;do
  echo ${i} >> /projects/bramirez/data/info/NKI_dev_T2w_nvols.csv
  fslnvols ${i} >> /projects/bramirez/data/info/NKI_dev_T2w_nvols.csv
done
petra 25 have run 4, think it's rev epi

