# AWS OpsWorks Recipe for RDS that creates snapshots.
# - Creates a snapshot of associated RDS instances

Chef::Log.info(node[:opsworks][:layers]['dev-test02'][:id])
