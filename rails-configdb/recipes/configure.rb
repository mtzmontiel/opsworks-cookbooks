# Create the Wordpress config file database.yml with corresponding values
node[:deploy].each do |app_name, deploy|
	Chef::Log.info("Create database config file")
    template "#{deploy[:deploy_to]}/shared/config/database.yml" do
		source "database.yml.erb"
		cookbook 'rails-configdb'
		mode "0660"
		group deploy[:group]
		owner deploy[:user]
		variables(
			:database => deploy[:environment_variables][:RDS_DB_NAME],
			:port => deploy[:environment_variables][:RDS_PORT],
			:host => deploy[:environment_variables][:RDS_HOST],
			:username => deploy[:environment_variables][:RDS_USERNAME],
			:password => deploy[:environment_variables][:RDS_PASSWORD],
			:environment => deploy[:rails_env])
		only_if do
		  File.directory?("#{deploy[:deploy_to]}/shared/config/")
		end
	end
	
	mysql_chef_gem 'default' do
	  action :install
	end
end
