#! /usr/bin/env ruby
vagrant_log_type = "debug"
def now_string()
  year = Time.now.year
  month = Time.now.month
  day = Time.now.day 
  hour = Time.now.hour
  minute = Time.now.min
  now = "#{year}-#{month}-#{day}-#{hour}-#{minute}"
  return(now)
end
def output_file_string()
  now = now_string()
  output_file="output-#{now}.txt"
  return(output_file)
end
def new_thread(cmd)
  puts "#{Time.now} #{cmd} started"
  command = Thread.new do
    system(cmd)
  end
  command.join
  puts "#{Time.now} #{cmd} completed"
end
project_directory = "thm-projects"
project_name = "arsnova-vagrant"
repo = "https://github.com/#{project_directory}/#{project_name}.git"
=begin
new_directory = "#{project_name}-#{now_string()}" 
cmd = "git clone #{repo} #{new_directory}" 
new_thread(cmd)
=end
new_directory = "arsnova-vagrant-2014-6-7-22-28" 
Dir.chdir(new_directory) do 
  cmds= [ 
    "git submodule update --init --recursive", 
    "VAGRANT_LOG=#{vagrant_log_type} vagrant up dev --no-provision  >> #{output_file_string()} 2>&1 ",
    "VAGRANT_LOG=#{vagrant_log_type} vagrant halt dev  >> #{output_file_string()} 2>&1 ",
    "VAGRANT_LOG=#{vagrant_log_type} vagrant up dev --provision-with puppet  >> #{output_file_string()} 2>&1 ",
    "VAGRANT_LOG=#{vagrant_log_type} vagrant halt dev  >> #{output_file_string()} 2>&1 ",
    "VAGRANT_LOG=#{vagrant_log_type} vagrant up dev  >> #{output_file_string()} 2>&1 ",
    "ls -l  >> #{output_file_string()} 2>&1 ",
    "git status  >> #{output_file_string()} 2>&1 ",
    "VAGRANT_LOG=#{vagrant_log_type} vagrant ssh dev -c \"which sencha\"  >> #{output_file_string()} 2>&1 ",
    "VAGRANT_LOG=#{vagrant_log_type} vagrant ssh dev -c \"/home/vagrant/startup.sh -v\"  >> #{output_file_string()} 2>&1 ",
    "curl http://localhost:5984  >> #{output_file_string()} 2>&1 ",
    "curl http://localhost:8080  >> #{output_file_string()} 2>&1 "
  ]
  cmds.each do |cmd|
    new_thread(cmd)
  end
end
