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
end
