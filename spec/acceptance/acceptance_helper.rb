require 'spec_helper'
require 'capybara/rspec'

Capybara.default_host = 'example.org'
OmniAuth.config.test_mode = true

def login_via_github
  OmniAuth.config.add_mock(:github, {
      :uid => '12345',
      :user_info => {
        :nickname => 'alice'
      }
  })

  visit '/auth/github/'
end
