rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

auth_config = YAML.load_file(rails_root + '/config/auth_basic.yml')

Dropboxr::Application.config.auth_area_name = auth_config['area_name']
Dropboxr::Application.config.auth_username = auth_config['username']
Dropboxr::Application.config.auth_password = auth_config['password']
