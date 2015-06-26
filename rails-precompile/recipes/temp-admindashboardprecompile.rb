node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  Chef::Log.info("Precompiling Rails assets with environment #{rails_env}")

  execute 'rake assets:precompile' do
    cwd current_path
    user 'deploy'
    command 'bundle exec rake assets:precompile'
    environment(
    'RAILS_ENV' => rails_env,
    'PAYPAL_LOGIN' => deploy[:environment_variables][:PAYPAL_LOGIN],
    'PAYPAL_PASSWD' => deploy[:environment_variables][:PAYPAL_PASSWD],
    'PAYPAL_SIGN' => deploy[:environment_variables][:PAYPAL_SIGN],
    'RUBYOPT' => deploy[:environment_variables][:RUBYOPT],
    'RACK_ENV' => deploy[:environment_variables][:RACK_ENV],
    'HOME' => deploy[:environment_variables][:HOME],
    'BUNDLE_PATH' => deploy[:environment_variables][:BUNDLE_PATH],
    'BUNDLE_WITHOUT' => deploy[:environment_variables][:BUNDLE_WITHOUT],
    'GOOGLE_MAP_API_KEY' => deploy[:environment_variables][:GOOGLE_MAP_API_KEY],
    'INTERNAL_API_BASE_URI' => deploy[:environment_variables][:INTERNAL_API_BASE_URI],
    'MERCHANT_DASHBOARD_BASE_URI' => deploy[:environment_variables][:MERCHANT_DASHBOARD_BASE_URI],
    'AWS_S3_BUCKET_NAME' => deploy[:environment_variables][:AWS_S3_BUCKET_NAME],
    'RABBITMQ_URL' => deploy[:environment_variables][:RABBITMQ_URL],
    'SIGNATURES_PATH' => deploy[:environment_variables][:SIGNATURES_PATH],
    'SIGNATURES_S3_BUCKET' => deploy[:environment_variables][:SIGNATURES_S3_BUCKET],
    'RDS_DB_NAME' => deploy[:environment_variables][:RDS_DB_NAME],
    'RDS_PORT' => deploy[:environment_variables][:RDS_PORT],
    'RDS_USERNAME' => deploy[:environment_variables][:RDS_USERNAME],
    'RDS_PASSWORD' => deploy[:environment_variables][:RDS_PASSWORD],
    'RDS_HOST' => deploy[:environment_variables][:RDS_HOST],
    'RDS_ADAPTER' => deploy[:environment_variables][:RDS_ADAPTER],
    'MONGO_DB' => deploy[:environment_variables][:MONGO_DB],
    'MONGO_HOST' => deploy[:environment_variables][:MONGO_HOST],
    'MONGO_PORT' => deploy[:environment_variables][:MONGO_PORT],
    'MONGO_USERNAME' => deploy[:environment_variables][:MONGO_USERNAME],
    'MONGO_PASSWORD' => deploy[:environment_variables][:MONGO_PASSWORD],
    'AWS_ACCESS_KEY_ID' => deploy[:environment_variables][:AWS_ACCESS_KEY_ID],
    'AWS_SECRET_KEY' => deploy[:environment_variables][:AWS_SECRET_KEY]
    )
  end
end
