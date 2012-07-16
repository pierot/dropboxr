source 'http://rubygems.org'

gem 'rails', '3.2.2'

gem 'friendly_id', '~> 4.0.0.beta14', :require => "friendly_id"

gem 'jquery-rails'
gem 'haml'

gem 'thin'
gem 'sqlite3'

gem 'aws-sdk'
gem 'aws-s3', :require => 'aws/s3'
gem 'paperclip', '~> 3.0'

gem 'resque'
gem 'resque-status'
gem 'resque-cleaner'

gem 'airbrake'

gem 'capistrano'
gem 'rvm-capistrano'
gem 'capistrano_colors'

gem 'foreman'

gem 'mime-types', '>= 1.18'

group :assets do
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'yui-compressor'
  gem 'less'
end

group :production do
  gem 'therubyracer', '= 0.9.9'
  gem 'mysql'
end

group :test, :development do
  gem 'rspec-rails'
end

group :test do
  gem 'turn', :require => false
end
