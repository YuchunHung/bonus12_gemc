#!/bin/tcsh -f

# Assume that you have downloaded the Simulation folder from the github. 
# So far, it is supposed to have only gemc/ and submit_farm_all_recon_util/

if ( $# <= 1 ) then
	echo 'Please provide both the path that you want to store the simulation files and your email address which you want to receive a notice when jos is finish. ./createSimulation.csh <filesFolderPath> <your-email-address>'
	exit
endif
echo 'create new files folder'
set filesFolder=$argv[1]
mkdir $filesFolder/files 
mkdir $filesFolder/files/gen_files $filesFolder/files/gemc_out_evio_files $filesFolder/files/evio_to_hipo_files $filesFolder/files/recon_util_hipo_files

# create the jobs/ folder in submit_farm_all_recon_util/
if ( -e "./submit_farm_all_recon_util/jobs" ) then
	echo 'submit_farm_all_recon_util/jobs folder exists. Delete.'
		rm -r ./submit_farm_all_recon_util/jobs
endif
echo 'create new jobs/'
mkdir ./submit_farm_all_recon_util/jobs


#Modify the path and information for different user. 
echo 'Email set up'
set userEmail=$argv[2]
#set userEmail=$<

# Create jsub_sim.xml
echo 'Creating the submit_farm_all_recon_util/jsub_sim.xml ...'
echo '<Request>' > submit_farm_all_recon_util/jsub_sim.xml
echo '<Name name="rgf_sim"/>' >> submit_farm_all_recon_util/jsub_sim.xml
echo '<Project name="clas12"/>' >> submit_farm_all_recon_util/jsub_sim.xml
echo '<Track name="simulation"/>' >> submit_farm_all_recon_util/jsub_sim.xml
echo '<Email email="'$userEmail'" request="true" job="true"/>' >> submit_farm_all_recon_util/jsub_sim.xml
echo '<Memory space="2" unit="GB" />' >> submit_farm_all_recon_util/jsub_sim.xml
echo '<TimeLimit unit="hours" time="30"/>' >> submit_farm_all_recon_util/jsub_sim.xml
echo '<CPU core ="1"/>' >> submit_farm_all_recon_util/jsub_sim.xml
echo '<Command>''<''!''[CDATA[' >> submit_farm_all_recon_util/jsub_sim.xml
echo 'ls -l' >> submit_farm_all_recon_util/jsub_sim.xml
echo './command_submit_run_XXX' >> submit_farm_all_recon_util/jsub_sim.xml
echo 'ls -l' >> submit_farm_all_recon_util/jsub_sim.xml
echo ']]></Command>' >> submit_farm_all_recon_util/jsub_sim.xml
echo '<Input src="'$PWD'/gemc/source/gemc" dest="gemc"/>' >> submit_farm_all_recon_util/jsub_sim.xml
#echo '<Input src="/group/clas12/packages/coatjava/6.5.13/bin/evio2hipo" dest="evio2hipo"/>' >> submit_farm_all_recon_util/jsub_sim.xml
echo '<Input src="'$PWD'/submit_farm_all_recon_util/rgf_Summer2020.gcard" dest="rgf_Summer2020.gcard"/>' >> submit_farm_all_recon_util/jsub_sim.xml
echo '<Input src="'$PWD'/submit_farm_all_recon_util/rgf_mc.yaml" dest="rgf_mc.yaml"/>' >> submit_farm_all_recon_util/jsub_sim.xml
echo '<Input src="'$filesFolder'/files/gen_files/11GeV_flat_electrons/input_lund_file" dest="input_lund_file_2"/>' >> submit_farm_all_recon_util/jsub_sim.xml
echo '<Input src="'$PWD'/submit_farm_all_recon_util/jobs/command_submit_run_XXX" dest="command_submit_run_YYY"/>' >> submit_farm_all_recon_util/jsub_sim.xml
#echo '<Input src="/group/clas12/packages/coatjava/6.5.13/bin/evio2hipo" dest="evio2hipo"/>' >> submit_farm_all_recon_util/jsub_sim.xml
#echo '<Input src="/work/clas12/byale/software/fork/Clara2021_27Sept_v62.0/plugins/clas12/bin/recon-util" dest="recon-util"/>' >> submit_farm_all_recon_util/jsub_sim.xml
echo '' >> submit_farm_all_recon_util/jsub_sim.xml
echo '<Job>' >> submit_farm_all_recon_util/jsub_sim.xml
echo '</Job>' >> submit_farm_all_recon_util/jsub_sim.xml
echo '</Request>' >> submit_farm_all_recon_util/jsub_sim.xml


# Create command_script
echo 'Creating the submit_farm_all_recon_util/command_script ...'
echo '#''!''/usr/bin/perl' > submit_farm_all_recon_util/command_script
echo 'use strict;' >> submit_farm_all_recon_util/command_script
echo '$ENV{'"'MALLOC_ARENA_MAX'} = '2';" >> submit_farm_all_recon_util/command_script
echo 'my $work_dir = "'$PWD'/submit_farm_all_recon_util/jobs";' >> submit_farm_all_recon_util/command_script
echo 'system ("ls -lth");' >> submit_farm_all_recon_util/command_script
echo 'system ("source '$HOME'/.cshrc");' >> submit_farm_all_recon_util/command_script
echo 'system ("gemc rgf_Summer2020.gcard -USE_GUI=0 -N=100000 -INPUT_GEN_FILE=LUND,input_lund_file -OUTPUT=evio,output_evio_file -RUNNO=10");' >> submit_farm_all_recon_util/command_script
echo '' >> submit_farm_all_recon_util/command_script
#echo 'system ("evio2hipo -r 11 -t 0.5 -s -0.745 -o output_evio2hipo_file output_evio_file");' >> submit_farm_all_recon_util/command_script
#echo 'system ("recon-util -c 2 -i output_evio2hipo_file -o output_recon_hipo_file -y rgf_mc.yaml");' >> submit_farm_all_recon_util/command_script
echo 'system ("/group/clas12/packages/coatjava/7.0.1/bin/evio2hipo -r 10 -t 0.5 -s -0.745 -o output_evio2hipo_file output_evio_file");' >> submit_farm_all_recon_util/command_script
echo 'system ("/group/clas12/packages/coatjava/7.0.1/bin/recon-util -i output_evio2hipo_file -o output_recon_hipo_file -y rgf_mc.yaml");' >> submit_farm_all_recon_util/command_script
echo 'system ("ls -lth");' >> submit_farm_all_recon_util/command_script
echo '' >> submit_farm_all_recon_util/command_script
echo 'system ("mv -f output_recon_hipo_file '$filesFolder'/files/recon_util_hipo_files/");' >> submit_farm_all_recon_util/command_script
echo 'system ("rm -f input_lund_file");' >> submit_farm_all_recon_util/command_script
echo 'system ("rm -f output_evio_file '$filesFolder'/files/recon_util_hipo_files/");' >> submit_farm_all_recon_util/command_script
echo 'system ("rm -f output_evio2hipo_file");' >> submit_farm_all_recon_util/command_script
echo 'system ("ls -lth");' >> submit_farm_all_recon_util/command_script

################################################################################################################
# Create clara-cfg.template



echo 'Completed!'

#sed -i '5s/email=".*" r/email="'$userEmail'" r/' submit_farm_gemc/jsub_simTest.xml




