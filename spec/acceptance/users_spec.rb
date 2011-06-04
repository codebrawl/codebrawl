require 'acceptance/acceptance_helper'

feature 'Users' do
  background(:all) do
    @user = User.make(:login => 'alice', :name => 'Alice', :email => 'alice@email.com')

    # TODO: stub `Contest#state` instead of setting the voting and closing
    # dates.

    Contest.make(
      :name => 'RSpec extensions',
      :voting_on => Date.yesterday.to_time,
      :entries => [
        Entry.make(:user => @user)
      ]
    )

    Contest.make(
      :name => 'Fun with ChunkyPNG',
      :starting_on => Date.yesterday.to_time,
      :entries => [
        Entry.make(:user => @user)
      ]
    )

    visit '/users/alice'
  end

  scenario 'view a user profile' do
    page.should have_content 'Alice'
  end

  scenario 'see the user gravatar' do
    body.should include 'http://gravatar.com/avatar/c3fbd1a1111b724ab3f1aa2dc3229a36.png?r=PG&amp;s=220'
  end

  scenario 'see the list of entered contests' do
    page.should have_content 'RSpec extensions'
  end

  scenario 'do not see contests that are still open' do
    page.should have_no_content 'Fun with ChunkyPNG'
  end

end
