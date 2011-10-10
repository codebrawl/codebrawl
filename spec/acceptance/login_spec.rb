require 'acceptance/acceptance_helper'

feature 'Log in' do

  scenario 'log in via Github' do
    visit '/'
    click_link 'log in via Github'
    page.should have_content 'Charlie'
  end

  scenario 'fail to log in using invalid credentials' do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    visit '/'
    click_link 'log in via Github'
    page.should have_content 'Something went wrong while trying to log you in.'
  end

  context 'when logged in' do

    background { login_via_github }

    scenario 'see my gravatar' do
      body.should include 'http://gravatar.com/avatar/1dae832a3c5ae2702f34ed50a40010e8.png'
    end

    scenario 'log out' do
      click_link 'log out'
      page.should have_no_content 'charlie'
    end

    context 'when my user gets deleted' do

      background { User.delete_all }

      scenario 'see the login link' do
        visit '/'
        page.should have_content 'log in via Github'
      end

    end

  end

  context 'without an email address, after logging in' do

    background do
      OmniAuth.config.mock_auth[:github] = {
        'provider' => 'github',
        'uid' => '1763',
        'user_info' => {
          'nickname' => 'charlie'
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
      login_via_github
    end

    scenario 'see my gravatar' do
      body.should include 'http://gravatar.com/avatar/12345.png'
    end

  end

end
