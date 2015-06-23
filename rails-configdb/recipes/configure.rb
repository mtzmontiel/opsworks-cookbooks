# Create the Wordpress config file database.yml with corresponding values
node[:deploy].each do |app_name, deploy|
	Chef::Log.info("Create database config file")
    template "#{deploy[:deploy_to]}/current/config/database.yml" do
        source "database.erb"
        mode 0660
        group deploy[:group]

        if platform?("ubuntu")
          owner "www-data"
        elsif platform?("amazon")
          owner "apache"
        end
    end
end
