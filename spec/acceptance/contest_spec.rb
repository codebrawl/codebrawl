require 'acceptance/acceptance_helper'

feature 'Contests', %q{
  In order to read about contests, participate and vote
  As a visitor
  I want to see information about contests
} do

  context 'on a contest page' do

    background(:all) do
      @contest = Contest.make(
        :name => 'RSpec extensions',
        :description => 'Write an [RSpec](http://relishapp.com/rspec) extension that solves a problem you are having.'
      )
    end

    background { visit "/contests/#{@contest.id}" }

    scenario 'read the markdown contest description' do
      body.should include 'Write an <a href="http://relishapp.com/rspec">RSpec</a> extension that solves a problem you are having.'
    end

  end

end
