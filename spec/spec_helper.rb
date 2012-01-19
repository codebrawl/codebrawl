require 'spork'
require 'database_cleaner'
require 'fabrication'
require 'faker'
require 'timecop'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  require "rails/mongoid"
  Spork.trap_class_method(Rails::Mongoid, :load_models)

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'spec_config'

  require 'shoulda-matchers'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.include Shoulda::Matchers::ActiveModel

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:all){ DatabaseCleaner.clean }
    config.around { |example| VCR.use_cassette('existing_gist'){ example.run } }
  end

  require 'vcr_config'

end

Spork.each_run do
end


