execute "create_db" do
			command "/usr/bin/mysql --verbose -h #{node[:deploy][:database][:host]} -u #{node[:deploy][:database][:username]} -p#{node[:deploy][:database][:password]} #{node[:deploy][:database][:database]} < `echo create #{node[:deploy][:database][:database]}` > /tmp/out.tmp"
			not_if "echo \"/* ping */ SELECT 1\" | /usr/bin/mysql --verbose -h #{node[:deploy][:database][:host]} -u #{node[:deploy][:database][:username]} -p#{node[:deploy][:database][:password]} #{node[:deploy][:database][:database]}" 
		end

node[:deploy].each do |app_name, deploy|
	Dir["#{node[:deploy][:deploy_to]}/current/*.sql"].each do |path|
		execute "run_sql_#{path}" do
			command "echo \"/* ping */ SELECT 1\" | /usr/bin/mysql --verbose -h #{node[:deploy][:database][:host]} -u #{node[:deploy][:database][:username]} -p#{node[:deploy][:database][:password]} #{node[:deploy][:database][:database]} < #{path} | tee /tmp/out.tmp"
		end
	end
end
