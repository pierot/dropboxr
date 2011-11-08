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

# set :rvm_ruby_string,       'ruby-1.9.2-head@rails31'
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

  after "deploy:finalize_update", "db:symlink"
  before "deploy:migrate", "db:setup"

  # after 'deploy:update_code' do
  #   run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
  # end
end

namespace :db do
  task :symlink, :except => { :no_release => true } do
    run "mkdir -p #{shared_path}/db"
  end

  task :setup do
    run "cd #{release_path}; RALS_ENV=production bundle exec rake db:create"
  end
end
