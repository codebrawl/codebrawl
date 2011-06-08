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
      page.should have_field 'Gist id'
    end

    context 'when logged in' do

      background do
        login_via_github
        visit "/contests/#{@contest.slug}/entries/new"
      end

      scenario 'successfully add an entry' do
        fill_in 'Gist id', :with => '12345'
        click_button 'Submit your entry'

        page.should have_content 'Thank you for entering!'
        find_field('Gist id').value.should == '12345'
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
        fill_in 'Gist id', :with => '54321'
        click_button 'Update your entry'

        page.should have_content 'Your entry has been updated.'
        find_field('Gist id').value.should == '54321'
      end

      scenario 'delete my entry' do
        click_button 'Delete your entry'
        page.should have_content 'Your entry has been deleted.'
        page.should have_link 'Enter'
      end

    end

  end

end
