require 'acceptance/acceptance_helper'

feature 'Log in' do

  scenario ';og in via Github' do
    login_via_github
    page.should have_content 'alice'
  end
  
  context 'when logged in' do
    
    background { login_via_github }
    
    scenario 'log out' do
      click_link 'log out'
      page.should have_no_content 'alice'
    end
    
  end
  
end
