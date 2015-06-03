# AWS OpsWorks Recipe for mysql backup
# - Backups 

# Backup existing database 
mysqldump_command = "/usr/bin/mysqldump -h #{deploy[:database][:host]} -u #{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]}"

Chef::Log.info("Backup current Wordpress database")
script "memory_swap" do
	interpreter "bash"
	user "root"
	cwd "${node[:default][:rdsbackup][:storage]}/"
	code <<-EOH
		#{mysqldump_command} | gzip > #{deploy[:database][:database]}_$(date +%Y-%m-%d-%H-%M-%S).dmp.gz
	EOH
end
