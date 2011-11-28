source 'http://rubygems.org'

gem 'rails', '3.1.1'

gem 'friendly_id', '~> 4.0.0.beta14', :require => "friendly_id"
gem 'dropbox' 

gem 'jquery-rails'
gem 'haml'

gem 'thin'
gem 'sqlite3'

gem 'aws-s3', :require => 'aws/s3'
gem 'paperclip'

gem 'resque'
gem 'resque-status'

gem 'airbrake'

gem 'capistrano'
gem 'capistrano_colors'

gem 'foreman'

group :assets do
  gem 'coffee-rails', "~> 3.1.1"
  gem 'uglifier'
  gem 'less'
end

group :production do
  gem 'therubyracer'
  gem 'mysql'
end

group :test, :development do
  gem 'rspec-rails'
end

group :test do
  gem 'turn', :require => false
end
