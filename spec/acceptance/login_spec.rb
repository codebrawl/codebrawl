require 'acceptance/acceptance_helper'

feature 'Log in' do

  scenario 'Log in via Github' do
    login_via_github
    page.should have_content 'logged in as alice'
  end

end
