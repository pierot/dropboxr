$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano_colors'

set :application, 'dropboxr'
set :repository,  'git@github.com:pierot/dropboxr.git'
set :domain,      'tortuga'
set :deploy_to,   '/srv/www/fotos.noort.be/'

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
    run "#{sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  task :start, :roles => :app, :except => { :no_release => true } do
    run "#{sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  after "deploy:finalize_update", "db:shared_db"
  after "deploy:finalize_update", "db:temp"

  before "deploy:migrate", "db:setup"

  after "deploy", "db:temp"
  after "deploy:migrations", "db:temp"

  after 'deploy:update_code' do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end
end

namespace :db do
  task :shared_db, :except => { :no_release => true } do
    run "mkdir -p #{shared_path}/db"
  end

  task :setup do
    run "cd #{current_path}; RALS_ENV=production bundle exec rake db:create"

    run "cd #{current_path}; chmod 755 #{current_path}/db/production.sqlite3"
  end

  task :temp do
    run "cd #{current_path}; chown -R nobody #{current_path}/db"

    run "chmod 755 #{shared_path}/db/production.sqlite3"
    run "chown -R nobody #{shared_path}/db"
  end
end
