#require 'database'
#
#
#mysql_connection_info = {
#  :host     => deploy[:database][:host],
#  :username => deploy[:database][:username],
#  :password => deploy[:database][:password]
#}

# Import Wordpress database backup from file if it exists
mysql_command = "/usr/bin/mysql -h #{deploy[:database][:host]} -u #{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]}"

Chef::Log.info("Importing Wordpress database backup: #{deploy[:deploy_to]}/current/*.sql")
Dir["#{deploy[:deploy_to]}/current/*.sql"].each do |path|
#	mysql_database "#{deploy[:database][:database]}" do
#		connection mysql_connection_info
#		sql "source #{path};"
#	end
	execute "run_sql_#{path}" do
		command "#{mysql_command} < #{path}"
	end
end

# Chef::Log.info("Removing sql files")
# Dir["#{deploy[:deploy_to]}/current/*.sql"].each do |path|
#  execute "rm_#{path}" do
#	command "rm -v #{path}"
#  end
# end
