require 'acceptance/acceptance_helper'

feature 'Suggestions' do

  context 'on the index page' do

    background do
      Fabricate(
        :suggestion,
        :name => 'Terminal admin',
        :votes => [{:score => 1}] * 4
      )

      Fabricate(
        :suggestion,
        :name => 'RSpec formatters',
        :votes => [{:score => -1}] * 2
      )

      visit 'suggestions'
    end

    scenario 'see the list of suggestions' do

      page.should have_content 'Terminal admin'
      page.should have_content 'RSpec formatters'

    end

    scenario 'see the suggestion scores' do

      within(:xpath, '//tr[1]') do
        page.should have_content '4'
      end

      within(:xpath, '//tr[2]') do
        page.should have_content '-2'
      end

    end

  end

end
