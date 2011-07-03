$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require 'bundler/capistrano'

set :application, "codebrawl"
set :repository,  "git@github.com:codebrawl/codebrawl.git"

set :scm, :git
set :branch, "master"
set :ssh_options, { :forward_agent => true }

role :web, "204.62.15.57"
role :app, "204.62.15.57"
set :user, "codebrawl"
set :use_sudo, false
set :deploy_to, "/home/codebrawl"
set :rvm_ruby_string, 'ruby-1.9.2'

default_run_options[:pty] = true

before 'deploy:symlink', 'deploy:assets'
after 'deploy:update_code', 'deploy:symlink_settings'
after 'deploy:update_code', 'deploy:symlink_blog'

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc 'Restart Application'
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Compile asets"
  task :assets do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end

  desc 'Symlink the settings file'
  task :symlink_settings, :roles => :app do
    run "ln -s #{shared_path}/codebrawl.yml #{current_release}/config/codebrawl.yml"
  end

  desc 'Symlink app/blog'
  task :symlink_blog, :roles => :app do
    run "ln -s #{shared_path}/blog #{current_release}/app/blog"
  end

end
