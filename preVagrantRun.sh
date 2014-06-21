#!/usr/bin/env bash
# The following must be installed before running 
# vagrant up --provider=aws
vagrant plugin list
vagrant plugin install vagrant-aws
vagrant plugin list
# According to vagrant google group forum there are problems with a cloud guest and rsyncing
# Here is one solution: https://github.com/smerrill/vagrant-rsync-back
# Do a manually rsync from the host side by:   $ vagrant rsync-back
# It may require doing twice:   $ vagrant rsync-back
# Note: This was needed with vagrant 1.6.3
# Rsync capabilites in both directions are suppose to be part of vagrant, so
# in the future this plugin might not be necessary.
vagrant plugin install vagrant-rsync-back
vagrant plugin list
vagrant box list
vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
vagrant box list
# VAGRANT_LOG=info vagrant up --provider=aws > ../logs/aws201406201154.log 2>&1
