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
         then echo "Removing process: " $RABBIT_PROC | tee -a ./log/bunny_worker.stop
            kill $RABBIT_PROC
          done
      else echo "No bunny_worker process. nothing to kill." $RABBIT_PROC " ." | tee -a ./log/bunny_worker.stop
      fi
      nohup bundle exec rake bunny_worker > ./log/bunny_worker.log &
      echo "Done starting up bunny_worker" $(date) >> ./log/bunny_worker.start
    EOF
    environment env_hash
  end
end
