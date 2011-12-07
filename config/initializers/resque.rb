require 'resque/server'

require 'resque-cleaner'

require 'resque/job_with_status'
require 'resque/status_server'

require 'resque/failure/airbrake'

rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

# Redis
resque_config = YAML.load_file(rails_root + '/config/resque.yml')
Resque.redis = resque_config[rails_env]

# Failure Backends Setup
Resque::Failure::Airbrake.configure do |config|
  config.api_key = Airbrake.configuration.api_key
end
