# AWS OpsWorks Recipe for RDS that creates snapshots.
# - Creates a snapshot of associated RDS instances

Chef::Log.info("Creating snapshot for: #{node['clipmx']['rds']['instancename']}")

Chef::Log.info("Importing Wordpress database backup...")
Chef::Log.info("aws rds create-db-snapshot \
			--region=#{node['clipmx']['rds']['region']} \
			--db-snapshot-identifier=#{node['clipmx']['rds']['instancename']}-$(date +%Y-%m-%d-%H-%M-%S) \
			--db-instance-identifier=#{node['clipmx']['rds']['instancename']}")
			
script "create_snapshot" do
	interpreter "bash"
	
	
	code <<-EOH
		aws rds create-db-snapshot \
			--region=#{node['clipmx']['rds']['region']} \
			--db-snapshot-identifier=#{node['clipmx']['rds']['instancename']}-$(date +%Y-%m-%d-%H-%M-%S) \
			--db-instance-identifier=#{node['clipmx']['rds']['instancename']} \
			--profile rmm
	EOH
end
