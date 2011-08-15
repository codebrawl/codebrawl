set :user, 'codebrawl'
set :branch, 'master'
set :deploy_to, '/home/codebrawl'
set :rails_env, 'production'

namespace :deploy do
  desc 'Symlink app/blog'
  task :symlink_blog, :roles => :app do
    run "ln -s #{shared_path}/blog #{current_release}/app/blog"
  end
end
