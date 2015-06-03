# AWS OpsWorks Recipe for mysql backup
# - Backups 

# Backup existing database 
node[:deploy].each do |app_name, deploy|
	Chef::Log.info("Backup current Wordpress database")
	script "mysql_backup" do
		interpreter "bash"
		user "root"
		cwd node['rdsbackup']['storage']
		code <<-EOH
			/usr/bin/mysqldump -h #{deploy[:database][:host]} -u #{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]} \
				| gzip \
				> #{deploy[:database][:database]}_$(date +%Y-%m-%d-%H-%M-%S).dmp.gz
		EOH
	end
end
