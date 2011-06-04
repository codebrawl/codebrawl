require 'acceptance/acceptance_helper'

feature 'Voting' do

  scenario 'successfully vote for an entry' do
    login_via_github

    # TODO: stub `Contest#state` instead setting the voting date

    contest = Contest.make(
      :entries => [Entry.make],
      :voting_on => Date.yesterday.to_time
    )

    visit "contests/#{contest.slug}"

    within "#entry_#{contest.entries.first.id}" do
      choose '4'
    end

    click_button 'Submit your votes'

    within "#entry_#{contest.entries.first.id}" do
      page.should have_content 'You voted 4/5'
    end

  end

end