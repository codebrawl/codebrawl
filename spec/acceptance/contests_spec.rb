# encoding: utf-8
require 'acceptance/acceptance_helper'

share_examples_for 'a contest with visible entries' do

  scenario 'see the entry files' do
    page.should have_content 'I wrote an RSpec formatter'
  end

  scenario 'see the entry filenames' do
    page.should have_content 'README'
  end

end

share_examples_for 'a contest with hidden contestant names' do

  scenario 'do not see the names of the contestants' do
    within('#main') { page.should have_no_content 'charlie' }
  end

end

share_examples_for 'a finished contest' do

  scenario 'do not see the entry button' do
    page.should have_no_link 'Enter'
  end

end

feature 'Contests' do

  context 'on the new contest page' do 

    background do
      login_via_github
      visit "/contests/new"
    end

    scenario 'create a new contest' do
      fill_in 'Name', :with => 'Synchtube'
      fill_in 'Tagline', :with => 'Lets watch youtube together :)'
      fill_in 'Description', :with => 'Create a tool to watch youtube video synchronously with others'
      fill_in 'Starting Date', :with => 'June 23 2011'
      click_button 'Submit your contest'
      
      log_out
      visit "/"
      
      page.should have_content('Synchtube')
      click_link 'Synchtube'
      page.should have_content('Create a tool to watch youtube video synchronously with others')
    end
  end

  context 'on a contest page created by a user' do
    background do
      @user = Fabricate(:user, :login => 'sven')
      @contest = Fabricate(
        :contest,
        :name => 'Write an alternate command line client for travis-ci.org',
        :description => 'Foobar',
        :user => @user
      )
    end

    scenario 'the creator may edit his contest' do
      login_via_github @user
      visit "/contests/#{@contest.to_param}"
      click_link "edit"
      fill_in "Description", :with => 'Preconditions, the client may have a small feature set but must fully integrate in the command line.'
      click_button 'Submit your contest'
      page.should have_content 'Preconditions, the client may have a small feature set but must fully integrate in the command line.'
    end

    scenario 'visitors are not able to edit the users contest' do
      log_out
      visit "/contests/#{@contest.to_param}"
      page.should_not have_content 'edit'
      visit "/contests/#{@contest.to_param}/edit"
      response.should_not be_success
    end

    scenario 'others users are not able to edit the users contest' do
      login_via_github Fabricate(:user, :github_id => '1998', :login => 'Pete')
      visit "/contests/#{@contest.to_param}"
      page.should_not have_content 'edit'
      visit "/contests/#{@contest.to_param}/edit"
      response.should_not be_success
    end
  end

  context 'on a contest page' do

    background :all do
      VCR.use_cassette('existing_gist') do
        @entry = Fabricate.build(
          :entry,
          :files => {
            'README' => { 'content' => 'I wrote an RSpec formatter.'}
          },
          :votes => [ Fabricate(:vote, :score => 1), Fabricate(:vote, :score => 3), Fabricate(:vote, :score => 4) ]
        )

        @contest = Fabricate(
          :contest,
          :name => 'RSpec extensions',
          :description => 'Write an [RSpec](http://relishapp.com/rspec) extension that solves a problem you are having.',
          :starting_on => Date.yesterday.to_time,
          :entries => [ Fabricate(:entry_with_files), @entry ],
          :user => Fabricate(:user, :login => 'bob', :github_id => '1998')
        )
      end
    end

    background do
      visit "/contests/#{@contest.slug}"
      login_via_github
    end

    scenario 'see the contest submitter' do
      page.should have_content 'Submitted by bob'
      page.should have_link 'bob'
      body.should include 'href="/users/bob"'
    end
    
    scenario 'read the markdown contest description' do
      body.should include 'Write an <a href="http://relishapp.com/rspec">RSpec</a> extension that solves a problem you are having.'
    end

    scenario 'go to the entry form' do
      click_link 'Enter'
      page.should have_content 'Submit your entry for “RSpec extensions”'
    end

    context 'when the contest is open for entries' do

      background do
        visit "/contests/#{@contest.slug}"
      end
      
      it_should_behave_like 'a contest with hidden contestant names'

      scenario 'do not see the entry files' do
        page.should have_no_content 'I wrote an RSpec formatter.'
      end

      scenario 'do not see the entry filenames' do
        page.should have_no_content 'README'
      end

      scenario 'be able to enter' do
        page.should have_link 'Enter'
      end
      
      scenario 'show the entry count' do
        page.should have_content '2 entries'
      end

      context 'on a contest page that has no entries' do

        background do
          contest = Fabricate(:contest, :starting_on => Date.yesterday.to_time)
          visit "/contests/#{contest.slug}"
        end
        
        scenario 'do not show the entry count' do
          page.should have_no_content '0 entries'
        end

      end
      
      context 'on a contest page that has only one entry' do

        background do
          contest = Fabricate(
            :contest,
            :starting_on => Date.yesterday.to_time,
            :entries => [Fabricate(:entry)]
          )
          visit "/contests/#{contest.slug}"
        end
        
        scenario 'show the entry count' do
          page.should have_content '1 entry'
        end

      end
      

    end

    context 'when the contest is open for voting' do

      background do
        # TODO: stub `Contest#state` instead of overwriting the voting and
        # closing dates.

        @contest.update_attributes(:voting_on => Date.yesterday.to_time)
        visit "/contests/#{@contest.slug}"
      end

      it_should_behave_like 'a contest with visible entries'

      it_should_behave_like 'a contest with hidden contestant names'

      it_should_behave_like 'a finished contest'

      scenario 'see the voting controls' do
        (1..5).to_a.each { |i| page.should have_field i.to_s }
        page.should have_button 'Submit your votes'
      end

    end

    context 'when the contest is finished' do

      background do
        # TODO: stub `Contest#state` instead of overwriting the voting and
        # closing dates.

        @contest.update_attributes(:closing_on => Date.yesterday.to_time)
        visit "/contests/#{@contest.slug}"
      end

      it_should_behave_like 'a contest with visible entries'

      scenario 'see the names of the contestants' do
        within('#main') { page.should have_content 'charlie' }
      end

      it_should_behave_like 'a finished contest'

      scenario 'do not see the voting controls' do
        (1..5).to_a.each { |i| page.should have_no_field i.to_s }
        page.should have_no_button 'Submit your votes'
      end

      scenario 'see the voting result' do
        visit "/contests/#{@contest.slug}"

        within "#entry_#{@entry.id}" do
          page.should have_content '2.7/5'
        end
      end

    end

  end

end
