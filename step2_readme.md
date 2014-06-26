Add rvm (ruby version manager), ruby, listen gem, and puppet to the guest.

After bringing up the system, the command

free -h

shows only about 32 MB free.

However if you reboot the system ( vagrant halt ;  look at console.aws.amazon.com that EC2 instance is stopped ; vagrant up

    Now you should see with

    free -h

    about 450 MB free.
