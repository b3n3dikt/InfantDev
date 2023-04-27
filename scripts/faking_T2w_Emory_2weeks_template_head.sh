fslmaths T1w_Emory_2weeks_template_head.nii.gz -mul -1 T2w_Emory_2weeks_template_head_faked.nii.gz
#fslmaths sub-${subID}_T2w.nii.gz -mul -1 sub-${subID}_T2w.nii.gz
maxint=`fslstats T1w_Emory_2weeks_template_head.nii.gz -R`
maxint=$(echo $maxint | awk '{print $2}')
fslmaths T2w_Emory_2weeks_template_head_faked.nii.gz -add ${maxint} T2w_Emory_2weeks_template_head_faked.nii.gz

N4BiasFieldCorrection -d 3 -i T2w_Emory_2weeks_template_head_faked.nii.gz -o T2w_Emory_2weeks_template_head_faked.nii.gz -c [50x50x50x50,0.00001] -b [180] -r 1
N4BiasFieldCorrection -d 3 -r [0,50] -i T2w_Emory_2weeks_template_head_faked.nii.gz -o T2w_Emory_2weeks_template_head_faked_bfc.nii.gz -c [50x50x50x50,0.00001] -b [200]
N4BiasFieldCorrection -d 3 -i T2w_Emory_2weeks_template_brain.nii.gz -o T2w_Emory_2weeks_template_brain_bfc.nii.gz -c [50x50x50x50,0.00001] -b [180] -r 1


inputimage=T2w_Emory_2weeks_template_head_faked.nii.gz
outputimage=T2w_Emory_2weeks_template_head_faked_0-218.nii.gz
fslmaths ${inputimage} -sub $(fslstats ${inputimage} -R | awk '{print $1}') -div $(fslstats ${inputimage} -R | awk '{print $2-$1}') -mul 218 ${outputimage}
inputimage=T2w_Emory_2weeks_template_brain.nii.gz
outputimage=T2w_Emory_2weeks_template_brain_0-50.nii.gz
fslmaths ${inputimage} -sub $(fslstats ${inputimage} -R | awk '{print $1}') -div $(fslstats ${inputimage} -R | awk '{print $2-$1}') -mul 50 ${outputimage}


fslmaths T1w_Emory_2weeks_template_mask.nii.gz -mul -1 -add 1 T1w_Emory_2weeks_template_invhead_mask.nii.gz

fslmaths T2w_Emory_2weeks_template_head_faked_0-218.nii.gz -mas T1w_Emory_2weeks_template_invhead_mask.nii.gz T2w_Emory_2weeks_template_just_faked_head.nii.gz
fslmaths T2w_Emory_2weeks_template_brain.nii.gz -add T2w_Emory_2weeks_template_just_faked_head.nii.gz T2w_Emory_2weeks_template_head.nii.gz


#Create a binary mask from the edited white matter file:
fslmaths wm.nii.gz -bin wm_mask.nii.gz
#Invert the binary mask to create a mask for the non-overlapping gray matter regions:
