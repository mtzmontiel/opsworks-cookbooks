node[:deploy].each do |app_name, deploy|
	Dir["#{deploy[:deploy_to]}/current/*.sql"].each do |path|
		execute "run_sql_#{path}" do
			command "/usr/bin/mysql -h #{deploy[:database][:host]} -u #{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]} < #{path}"
		end
	end
end
