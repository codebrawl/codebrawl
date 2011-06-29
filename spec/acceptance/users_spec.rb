require 'acceptance/acceptance_helper'

feature 'Users' do
  background(:all) do
    # TODO: stub `Contest#state` instead of setting the voting and closing
    # dates.

    user = Fabricate(:user)

    VCR.use_cassette('existing_gist') do
      Fabricate(
        :contest,
        :name => 'RSpec extensions',
        :closing_on => Date.yesterday.to_time,
        :entries => [ Fabricate.build(:entry, :user => user) ]
      )

      Fabricate(
        :contest,
        :name => 'Fun with ChunkyPNG',
        :starting_on => Date.yesterday.to_time,
        :entries => [ Fabricate.build(:entry, :user => user) ]
      )

      Fabricate(
        :contest,
        :name => 'Terminal Twitter clients',
        :voting_on => Date.yesterday.to_time,
        :entries => [ Fabricate.build(:entry, :user => user) ]
      )

      Fabricate(
        :contest,
        :name => 'Ruby metaprogramming',
        :starting_on => Date.yesterday.to_time,
        :user => user
      )
    end

    visit '/users/charlie'
  end

  scenario 'view a user profile' do
    page.should have_content 'Charlie'
  end

  scenario 'see the user gravatar' do
    body.should include 'http://gravatar.com/avatar/1dae832a3c5ae2702f34ed50a40010e8.png'
  end

  scenario 'see the link to the users github profile' do
    page.should have_link 'charlie on Github'
    body.should include 'https://github.com/charlie'
  end

  scenario 'see the list of entered contests' do
    page.should have_content 'RSpec extensions'
  end

  scenario 'do not see any entered contests that are still open' do
    page.should have_no_content 'Fun with ChunkyPNG'
    page.should have_no_content 'Terminal Twitter clients'
  end

  scenario 'see the list of submitted contests' do
    page.should have_content 'Ruby metaprogramming'
  end


end
