require 'resque/server'

require 'resque-cleaner'

require 'resque/job_with_status'
require 'resque/status_server'

require 'resque/failure/airbrake'

rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

# Redis
resque_config = YAML.load_file(rails_root + '/config/resque.yml')

begin
  # redis = Redis.connect(:url => resque_config[rails_env], :thread_safe => true)
  # redis.inspect
  Resque.redis = resque_config[rails_env]
  Resque.info
rescue Errno::ECONNREFUSED => e
  puts "No connection possible Redis server in #{rails_env} environment. Switching to 'inline' mode."

  Resque.inline = true
end

# Failure Backends Setup
Resque::Failure::Airbrake.configure do |config|
  config.api_key = Airbrake.configuration.api_key
end
