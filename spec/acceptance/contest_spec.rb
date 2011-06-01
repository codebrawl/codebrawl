# encoding: utf-8
require 'acceptance/acceptance_helper'

share_examples_for 'a contest with visible entries' do

  scenario 'see the contest entries' do
    page.should have_content 'I wrote an RSpec formatter to show the test run’s progress instead of just showing how many specs passed and failed up to now.'
    body.should include('<a href="http://github.com/jeffkreeftmeijer/fuubar">on Github</a>')
  end

end

feature 'Contests' do

  context 'on a contest page' do

    background :all do
      @contest = Contest.make(
        :name => 'RSpec extensions',
        :description => 'Write an [RSpec](http://relishapp.com/rspec) extension that solves a problem you are having.',
        :starting_on => Date.yesterday.to_time,
        :entries => [
          Entry.make(
            :description => 'I wrote an RSpec formatter to show the test run\'s progress instead of just showing how many specs passed and failed up to now. It\'s [on Github](http://github.com/jeffkreeftmeijer/fuubar)',
            :user => User.make(:login => 'bob')
          )
        ]
      )
    end

    background { visit "/contests/#{@contest.slug}" }

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

      scenario 'do not see the contest entries' do
        page.should have_no_content 'I wrote an RSpec formatter to show the test run’s progress instead of just showing how many specs passed and failed up to now.'
      end

      scenario 'do not see the names of the contestants' do
        page.should have_no_content 'bob'
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

      scenario 'do not see the names of the contestants' do
        page.should have_no_content 'bob'
      end

    end

    context 'when the contest is closed' do

      background do
        # TODO: stub `Contest#state` instead of overwriting the voting and
        # closing dates.

        @contest.update_attributes(:closing_on => Date.yesterday.to_time)
        visit "/contests/#{@contest.slug}"
      end

      it_should_behave_like 'a contest with visible entries'

      scenario 'see the names of the contestants' do
        page.should have_content 'bob'
      end

    end

  end

end
