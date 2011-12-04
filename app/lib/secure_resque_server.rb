require 'resque/server'

class SecureResqueServer < Resque::Server
  use Rack::Auth::Basic, Dropboxr::Application.config.auth_area_name do |username, password|
    [username, password] == [Dropboxr::Application.config.auth_username, Dropboxr::Application.config.auth_password]
  end
end
