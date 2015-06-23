# Create the Wordpress config file database.yml with corresponding values
node[:deploy].each do |app_name, deploy|
	Chef::Log.info("Linking database config file")
	link "#{deploy[:deploy_to]}/current/config/database.yml" do
	  to "#{deploy[:deploy_to]}/shared/config/database.yml"
	end
end
