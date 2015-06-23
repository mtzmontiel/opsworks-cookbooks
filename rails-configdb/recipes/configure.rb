# Create the Wordpress config file database.yml with corresponding values
node[:deploy].each do |app_name, deploy|
	Chef::Log.info("Create database config file")
    template "#{deploy[:deploy_to]}/shared/config/database.yml" do
		source "database.yml.erb"
		cookbook 'rails'
		mode "0660"
		group deploy[:group]
		owner deploy[:user]
		notifies :run, "execute[restart Rails app #{application}]"
		only_if do
		  File.directory?("#{deploy[:deploy_to]}/shared/config/")
		end
	end
end
