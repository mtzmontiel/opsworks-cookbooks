node[:deploy].each do |app_name, deploy|
	execute "create_db" do
				command "echo \"create #{deploy[:database][:database]};\" | /usr/bin/mysql --verbose -h #{deploy[:database][:host]} -u #{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]}  | tee  /tmp/create.db.log"
				not_if "echo \"/* ping */ SELECT 1\" | /usr/bin/mysql --verbose -h #{deploy[:database][:host]} -u #{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]}" 
			end

	node[:deploy].each do |app_name, deploy|
		Dir["#{deploy[:deploy_to]}/current/*.sql"].each do |path|
			execute "run_sql_#{path}" do
				command "/usr/bin/mysql --verbose -h #{deploy[:database][:host]} -u #{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]} < #{path} | tee /tmp/import.db.log"
			end
		end
	end
	# Update siteurl and home
	node[:deploy].each do |app_name, deploy|
		execute "set_siteurl" do
			command "echo \"update wp_options set option_value='#{node['wordpress']['wp_config']['siteurl']}' where option_id= 1 and option_name='siteurl';\" | /usr/bin/mysql --verbose -h #{deploy[:database][:host]} -u #{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]} | tee /tmp/import.db.log"
		end
		execute "set_sitehome" do
			command "echo \"update wp_options set option_value='#{node['wordpress']['wp_config']['sitehome']}' where option_id= 2 and option_name='home';\" | /usr/bin/mysql --verbose -h #{deploy[:database][:host]} -u #{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]} | tee /tmp/import.db.log"
		end
	end
end
