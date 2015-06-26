node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  env_hash = { 'RAILS_ENV' => rails_env }
  deploy[:environment_variables].each { |key, value| env_hash[key] = value }
  Chef::Log.info("Starting Rails rabbit worker with environment #{rails_env}")
  execute 'rake rabit_worker' do
    cwd current_path
    user 'deploy'
    command <<-EOF
      # Retrieve process id for bunny_worker
      RABBIT_PROC=` ps aux | grep bunny_worker | awk '{print $2}' `
      if [ $? -eq 0 ]
         then echo "Removing process: " $RABBIT_PROC 
      else echo "No bunny_worker process. nothing to kill." $RABBIT_PROC " ."
      fi
      nohup bundle exec rake bunny_worker > /var/log/bunny_worker.log &
    EOF
    environment env_hash
  end
end
