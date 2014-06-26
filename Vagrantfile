# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
ssh_user  = "vagrant"
ssh_group = "vagrant"

def aws_build?
  ENV['BUILD'] == "AWS"  
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  puts __LINE__
  if aws_build? 
    puts __LINE__
    ssh_user = "ubuntu"
    ssh_group = "ubuntu"
  # See: https://github.com/mitchellh/vagrant-aws
  # Manually do on command line:
  #    $ vagrant plugin install vagrant-aws
    config.vm.box = "dummy"
    config.vm.provider :aws do |aws, override|
      puts __LINE__
      # export AWS_ACCESS_KEY = "<your access key >"
      # export AWS_SECRET_KEY = "<your secret key >"
      aws.access_key_id = ENV['AWS_ACCESS_KEY'] 
      aws.secret_access_key = ENV['AWS_SECRET_KEY'] 
      # key pair
      aws.keypair_name = "NorthernCaliforniaKeyPairName"
      #   N. California
      #   Ubuntu Server 14.04 LTS (PV) - ami-ee4f77ab (64-bit) / ami-ec4f77a9 (32-bit) 
      aws.ami = "ami-ee4f77ab"
      aws.instance_type = 't1.micro'
      # Make your own security group or use "default"
      # Could modify code to look for environmental variable 'AWS_SECURITY_GROUPS'
      aws.security_groups = [ "myvagrantsecuritygroup" ]
      # You probably want to pick a region near where the majority of your customers are.
      aws.region= 'us-west-1'
      #
      override.ssh.username = ssh_user 
      # Could modify code to look for environmental variable 'PRIVATE_KEY_PATH'
      override.ssh.private_key_path = '~/.ssh/NorthernCaliforniaKeyPairName.pem'
      config.vm.synced_folder "../data", "/vagrant", type: "rsync"
#        rsync__exclude: [ ".git/", "tools/", "private/", ".gitignore", ".gitmodules", ".vagrant/"] 
# Got an error message when there were not any tags so add some dummy tags.
      aws.tags = {
        'MOOC' => 'iversity',
        'Course' => 'Web Engineering III'
      }
    end
  end
end
