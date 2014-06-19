# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
#  config.vm.box = "base"
  config.vm.box = "dummy"
  config.ssh.username = "ubuntu"
  config.vm.provision :shell, path: "bootstrap.sh"
  # install rvm per http://rvm.io/integration/vagrant
  config.vm.provision :shell, :path => "install-rvm.sh",  :args => "stable"
  config.vm.provision :shell, :path => "install-ruby.sh", :args => "1.9.3"
  config.vm.provision :shell, :path => "install-ruby.sh", :args => "1.9.3 listen"
  config.vm.provision :shell, :path => "install-puppet.sh"

  # install puppet
# rsync doesn't work as advertised; can't exclude directories"
#  config.vm.synced_folder ".", "/vagrant", type: "rsync",
#      rsync__exclude: [ ".git/", "tools/", "private/", ".gitignore", ".gitmodules", ".vagrant/"] 

# Keep things really simple, what I want to share put in ../data
  config.vm.synced_folder "../data", "/vagrant", type: "rsync",
      rsync__exclude: [ ".git/", "tools/", "private/", ".gitignore", ".gitmodules", ".vagrant/"] 
  config.vm.provider :aws do |aws, override|
    # from the iam  csv file
    # but stored in  ~/.aws_profile
    # as environmental variables
#   # export AWS_ACCESS_KEY = "<your access key >"
#   # export AWS_SECRET_KEY = "<your secret key >"
    aws.access_key_id = ENV['AWS_ACCESS_KEY'] 
    aws.secret_access_key = ENV['AWS_SECRET_KEY'] 
    # key pair
    aws.keypair_name = "NorthernCaliforniaKeyPairName"
#   N. California
#   Ubuntu Server 14.04 LTS (PV) - ami-ee4f77ab (64-bit) / ami-ec4f77a9 (32-bit) 
    aws.ami = "ami-ee4f77ab"
    aws.instance_type = 't1.micro'
    aws.security_groups = [ "myvagrantsecuritygroup" ]
    aws.region= 'us-west-1'

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = '/Users/oserj/Documents/Amazon/NorthernCaliforniaKeyPairName.pem'
#    override.vm.box = "dummy"
#    override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
  end
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
  end
#  config.vm.define "production", autostart: false do |production|
#    production.vm.hostname = "arsnova-production"
#    production.vm.provision "puppet" do |puppet|
#      puppet.manifests_path = pp_manifest_path
#      puppet.manifest_file = pp_manifest_file
#      puppet.module_path = pp_module_path
#      puppet.options = "--environment=production"
#    end
#    production.vm.network "forwarded_port", guest: 8080, host: 8081
#    # socket.io port
#    production.vm.network "forwarded_port", guest: 10444, host: 10444
#    # CouchDB
#    production.vm.network "forwarded_port", guest: 5984, host: 5985
#  end
end
