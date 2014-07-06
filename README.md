# ARSnova Vagrant

This is a fork of [https://github.com/thm-projects/arsnova-vagrant](https://github.com/thm-projects/arsnova-vagrant) 

The thm-projects/Vagrant configuration provisioned a Debian development box with all tools required for ARSnova.

There were students in the iversity THM Web Engineering III class, who had computers with "slow" CPUs and 2 GBs
of memory. The vagrant virtual box solution was extremely slow for these students. We are talking hours to bring 
up something that was advertised to come up in minutes (perhaps if we had 4 core machines with 16 GB, we also 
would not have had any problems).

At the time of this fork, Amazon was offering a free t1.micro tier for a year. With this setup, the system was ok,
but still suffer problems probably due to memory limitations.

Then a wonderful thing happened, on or about July 1, 2014 Amazon announced a free t2.micro tier, which had 1 GB 
of memory.


## Goal

The original thm-project stated "ARSnova developers should not need to install any tools in order to get ARSnova up and running. Ideally, the only thing needed is an IDE. All other tools as well as the required workflows shall be handled by the Vagrant box."

The goal of this forked project is to supply a AWS Ubuntu t2.micro or better environment, that can be used to develop ARSnova. It is assumed that the developer will ssh into the system and then use vim to edit the files.

### Advantage of the forked project:

1. Developer doesn't need a fancy development computer with lots of memory.
2. The development system is on the Internet, so can be reached by any Internet connected computer (as long as one has ssh capabilities).
3. The builds are made with ant and maven, and the test environment can be accessed by going to:
```
http://<server_ip_address>:8080
```
4. Good way to learn about jmeter and other testing tools. The computer running jmeter is different than the system under test.
5. Learn to use vim aka vi, which is available on all Linux and UNIX systems.

### Disavantages of the forked project:
1. No GUI.
2. Can't use IDE.
3. Production (tomcat) is not currently supported, but should be available in a later release.
4. rsync does not reliabily work.
5. No listening for arsnova-mobile changes. (Implementing the listening is a CPU performance hit that could cost money).
6. No watching for arsnova-war changes. (Implementing the watching is a CPU performance hit that could cost money).
7. Don't overtest the web capabilities. The more hits the AWS instance gets, the more money it is going to cost.
## Pre-getting started

Familar yourself with the Amazon Free t2.micro tier [http://aws.amazon.com](http://aws.amazon.com)   .

Follow one of the many online tutorials and using the AWS Console bring up a Ubuntu t2.micro. 

Even though, this is advertised as a quick 20 minute process, it may take you a day to read the [AWS documentation](http://aws.amazon.com/documentation/gettingstarted/) before you feel comfortable in plunging into signing up for AWS and configuring your first instance.

Please be aware that the author(s) of the forked arsnova-vagrant and the THM author(s) of the original arsnova-vagrant take no responsibility if Amazon charges you money.

It is important to keep your eye on the AWS EC2 Console. It is important to understand when and why Amazon may charge you for things.

It is also expected but not necessary, that you already have had experience with the original THM arsnova-vagrant.

## Getting Started

Looking at the Vagrant file, you will see that this project makes heavy use of environmental variables.


```ruby
ENV['BUILD'] == "AWS"  
aws.access_key_id = ENV['AWS_ACCESS_KEY'] 
aws.secret_access_key = ENV['AWS_SECRET_KEY'] 
# Could modify code to look for environmental variable 'AWS_SECURITY_GROUPS'
# Could modify code to look for environmental variable 'PRIVATE_KEY_PATH'
```

If you are on a Mac, you could create a new file ~/.aws_profile 

The .aws_profile would look like something like this:

```bash
echo ".aws_profile is called"
function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
 
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
NO_COLOR="\[\033[0m\]"
 
PS1="$GREEN\u@\h$NO_COLOR:\w$YELLOW\$(parse_git_branch)$NO_COLOR\$ "

export AWS_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXX
export AWS_SECRET_KEY=123456789XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
export BUILD=AWS
```

Then in your ~/.bash_profile add this line:

```bash
source  ~/.aws_profile
```


This repository comes with several Git submodules. These can be automatically checked out while cloning by providing the `--recursive` flag:

```bash
$	git clone --recursive https://github.com/thm-projects/arsnova-vagrant.git
```

Alternatively, initialize and update the submodules after cloning:

```bash
$	git submodule update --init --recursive
```

## Basic Usage
### The very first time, start the machine with:
(Note: that the last line of setup.sh does the normal vagrant up with logging. The setup.sh also does some other things so you might want to take a look at it.)

```bash
$ ./setup.sh
```

~~Start the machine with the following command:~~

~~$ vagrant up dev~~

This will create a completely configured VM. Running this the first time will download and install all required packages. Depending on your internet connection this operation will take some time. Once the machine is up and running, you can connect with:

```bash
$ vagrant ssh
```

Then, in order to start ARSnova, type:

```bash
$ ./start.sh
```

This will build and start ARSnova.

To find out the server_ip either go to AWS Console and click on the connect tab or do:

```bash
$ vagrant ssh-config
```

You can now visit http://<server_ip>:8080/index.html in your browser.

Finally, if you want to stop ARSnova, use this command:

```bash
$ ./stop.sh
```

<!---
### Testing for production

The machine's default environment is for development. If you are happy with your changes in development mode, you may wish to test them in a more realistic environment. For creating a production-like environment, type:

```bash
$ vagrant up production
```

All commands remain the same, e.g., use `./start.sh` on the machine. But make sure you append the word `production` to all vagrant commands.

*Note:* In contrast to the development machine all changes have to be manually redeployed to Tomcat in the production environment. To do this, run `mvn tomcat7:deploy` in the `arsnova-war` directory.

-->
## ARSnova repositories

After the first boot of your VM, you will find the following repositories inside this project's root folder:

```bash

ubuntu@ip-172-31-0-168:~$ cd /vagrant
ubuntu@ip-172-31-0-168:/vagrant$ ls -l
total 88
drwxr-xr-x 5 ubuntu ubuntu  4096 Jun 20 01:00 arsnova-mobile
drwxr-xr-x 4 ubuntu ubuntu  4096 Jun 20 01:00 arsnova-setuptool
drwxr-xr-x 5 ubuntu ubuntu  4096 Jul  6 02:43 arsnova-war
```

~~The ARSnova repositories are connected to your host machine via shared folders. This means you can use your local IDE of choice to work on the code, while the complete build process is handled by the Vagrant VM.~~

~~Whenever you make changes to the `arsnova-mobile` repository, a new build is triggered automatically after a few seconds, so that you can immediately see the result of your changes.~~

Changes to `arsnova-mobile` and `arsnova-war` have to be compiled manually.

Note: The original THM implementation had shared folders. This do not work with AWS. There is a [vagrant-aws project](https://github.com/mitchellh/vagrant-aws) that is trying to get rsync to reliablely work.

## Setting up your Git

You may want to change the Git remotes because the default `origin` is set to a read-only URL. It is preferred to keep the current `origin` repository as a means to stay in sync with the other ARSnova developers. This is usually called the "upstream." Hence, you may want to rename `origin` to `upstream`:

```bash
$ git remote rename origin upstream
$ git remote add origin <your repository>
```

Don't forget to set your `master` branch to the new remote:

```bash
$ git fetch origin
$ git branch -u origin/master
```

## Ports

The following ports are used on the host machine:

### Development

- 8080 (Web)
- 10443 (socket.io)
- 5984 (CouchDB)

<!---
### Production

- 8081 (Web)
- 10444 (socket.io)
- 5985 (CouchDB)

## Using the GUI

If you wish to use the window manager [Xfce](http://www.xfce.org), you first need to shutdown your machine in case it is currently running. Use `vagrant halt` for this purpose. Then, edit the `Vagrantfile` and activate the GUI option:

	config.vm.provider "virtualbox" do |vb|
		vb.gui = true
	end

Once you restart the VM, log in with Vagrant's default credentials: user and password are both `vagrant`. Finally, the GUI is started by entering:

	startx

-->
## Contributing

Please refer to the [CONTRIBUTING.md](CONTRIBUTING.md) document.

## Troubleshooting

### I'm missing some files.

If files like `start.sh` are missing, it is most likely that the provisioning has failed. Run

```bash
$ vagrant provision
```

which will make sure all packages and scripts are present. Also, you could just destroy the machine

```bash
$ vagrant destroy 
```

to return to a blank slate, but be sure to check AWS Console that your AWS instance has been destroyed.)

### Script `start.sh` never returns.

The first time this script runs it will take quite some time because Maven has to download a lot of dependencies. To see if an error occurs, run `./start.sh -v` which displays Ant's and Maven's verbose outputs.

### Can't ssh.

Set your inbound security group to:
Type: all traffic
Protocol: all
Port Range: all
Security: 0.0.0.0/0     (This is the setting that is probably fouling you up.)

### Web browser doesn't recognize address.

Make sure that you know the IP address of your webserver.
```bash
$ vagrant ssh-config
```

For dev do:

```
http://<ip_address_of_server>:8080
```

Do not do:

```
http://localhost:8080
```

## Credits

ARSnova is powered by THM - Technische Hochschule Mittelhessen - University of Applied Sciences.

Port to AWS by Jim Oser, [oserj@oserconsulting.com](mailto:oserj@oserconsulting.com)
