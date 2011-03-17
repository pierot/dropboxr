use Rack::Session::Pool

configure :development do
  disable :run
end

configure do
  set :root, File.join(File.dirname(__FILE__), '..')
  set :cache_data, File.join(File.dirname(__FILE__), '../db/data')
  
  # Settings
  app_vars = YAML.load File.read('config/dev-vars.yml')
  
  dropbox_app_secret = app_vars['secret']
  dropbox_app_key = app_vars['key']
  
  set :auth_login, app_vars['login']
  set :auth_pass, app_vars['pass']
  
  # Mime Types
  mime_type :ttf, 'font/ttf'
  mime_type :woff, 'font/woff'
  mime_type :eot, 'font/eot'
  mime_type :manifest, 'text/cache-manifest'
  mime_type :less, 'text/plain'
  
  # Config files
  albums_excludes = YAML.load File.read('config/excludes.yml')
  
  # Sinatra config variables
  set :album_excludes => albums_excludes
  
  # Dropboxr
  set :dpc => Dropboxr::Connector.new('config/dropbox-session-keys.yml', dropbox_app_secret, dropbox_app_key)

  settings.dpc.directory_excludes = albums_excludes
end