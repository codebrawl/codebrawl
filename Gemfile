source 'http://rubygems.org'

gem 'rails', '3.1.0.rc5' # :git => 'git://github.com/rails/rails.git'

gem 'thin'

gem 'json'
gem 'haml'

gem 'compass', git: 'https://github.com/chriseppstein/compass.git', branch: 'rails31'
gem 'sass-rails'
gem 'coffee-script'
gem 'uglifier'
gem 'jquery-rails'

gem "mongoid", "~> 2.0"
gem "bson_ext", "~> 1.3"

gem 'kramdown'
gem 'mongoid_slug', :require => 'mongoid/slug'

gem 'omniauth'

gem 'gravtastic'

gem 'wufoo'
gem 'gust'

gem 'rpm_contrib'
gem 'hoptoad_notifier'

gem 'hashr'

group :test do
  gem 'rspec-rails'
  #gem 'spec_coverage', :require => false
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git', :ref => '549e6733'
  gem 'launchy'

  gem 'mocha'

  gem 'database_cleaner'

  gem 'spork', '~> 0.9.0.rc'
  gem 'watchr'

  gem 'timecop'
  gem 'fakeweb'

  gem 'fuubar'
  gem 'vcr'

  gem 'therubyracer'
end

group :development, :test do
  gem 'fabrication'
  gem 'faker'

  gem 'rack-webconsole', :git => 'git://github.com/jeffkreeftmeijer/rack-webconsole.git'
end
