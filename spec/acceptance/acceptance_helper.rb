require 'spec_helper'
require 'capybara/rspec'

Capybara.default_host = 'example.org'
OmniAuth.config.test_mode = true

RSpec.configure do |config|
  config.before(:each) do
    OmniAuth.config.mock_auth[:github] = {
      'provider' => 'github',
      'uid' => '12345',
      'user_info' => {
        'nickname' => 'alice',
        'email' => 'alice@email.com',
        'name' => 'Alice'
      }
    }
  end
end

def login_via_github
  visit '/auth/github/'
end

class NotRandomError < StandardError; end
