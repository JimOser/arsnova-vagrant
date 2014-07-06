#!/usr/bin/env bash
 
NOW=$(date +"%Y%m%d%H%M")
FILE="../logs/aws$NOW.log"
{
echo "logfile is $FILE"
 
# The following must be installed before running 
# vagrant up --provider=aws
STARTTIME=$(date +%s)
vagrant --version
# vagrant global-status
# vagrant box list
# vagrant plugin list
if vagrant plugin list | egrep -q vagrant-aws 
  then
    echo "vagrant-aws plugin is installed" 
  else vagrant plugin install vagrant-aws 
fi
# if vagrant plugin list | egrep -q fog 
#   then
#     echo "fog plugin is installed" 
#   else vagrant plugin install fog 
# fi
# Vagrantfile specifies that rsync will 
# sync on Host side ../data  to Guest side /vagrant
# We are doing this because rsync exclusion does not work in 1.6.3
mkdir -p ../data

# vagrant plugin list
# According to vagrant google group forum there are problems with a cloud guest and rsyncing
# Here is one solution: https://github.com/smerrill/vagrant-rsync-back
# Do a manually rsync from the host side by:   $ vagrant rsync-back
# It may require doing twice:   $ vagrant rsync-back
# Note: This was needed with vagrant 1.6.3
# Rsync capabilites in both directions are suppose to be part of vagrant, so
# in the future this plugin might not be necessary.
# vagrant plugin install vagrant-rsync-back
# vagrant plugin list
if vagrant box  list | egrep -q dummy 
  then
    echo "dummy box is installed" 
  else
    vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
fi
vagrant box list
time VAGRANT_LOG=info vagrant up --provider=aws 2>&1    

vagrant ssh-config
ENDTIME=$(date +%s)
echo "These commands took $(($ENDTIME - $STARTTIME)) seconds to do "
# vagrant ssh -c "rvm info ; ruby -v ; hostname ; free -h ; uname -a ;  ps aux ; cat /proc/meminfo "
} | tee -a $FILE  
