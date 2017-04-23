This repository consists of snort modified configuration files and rules

./snort_setup_script

This will download, install and setup snort and other dependencies on the system.

Once the installation is complete, following the steps below - 

cd ~
./start_snort <interface_name>

It starts snort and creates alerts in the file ~/logs/alerts

## In a separate terminal, run "python process.py".
It will read snort alerts from ~/logs/alerts file, process them and commmunicate that to the softNIC program. 



