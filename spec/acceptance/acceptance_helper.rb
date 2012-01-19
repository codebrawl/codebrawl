require 'spec_helper'
require 'capybara/rspec'

OmniAuth.config.test_mode = true

RSpec.configure do |config|
  config.before(:each) do
    OmniAuth.config.mock_auth[:github] = {
      'provider' => 'github',
      'uid' => '1763',
      'info' => {
        'nickname' => 'charlie',
        'email' => 'charlie@email.com',
        'name' => 'Charlie Chaplin'
      },
      'credentials' => {
        'token' => 't0k3n'
      },
      'extra' => {
        'raw_info' => {
          'gravatar_id' => '12345'
        }
      }
    }
  end
end

def login_via_github
  visit '/auth/github/'
end

class NotRandomError < StandardError; end
