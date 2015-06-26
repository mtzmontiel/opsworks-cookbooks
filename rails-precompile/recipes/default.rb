node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  env_hash = { 'RAILS_ENV' => rails_env }
  deploy[:environment_variables].each { |key, value| env_hash[key] = value }
  Chef::Log.info("Precompiling Rails assets with environment #{rails_env}")
  execute 'rake assets:precompile' do
    cwd current_path
    user 'deploy'
    command 'bundle exec rake assets:precompile'
    environment env_hash
  end
end
