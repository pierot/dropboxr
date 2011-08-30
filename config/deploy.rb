$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano_colors'

set :application, 'dropboxr'
set :repository,  'git@github.com:pierot/dropboxr.git'
set :domain,      'tortuga'
set :user,        'pirate'
set :deploy_to,   '/srv/www/noort.be/domains/dropboxr.noort.be/'

role :web, domain
role :app, domain
role :db, domain, :primary => true

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# set :rvm_ruby_string,       'ruby-1.9.2-head@rails31'
# set :rvm_type,              :system
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

  # after "deploy:finalize_update", "uploads:symlink"

  after 'deploy:update_code' do
    run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
  end

  # on :start, "uploads:register_dirs"
end

namespace :uploads do
  # desc <<-EOD
  #   Creates the upload folders unless the exist
  #   and sets the proper upload permissions.
  # EOD
  # task :setup, :except => { :no_release => true } do
  #   dirs = db_dirs.map { |d| File.join(shared_path, d) }
  #   run "#{sudo} mkdir -p #{dirs.join(' ')} && #{sudo} chmod g+w #{dirs.join(' ')}"
  # end

  #   [internal] Creates the symlink to uploads shared folder
  #   for the most recently deployed version.
  # EOD
  # task :symlink, :except => { :no_release => true } do
  #   run "rm -rf #{release_path}/db"
  #   run "ln -nfs #{shared_path}/db #{release_path}/db"
  # end

  # desc <<-EOD
  #   [internal] Computes dirs and registers them
  #   in Capistrano environment.
  # EOD
  # task :register_dirs do
  #   set :db_dirs, %w(db db/data)
  #   set :shared_children, fetch(:shared_children) + fetch(:db_dirs)

  #   uploads.setup
  # end
end
