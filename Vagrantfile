# -*- mode: ruby -*- # vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
ssh_user  = "vagrant"
ssh_group = "vagrant"

def aws_build?
  ENV['BUILD'] == "AWS"  
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  if aws_build? 
    ssh_user = "ubuntu"
    ssh_group = "ubuntu"
  # See: https://github.com/mitchellh/vagrant-aws
  # Manually do on command line:
  #    $ vagrant plugin install vagrant-aws
    config.vm.box = "dummy"
  # install rvm per http://rvm.io/integration/vagrant
    config.vm.provision :shell, :path => "install-rvm.sh",  :args => "stable"
    config.vm.provision :shell, :path => "install-ruby.sh", :args => "1.9.3"
    config.vm.provision :shell, :path => "install-ruby.sh", :args => "1.9.3 listen"
    config.vm.provision :shell, :path => "install-puppet.sh"
    config.vm.provider :aws do |aws, override|
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
      config.vm.synced_folder "../data", "/vagrant", type: "rsync",
        rsync__exclude: [ ".git/", "tools/", "private/", ".gitignore", ".gitmodules", ".vagrant/", ".*"] 
    end
  else
    config.vm.box = "fadenb/debian-wheezy-puppet3"
    config.vm.synced_folder "./puppet/files", "/etc/puppet/files"
    config.vm.provider "virtualbox" do |vb|
      # Don't boot with headless mode
      # vb.gui = true
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
  end
  config.ssh.username = ssh_user

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
###  config.vm.synced_folder "./puppet/files", "/etc/puppet/files"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
###   config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
     # Use VBoxManage to customize the VM. For example to change memory:
###     vb.customize ["modifyvm", :id, "--memory", "1024"]
###   end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file fadenb/debian-wheezy-puppet3.pp in the manifests_path directory.
  #
  # An example Puppet manifest to provision the message of the day:
  #
  # # group { "puppet":
  # #   ensure => "present",
  # # }
  # #
  # # File { owner => 0, group => 0, mode => 0644 }
  # #
  # # file { '/etc/motd':
  # #   content => "Welcome to your Vagrant-built virtual machine!
  # #               Managed by Puppet.\n"
  # # }
  #
  pp_manifest_path = "puppet/manifests"
  pp_module_path = "puppet/modules"
  pp_manifest_file = "debian-wheezy.pp"

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision "chef_solo" do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision "chef_client" do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"

  config.vm.define "dev", primary: true do |dev|
    dev.vm.hostname = "arsnova-dev"
    dev.vm.provision "puppet" do |puppet|
      puppet.manifests_path = pp_manifest_path
      puppet.manifest_file = pp_manifest_file
      puppet.module_path = pp_module_path
      puppet.options = "--environment=development --verbose"
      puppet.facter = {
        "git_owner" => ssh_user, 
        "git_group" => ssh_group 
        
      }
    end
    if (aws_build? == false)
      dev.vm.network "forwarded_port", guest: 8080, host: 8080
      # socket.io port
      dev.vm.network "forwarded_port", guest: 10443, host: 10443
      # CouchDB
      dev.vm.network "forwarded_port", guest: 5984, host: 5984
    end
  end
  config.vm.define "production", autostart: false do |production|
    production.vm.hostname = "arsnova-production"
    production.vm.provision "puppet" do |puppet|
      puppet.manifests_path = pp_manifest_path
      puppet.manifest_file = pp_manifest_file
      puppet.module_path = pp_module_path
      puppet.options = ["--environment=production"]
    end
    if (aws_build? == false)
      production.vm.network "forwarded_port", guest: 80, host: 8081
      # socket.io port
      production.vm.network "forwarded_port", guest: 10444, host: 10444
      # CouchDB
      production.vm.network "forwarded_port", guest: 5984, host: 5985
    end
  end
end
