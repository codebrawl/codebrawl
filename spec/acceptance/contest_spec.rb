# encoding: utf-8
require 'acceptance/acceptance_helper'

share_examples_for 'a contest with visible entries' do

  scenario 'see the contest entries' do
    page.should have_content 'I wrote an RSpec formatter to show the test run’s progress instead of just showing how many specs passed and failed up to now.'
    body.should include('<a href="http://github.com/jeffkreeftmeijer/fuubar">on Github</a>')
  end

end

share_examples_for 'a contest with hidden contestant names' do

  scenario 'do not see the names of the contestants' do
    page.should have_no_content 'bob'
  end

end

share_examples_for 'a contest closed for further entries' do

  scenario 'do not see the entry button' do
    page.should have_no_link 'Enter'
  end

end

feature 'Contests' do

  context 'on a contest page' do

    background :all do
      @entry = Entry.make(
        :description => 'I wrote an RSpec formatter to show the test run\'s progress instead of just showing how many specs passed and failed up to now. It\'s [on Github](http://github.com/jeffkreeftmeijer/fuubar)',
        :user => User.make(:login => 'bob')
      )

      @contest = Contest.make(
        :name => 'RSpec extensions',
        :description => 'Write an [RSpec](http://relishapp.com/rspec) extension that solves a problem you are having.',
        :starting_on => Date.yesterday.to_time,
        :entries => [@entry]
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

      it_should_behave_like 'a contest with hidden contestant names'

      scenario 'be able to enter' do
        page.should have_link 'Enter'
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

      it_should_behave_like 'a contest closed for further entries'

      scenario 'see the voting controls' do
        within "#entry_#{@entry.id}" do

          page.should have_field '1'
          page.should have_field '2'
          page.should have_field '3'
          page.should have_field '4'
          page.should have_field '5'

        end
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

      it_should_behave_like 'a contest closed for further entries'

      scenario 'do not see the voting controls' do
        within "#entry_#{@entry.id}" do

          page.should have_no_field '1'
          page.should have_no_field '2'
          page.should have_no_field '3'
          page.should have_no_field '4'
          page.should have_no_field '5'

        end
      end

    end

  end

end
