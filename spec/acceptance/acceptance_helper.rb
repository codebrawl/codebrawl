require 'spec_helper'
require 'capybara/rspec'

Capybara.default_host = 'example.org'
OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:github] = {
  'provider' => 'github',
  'uid' => '12345',
  'user_info' => { 'nickname' => 'alice' }
}

def login_via_github
  visit '/auth/github/'
end
