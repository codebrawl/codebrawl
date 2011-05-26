# encoding: utf-8
require 'acceptance/acceptance_helper'

feature 'Entries' do

  context 'on the new entry form' do

    background :all do
      @contest = Contest.make
    end

    background { visit "/contests/#{@contest.slug}/entries/new" }

    scenario 'successfully add your entry' do
      fill_in 'Description', :with => 'I wrote an RSpec formatter to show the
      test run\'s instead of just showing how many specs passed and failed up
      to now. It\'s [on Github](http://github.com/jeffkreeftmeijer/fuubar)'

      click_button 'Submit your entry'

      page.should have_content 'Thank you for entering!'
    end

  end

end
