# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
ssh_user  = "vagrant"
ssh_group = "vagrant"
pp_manifest_path = "puppet/manifests"
pp_module_path = "puppet/modules"
pp_manifest_file = "debian-wheezy.pp"

def aws_build?
  ENV['BUILD'] == "AWS"  
end


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  puts "#{__FILE__}: #{__LINE__}"
  if aws_build?
    puts "#{__FILE__}: #{__LINE__}"
    ssh_user = "ubuntu"
    ssh_group = "ubuntu"
    # There is no GUI. Don't install xcfe or Chrome Browser.
    # t1.micro does not have enough memory for these programs.
    # If you try to install xcfe-goodies . It will install aspell , which 
    # will hang the system, because it hogs the cpu, probably trying to index the whole drive.    

    # root     29453 96.2  0.2  22176  1764 ?        R    21:37  51:27 aspell --per-conf=/dev/null --dont-validate-affixes --local-data-dir=/usr/lib/aspell --lang=en create master /var/lib/aspell/en-variant_2.rws

    pp_manifest_file = "aws-nogui.pp"
  # See: https://github.com/mitchellh/vagrant-aws
  # Manually do on command line:
  #    $ vagrant plugin install vagrant-aws
    config.vm.box = "dummy"
    config.vm.hostname = "aws-ubuntu"
    # install rvm per http://rvm.io/integration/vagrant
    config.vm.provision :shell, :path => "install-rvm.sh",  :args => "stable"
    config.vm.provision :shell, :path => "install-ruby.sh", :args => "1.9.3"
    config.vm.provision :shell, :path => "install-ruby.sh", :args => "1.9.3 listen"
    config.vm.provision :shell, :path => "install-puppet.sh"
    config.vm.provision "puppet" do |puppet|
      puppet.manifests_path = pp_manifest_path
      puppet.manifest_file = pp_manifest_file
      puppet.module_path = pp_module_path
      puppet.options = "--environment=development --verbose --debug"
      puppet.facter = {
        "git_owner" => "ubuntu",
        "git_group" => "ubuntu"
      }
    end
    #  dev.vm.network "forwarded_port", guest: 8080, host: 8080
    # socket.io port
    #    dev.vm.network "forwarded_port", guest: 10443, host: 10443
    # CouchDB
    #    dev.vm.network "forwarded_port", guest: 5984, host: 5984
    config.vm.provider :aws do |aws, override|
      puts "#{__FILE__}: #{__LINE__}"
      # export AWS_ACCESS_KEY = "<your access key >"
      # export AWS_SECRET_KEY = "<your secret key >"
      aws.access_key_id = ENV['AWS_ACCESS_KEY'] 
      aws.secret_access_key = ENV['AWS_SECRET_KEY'] 
      # key pair
      #   N. California
      #   Ubuntu Server 14.04 LTS (PV) - ami-ee4f77ab (64-bit) / ami-ec4f77a9 (32-bit) 
      # t1.micro
      # aws.ami = "ami-ee4f77ab"
      # aws.instance_type = 't1.micro'
      # aws.region= 'us-west-1'
      aws.keypair_name = "oregon"

      # Oregon
      # Ubuntu Server 14.04 LTS (HVM) - ami-6cc2a85c
      # t2.micro
      # Root device type: ebs Virtualization type: hvm
      aws.ami = "ami-6cc2a85c"
      aws.instance_type = 't2.micro'
      # Make your own security group or use "default"
      # Could modify code to look for environmental variable 'AWS_SECURITY_GROUPS'
      aws.security_groups = [ "myvagrantsecuritygroup" ]
      # You probably want to pick a region near where the majority of your customers are.
      
      # us-east-1 - US East (Virginia)
      # us-west-2 - US West (Oregon)
      # us-west-1 - US West (Northern California)
      # eu-west-1 - EU West (Ireland)
      # ap-southeast-1 - Asia Pacific (Singapore)
      # ap-southeast-2 - Asia Pacific (Sydney)
      # ap-northeast-1 - Asia Pacific (Tokyo)
      # sa-east-1 - South America (Sao Paulo)
      aws.region= 'us-west-2'
      #
      override.ssh.username = ssh_user 
      # Could modify code to look for environmental variable 'PRIVATE_KEY_PATH'
      #override.ssh.private_key_path = '~/.ssh/NorthernCaliforniaKeyPairName.pem'
      override.ssh.private_key_path = '~/.ssh/oregon.pem'
      config.vm.synced_folder "../data", "/vagrant/data", type: "rsync"
#        rsync__exclude: [ ".git/", "tools/", "private/", ".gitignore", ".gitmodules", ".vagrant/"] 
# Got an error message when there were not any tags so add some dummy tags.
      aws.tags = {
        'MOOC' => 'iversity',
        'Course' => 'Web Engineering III'
      }
    end
  end
end
