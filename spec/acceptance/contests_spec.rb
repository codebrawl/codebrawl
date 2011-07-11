# encoding: utf-8
require 'acceptance/acceptance_helper'

share_examples_for 'a contest with hidden entries' do

  scenario 'do not see the entry files' do
    page.should have_no_content 'I wrote an RSpec formatter.'
  end

  scenario 'do not see the entry filenames' do
    page.should have_no_content 'README'
  end

end

share_examples_for 'a contest with visible entries' do

  scenario 'see the entry files' do
    page.should have_content 'I wrote an RSpec formatter'
  end

  scenario 'see the entry filenames' do
    page.should have_content 'README'
  end

end

share_examples_for 'a contest with hidden contestant names and gists' do

  scenario 'do not see the names of the contestants' do
    within('#main') { page.should have_no_content 'charlie' }
  end
  
  scenario 'do not see the entry gist urls' do
    page.should have_no_link 'Gist'
    body.should_not include 'href="https://gist.github.com/866948"'
  end

end

share_examples_for 'a finished contest' do

  scenario 'do not see the entry button' do
    page.should have_no_link 'Enter'
  end

end

feature 'Contests' do

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
          :user => Fabricate(:user, :login => 'bob')
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

      it_should_behave_like 'a contest with hidden contestant names and gists'

      it_should_behave_like 'a contest with hidden entries'

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

      it_should_behave_like 'a contest with hidden contestant names and gists'

      it_should_behave_like 'a finished contest'

      scenario 'see the voting controls' do
        (1..5).to_a.each { |i| page.should have_field i.to_s }
        page.should have_button 'Vote'
      end
      
      context 'when not logged in' do
        background do
          click_link 'log out'
          visit "/contests/#{@contest.slug}"
        end

        it_should_behave_like 'a contest with hidden entries'

        scenario 'see the "log in to vote"-link' do
          page.should have_link 'logging in'
        end

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
      
      scenario 'see the entry gist urls' do
        page.should have_link 'Gist'
        body.should include 'href="https://gist.github.com/866948"'
      end
      
      scenario 'see the contest rundown link' do
        page.should have_link 'contest rundown'
        body.should include 'href="/articles/contest-rundown-rspec-extensions"'
      end

      context 'when not logged in' do
        background do
          click_link 'log out'
          visit "/contests/#{@contest.slug}"
        end

        it_should_behave_like 'a contest with visible entries'

        scenario 'do not see the "log in to vote"-link' do
          page.should have_no_link 'logging in'
        end

      end

    end

  end

end
