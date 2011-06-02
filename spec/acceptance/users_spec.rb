require 'acceptance/acceptance_helper'

feature 'Users' do
  background(:all) do
    User.make(:login => 'alice', :name => 'Alice', :email => 'alice@email.com')
    visit '/users/alice'
  end

  scenario 'view a user profile' do
    page.should have_content 'Alice'
  end

  scenario 'see the user gravatar' do
    body.should include 'http://gravatar.com/avatar/c3fbd1a1111b724ab3f1aa2dc3229a36.png?r=PG&amp;s=220'
  end

end
