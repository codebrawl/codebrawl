$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require 'bundler/capistrano'

set :application, "codebrawl"
set :repository,  "git@github.com:jeffkreeftmeijer/codebrawl.git"

set :scm, :git
set :branch, "develop"
set :ssh_options, { :forward_agent => true }

role :web, "204.62.15.57"
role :app, "204.62.15.57"
set :user, "codebrawl"
set :use_sudo, false
set :deploy_to, "/home/codebrawl"
set :rvm_ruby_string, 'ruby-1.9.2'

default_run_options[:pty] = true

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

end
