#!/bin/bash
subject=$1
Infant_templates=$2
t1w_template_head=${Infant_templates}/$3
t1w_template_brain=${Infant_templates}/$4
t1w_template_aseg=${Infant_templates}/$5
base_data=$6
out_base=$7
current_date_time=$(date '+%Y-%m-%d_%H-%M-%S')
echo " " >> /home/bramirez/projects/InfantDevelopment/NKIdev/info/running_aseg_parallel_log.txt
echo " New attempt on ${current_date_time} " >> /home/bramirez/projects/InfantDevelopment/NKIdev/info/running_aseg_parallel_log.txt
echo " " >> /home/bramirez/projects/InfantDevelopment/NKIdev/info/running_aseg_parallel_log.txt
echo "Processing subject: ${subject} using template head: ${t1w_template_head} and template brain: ${t1w_template_brain} and ${t1w_template_aseg} from ${base_data} in ${out_base} on ${current_date_time} " >> /home/bramirez/projects/InfantDevelopment/NKIdev/info/running_aseg_parallel_log.txt

# Add your processing code here