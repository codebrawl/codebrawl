require 'acceptance/acceptance_helper'

feature 'Log in' do

  scenario 'log in with twitter' do
    Capybara.default_host = 'example.org'

    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:github, {
        :uid => '12345',
        :user_info => {
          :nickname => 'alice'
        }
    })

    visit '/auth/github/'
    page.should have_content 'logged in as alice'
  end

end
