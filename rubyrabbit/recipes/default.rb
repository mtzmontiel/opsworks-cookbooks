node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  env_hash = { 'RAILS_ENV' => rails_env }
  deploy[:environment_variables].each { |key, value| env_hash[key] = value }
  Chef::Log.info("Starting Rails rabbit worker with environment #{rails_env}")
  
  cookbook_file "/tmp/bunny_worker.sh" do
    source "bunny_worker.sh"
    mode 0755
  end
  
  execute 'rake rabit_worker' do
    cwd current_path
    user 'deploy'
    environment env_hash
    command '/tmp/bunny_worker.sh'
  end
end
