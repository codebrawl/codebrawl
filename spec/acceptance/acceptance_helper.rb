require 'spec_helper'
require 'capybara/rspec'

Capybara.default_host = 'example.org'
OmniAuth.config.test_mode = true

def login_via_github(user=nil)
  user ||= Fabricate(:user)
  OmniAuth.config.mock_auth[:github] = {
    'provider' => 'github',
    'uid' => user.github_id,
    'user_info' => {
      'nickname' => user.login,
      'email' => user.email,
      'name' => user.name
    }
  }
  log_out
  visit '/auth/github/'
end

def log_out
  delete '/session'
end

class NotRandomError < StandardError; end
