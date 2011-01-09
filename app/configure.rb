use Rack::Session::Pool

configure :development do
  disable :run
  
  app_vars = YAML.load File.read('config/dev-vars.yml')
  
  ENV['DROPBOX_APP_SECRET'] = app_vars['secret'] # local
  ENV['DROPBOX_APP_KEY'] = app_vars['key'] # local
  
  ENV['AUTH_LOGIN'] = app_vars['login'] # local
  ENV['AUTH_PASS'] = app_vars['pass'] # local
  
  ENV['GMAIL_USER'] = app_vars['gmail_email']
  ENV['GMAIL_PASSWORD'] = app_vars['gmail_pass']
end

configure do
  set :root, File.join(File.dirname(__FILE__), '..')
  
  # Global constants
  set :cache => Memcached.new
  
  # Mime Types
  mime_type :ttf, 'font/ttf'
  mime_type :woff, 'font/woff'
  mime_type :eot, 'font/eot'
  mime_type :manifest, 'text/cache-manifest'
  mime_type :less, 'text/plain'
  
  # Config files
  albums_excludes = YAML.load File.read('config/excludes.yml')
  session_keys = YAML.load File.read('config/dropbox-session-keys.yml')
  
  # Sinatra config variables
  set :mc_img => 'img_ss_'
  set :album_excludes => albums_excludes
  
  # Dropboxr
  set :dpc => Dropboxr::Connector.new(session_keys, ENV['DROPBOX_APP_SECRET'], ENV['DROPBOX_APP_KEY'])
  
  settings.dpc.redirect_url = @base_url
  settings.dpc.directory_excludes = albums_excludes
end

configure :staging do
  cache = nil # no caching available
end