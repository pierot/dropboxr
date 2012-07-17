$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano_colors'

set :application, 'dropboxr'
set :repository,  'git@github.com:pierot/dropboxr.git'
set :branch,      'master'
set :domain,      'tortuga'
set :deploy_to,   '/srv/www/fotos.noort.be/'
set :user,        'root'
set :site_url,    'fotos.noort.be'

role :web, domain
role :app, domain
role :db, domain, :primary => true

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :rvm_type,              :system
set :use_sudo,              false
set :group_writable,        true         # Shared environment
set :keep_releases,         3             # Backup revisions
set :scm,                   :git
set :deploy_via,            :remote_cache
set :normalize_asset_timestamps, false

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
  end

  task :start, :roles => :app, :except => { :no_release => true } do
  end

  after "deploy:finalize_update", "config:symlinks"
  after "deploy:finalize_update", "config:s3"
  after "deploy:finalize_update", "config:database"
  after "deploy:finalize_update", "config:resque"
  after "deploy:finalize_update", "config:auth_basic"

  after "deploy:finalize_update", "config:temp"

  before "deploy:migrate", "db:create"

  after "deploy", "config:temp"
  after "deploy:migrations", "config:temp"

  after "deploy:update", "foreman:export"    # Export foreman scripts
  after "deploy:update", "foreman:restart"   # Restart application scripts

  after 'deploy:update_code' do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end
end

namespace :config do
  task :symlinks do
    # run "mkdir -p #{shared_path}/db"
  end

  task :auth_basic do
    copy_file 'auth_basic.yml'
  end

  task :resque do
    copy_file 'resque.yml'
  end

  task :s3 do
    copy_file 's3.yml'
  end

  task :database do
    copy_file 'database.yml'
  end

  def copy_file(file_name)
    contents = File.read("config/#{file_name}")

    put contents, "#{File.join(release_path, 'config', file_name)}"
  end

  task :temp do
    # run "chown -R nobody #{shared_path}/db"
    run "chown -R nobody #{release_path}/tmp"
  end
end

namespace :db do
  task :create do
    run "cd #{current_path}; RALS_ENV=production bundle exec rake db:create"
  end

  task :drop do
    run "cd #{current_path}; RALS_ENV=production bundle exec rake db:drop"
  end
end

# Foreman tasks
namespace :foreman do
  desc 'Export the Procfile to Ubuntu upstart scripts'
  task :export, :roles => :app do
    run "cd #{current_path} && bundle exec foreman export upstart /etc/init -a #{application} -c web=1,worker=1 -u #{user} -l #{current_path}/log/foreman"
  end

  desc "Start the application services"
  task :start, :roles => :app do
    sudo "start #{application}"
  end

  desc "Stop the application services"

  task :stop, :roles => :app do
    sudo "stop #{application}"
  end

  desc "Restart the application services"
  task :restart, :roles => :app do
    run "start #{application} || restart #{application}"
  end
end

desc "tail production log files"
task :tail_logs, :roles => :app do
  run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
    trap("INT") { puts 'Interupted'; exit 0; }
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end

desc "Varnish tasks"
namespace :varnish do
  task :purge do
    if exists?(:site_url)
      run "curl -X PURGE http://#{site_url}"
    else
      puts "`site_url` is not set in Capistrano setup. Please do so like this:\n\tset :site_url, 'domain.com'"
    end
  end
end

require './config/boot'
require 'airbrake/capistrano'
