#!/usr/bin/env bash

# The Ubuntu AMI has the default user ubuntu,
# in order to be compatible with the rest of arsnova-vagrant,
# we need the user vagrant.
#
#Note: There are probably better ways to get around the above problem.
#
# create a user vagrant with /home/vagrant and shell /bin/bash
# -m creates the directory /home/vagrant if it doesn't already exist.
useradd -d /home/vagrant -m  vagrant -s /bin/bash 
