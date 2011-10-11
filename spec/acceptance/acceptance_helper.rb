require 'spec_helper'
require 'capybara/rspec'

Capybara.default_host = 'example.org'
OmniAuth.config.test_mode = true

def mock_login
  OmniAuth.config.mock_auth[:github] = {
      'provider' => 'github',
      'uid' => '1763',
      'user_info' => {
        'nickname' => 'charlie',
        'email' => 'charlie@email.com',
        'name' => 'Charlie Chaplin'
      },
      'credentials' => {
        'token' => 't0k3n'
      },
      'extra' => {
        'user_hash' => {
          'gravatar_id' => '12345'
        }
      }
    }
end

def login_via_github
  visit '/auth/github/'
end

class NotRandomError < StandardError; end
