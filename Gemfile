source 'http://rubygems.org'

gem 'rails', '3.1.1'

gem 'friendly_id', '~> 4.0.0.beta14', :require => "friendly_id"
gem 'dropbox' 

gem 'haml'

gem 'thin'
gem 'sqlite3'

gem 'aws-s3', :require => 'aws/s3'
gem 'paperclip'

gem 'resque'
gem 'resque-status'

gem "airbrake"

gem 'foreman'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', "~> 3.1.1"
  gem 'uglifier'
  gem 'less'
end

gem 'jquery-rails'

group :production do
  gem 'therubyracer'
  # gem 'pg'
  gem 'mysql'
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano_colors'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test, :development do
  gem 'rspec-rails'
  # gem 'sqlite3'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
