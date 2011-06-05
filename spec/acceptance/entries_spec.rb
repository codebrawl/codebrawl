# encoding: utf-8
require 'acceptance/acceptance_helper'

feature 'Entries' do

  background :all do
    @contest = Contest.make(:name => 'RSpec extensions', :starting_on => Date.yesterday.to_time)
  end

  context 'on the new entry form' do

    background { visit "/contests/#{@contest.slug}/entries/new" }

    scenario 'be logged in via Github automatically' do
      page.should have_content 'alice'
      page.should have_field 'Description'
    end


    context 'when logged in' do

      background do
        login_via_github
        visit "/contests/#{@contest.slug}/entries/new"
      end

      scenario 'successfully add an entry' do
        fill_in 'Description', :with => 'I wrote an RSpec formatter to show the
        test run\'s instead of just showing how many specs passed and failed up
        to now. It\'s [on Github](http://github.com/jeffkreeftmeijer/fuubar)'

        click_button 'Submit your entry'

        page.should have_content 'Thank you for entering!'
      end

    end

  end

  context 'on the contest page' do
    background do
      @contest.update_attributes(:entries => [Entry.make(:user => User.last)])

      visit "/contests/#{@contest.slug}"
    end

    scenario 'fail to add another entry' do
      click_link 'Enter'
      page.should have_content 'You already have an entry for this contest.'
    end

    context 'when logged in' do

      background { login_via_github }

      scenario 'successfully update my entry' do
        fill_in 'Description', :with => 'I did the most amazing thing ever'
        click_button 'Update your entry'

        page.should have_content 'Your entry has been updated.'
        find_field('Description').value.should == 'I did the most amazing thing ever'
      end

    end

  end

end
