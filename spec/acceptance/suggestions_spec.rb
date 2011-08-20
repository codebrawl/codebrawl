require 'acceptance/acceptance_helper'

feature 'Suggestions' do

  context 'on the index page' do

    background(:all) do
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

    scenario 'upvote a suggestion' do

      within(:xpath, '//tr[1]') do
        click_button 'upvote'
      end

      page.should have_content 'Thanks for voting!'

      within(:xpath, '//tr[1]') do
        page.should have_content '5'
      end

    end

    scenario 'downvote a suggestion' do

      within(:xpath, '//tr[1]') do
        click_button 'downvote'
      end

      page.should have_content 'Thanks for voting!'

      within(:xpath, '//tr[1]') do
        page.should have_content '4'
      end

    end

  end

end
