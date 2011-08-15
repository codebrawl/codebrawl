set :user, 'staging'
set :branch, 'develop'
set :deploy_to, '/home/staging'
set :rails_env, 'staging'

namespace :deploy do
  desc 'Symlink app/blog'
  task :symlink_blog, :roles => :app do
    run "ln -s /home/codebrawl/shared/blog #{current_release}/app/blog"
  end
end