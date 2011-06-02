require 'acceptance/acceptance_helper'

feature 'Log in' do

  scenario 'log in via Github' do
    login_via_github
    page.should have_content 'alice'
  end

  context 'when logged in' do

    background { login_via_github }

    scenario 'see my gravatar' do
      body.should include 'http://gravatar.com/avatar/c3fbd1a1111b724ab3f1aa2dc3229a36.png'
    end

    scenario 'log out' do
      click_link 'log out'
      page.should have_no_content 'alice'
    end

  end

end
