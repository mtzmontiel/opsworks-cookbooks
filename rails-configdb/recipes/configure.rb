# Create the Wordpress config file database.yml with corresponding values
node[:deploy].each do |app_name, deploy|
	Chef::Log.info("WP force secure logins: #{node['wordpress']['wp_config']['force_secure_logins']}")
	Chef::Log.info("WP site url: #{node['wordpress']['wp_config']['siteurl']}")
	Chef::Log.info("WP site home: #{node['wordpress']['wp_config']['sitehome']}")
    template "#{deploy[:deploy_to]}/current/config/database.yml" do
        source "database.erb"
        mode 0660
        group deploy[:group]

        if platform?("ubuntu")
          owner "www-data"
        elsif platform?("amazon")
          owner "apache"
        end

        variables(
            :database   => (deploy[:database][:database] rescue nil),
            :user       => (deploy[:database][:username] rescue nil),
            :password   => (deploy[:database][:password] rescue nil),
            :host       => (deploy[:database][:host] rescue nil),
            :keys       => (keys rescue nil),
            :siteurl    => (node['wordpress']['wp_config']['siteurl'] rescue nil),
            :sitehome   => (node['wordpress']['wp_config']['sitehome'] rescue nil),
        )
    end
end
