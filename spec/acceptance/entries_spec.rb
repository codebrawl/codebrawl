# encoding: utf-8
require 'acceptance/acceptance_helper'

feature 'Entries' do

  background :all do
    @contest = Fabricate(:contest, :name => 'RSpec extensions', :starting_on => Date.yesterday.to_time)
  end

  context 'on the new entry form' do

    background { visit "/contests/#{@contest.slug}/entries/new" }

    scenario 'be logged in via Github automatically' do
      page.should have_content 'charlie'
      page.should have_field 'Gist id'
    end

    context 'when logged in' do

      background do
        login_via_github
        visit "/contests/#{@contest.slug}/entries/new"
      end

      scenario 'fail to add an entry when forgetting the Gist id' do
        click_button 'Submit your entry'
        page.should have_content 'Gist can\'t be blank'
      end

      scenario 'successfully add an entry' do
        fill_in 'Gist id', :with => '866948'
        click_button 'Submit your entry'

        page.should have_content 'Thank you for entering!'
      end

    end

  end

  context 'on the contest page' do
    background do
      @contest.entries << Fabricate(:entry)
      visit "/contests/#{@contest.slug}"
    end

    scenario 'fail to add another entry' do
      click_link 'Enter'
      page.should have_content 'You already have an entry for this contest.'
    end

    context 'when logged in' do

      background { login_via_github }

      scenario 'see the "you entered"-message' do
        page.should have_content 'You entered gist 866948'
        page.should have_link 'gist 866948'
        body.should include 'https://gist.github.com/866948'
      end

      scenario 'do not see the "enter"-button' do
        page.should have_no_link 'Enter'
      end

      scenario 'delete my entry' do
        click_link 'delete your entry'
        page.should have_content 'Your entry has been deleted.'
        page.should have_link 'Enter'
      end

    end

  end

end
