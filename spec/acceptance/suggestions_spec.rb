require 'acceptance/acceptance_helper'

feature 'Suggestions' do

  context 'on the index page' do

    background(:all) do
      Fabricate(
        :suggestion,
        :name => 'Terminal admin',
        :votes => [{:score => -1}] * 2
      )

      Fabricate(
        :suggestion,
        :name => 'RSpec formatters',
        :votes => [{:score => 1}] * 4
      )

      visit 'suggestions'
    end

    scenario 'see the list of suggestions, ordered by score' do

      within(:xpath, '//tr[1]') do
        page.should have_content 'RSpec formatters'
      end

      within(:xpath, '//tr[2]') do
        page.should have_content 'Terminal admin'
      end

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

      find('input.upvote').click

      page.should have_content 'Thanks for voting!'

      within(:xpath, '//tr[1]') do
        page.should have_content '5'
      end

    end

    scenario 'downvote a suggestion' do

      find('input.downvote').click

      page.should have_content 'Thanks for voting!'

      within(:xpath, '//tr[1]') do
        page.should have_content '4'
      end

    end

    scenario 'create a suggestion' do

      fill_in :name, :with => 'Whyday'
      click_button 'Suggest'

      page.should have_content 'Thanks for your suggestion!'
      page.should have_content 'Whyday'

    end

  end

end
