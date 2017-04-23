# Switch to home folder of the user
cd ~

# Install dependencies
#sudo apt-get install -f build-essential libpcap-dev libpcre3-dev libdumbnet-dev bison flex zlib1g-dev libdnet
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" build-essential libpcap-dev libpcre3-dev libdumbnet-dev bison flex zlib1g-dev libdnet
# Create a folder for snort and enter this folder
mkdir ~/snort_src
cd ~/snort_src

# Download and extract daq
wget https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz
tar -xvzf daq-2.0.6.tar.gz
cd daq-2.0.6

# Install daq
./configure
make
sudo make install

# Enter the snort folder. Download snort and extract it
cd ~/snort_src
wget https://www.snort.org/downloads/snort/snort-2.9.9.0.tar.gz
tar -xvzf snort-2.9.9.0.tar.gz
cd snort-2.9.9.0

# Install snort
./configure --enable-sourcefire
make
sudo make install

# Linke the shared libraries with snort
sudo ldconfig

# Create a symbolic link
sudo ln -s /usr/local/bin/snort /usr/sbin/snort

# Create snort user and group
sudo groupadd snort 
sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort

# Then create the folder structure to house the snort configuration
sudo mkdir /etc/snort
sudo mkdir /etc/snort/rules
sudo mkdir /usr/local/lib/snort_dynamicrules
sudo mkdir /var/log/snort

# Create new files for the white and black lists as well as the local rules, and change the permissions for the new directories.
sudo touch /etc/snort/rules/white_list.rules /etc/snort/rules/black_list.rules /etc/snort/rules/local.rules
sudo chmod -R 5775 /etc/snort
sudo chmod -R 5775 /var/log/snort
sudo chmod -R 5775 /usr/local/lib/snort_dynamicrules
sudo chown -R snort:snort /etc/snort
sudo chown -R snort:snort /var/log/snort
sudo chown -R snort:snort /usr/local/lib/snort_dynamicrules

# Then copy the configuration files from the source to your configuration directory.
sudo cp ~/snort_src/snort-2.9.9.0/etc/* /etc/snort/

# Now, download the community rules from snort.org and extract them 
sudo tar -xvf ~/community.tar.gz -C ~/
sudo cp ~/community-rules/* /etc/snort/rules

# Download the namanagr/CS740 git file to get updated snort.conf and local rules
sudo wget https://github.com/namanagr/CS740/archive/master.zip
sudo unzip master.zip 
sudo tar xvfz CS740-master/snortrules-snapshot-2990.tar.gz -C /etc/snort

sudo cp CS740-master/snort.conf /etc/snort/snort.conf
sudo cp CS740-master/local.rules /etc/snort/rules/local.rules

# Testing snort
sudo snort -T -c /etc/snort/snort.conf

# create log folder
cd ~
mkdir log

