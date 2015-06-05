# AWS OpsWorks Recipe for RDS that creates snapshots.
# - Creates a snapshot of associated RDS instances

Chef::Log.info("Creating snapshot for: #{node['clipmx']['rds']['instancename']}")
			
script "create_snapshot" do
	interpreter "bash"
	
	
	code <<-EOH
		[ ! -d ~/.aws ] && mkdir ~/.aws
		echo [default] > ~/.aws/config 
		echo [profile rmm] >> ~/.aws/config
		echo [rmm] > ~/.aws/credentials
		echo aws_access_key_id=#{node['clipmx']['rds']['key']} >> ~/.aws/credentials
		echo aws_secret_access_key=#{node['clipmx']['rds']['secret']} >> ~/.aws/credentials
		aws rds create-db-snapshot \
			--region=#{node['clipmx']['rds']['region']} \
			--db-snapshot-identifier=#{node['clipmx']['rds']['instancename']}-$(date +%Y-%m-%d-%H-%M-%S) \
			--db-instance-identifier=#{node['clipmx']['rds']['instancename']} \
			--profile rmm --tags Key=Reason,Value=ChefRecipeRDSSnapshot
	EOH
end
