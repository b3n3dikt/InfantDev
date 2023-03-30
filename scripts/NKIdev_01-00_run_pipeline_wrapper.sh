

#step 1, run initial part of pipeline to get T1w average
cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/all_sessions.txt  | parallel -j 10 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-01_pipeline_command_first_pass_sub-001.sh'

#the run UNet masking to get masks 
/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_02_01_Unet_masking.sh

#then rerun pipeline with correct masks 
#cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/all_sessions.txt  | parallel -j 12 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-02_pipeline_command_second_pass_with_masks.sh'
cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/all_sessions_temp.txt  | parallel -j 12 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-02_pipeline_command_second_pass_with_masks.sh'
#/home/bramirez/projects/InfantDevelopment/NKIdev/info/all_sessions.txt
/home/bramirez/projects/InfantDevelopment/NKIdev/info/all_sessions_testing.txt
cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/all_sessions_testing.txt  | parallel -j 2 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-01_pipeline_command_first_pass_sub-001.sh'

cat /home/bramirez/projects/InfantDevelopment/NKIdev/info/all_sessions.txt  | parallel -j 10 '/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-01_pipeline_command_first_pass_sub-001.sh'
#chmod 777 /home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-01_pipeline_command_first_pass_sub-001.sh
#/home/bramirez/projects/InfantDevelopment/NKIdev/scripts/NKIdev_01-00_run_pipeline_wrapper.sh



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

