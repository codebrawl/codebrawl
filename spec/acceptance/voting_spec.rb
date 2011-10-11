require 'acceptance/acceptance_helper'

feature 'Voting' do

  background do
    # TODO: stub `Contest#state` instead setting the voting date
    @contest = Fabricate(
      :contest,
      :name => 'Rspec extensions',
      :entries => [Fabricate.build(:entry_with_files, :user => Fabricate(:user, :login => 'bob'))],
      :voting_on => Date.yesterday.to_time
    )

    visit "contests/#{@contest.slug}"
  end

  scenario 'do not see the voting controls' do
    (1..5).to_a.each { |i| page.should have_no_field i.to_s }
    page.should have_no_button 'Vote'
  end

  scenario 'do not see the entry gist urls' do
    page.should have_no_link 'Gist'
    body.should_not include 'href="https://gist.github.com/866948"'
  end

  context 'when logged in' do
    background do
      mock_login
      login_via_github
    end

    scenario 'vote without selecting any scores' do
      click_button 'Vote'
      page.should have_content 'Rspec extensions'
      page.should have_no_content 'You voted'
    end

    scenario 'successfully vote for an entry' do
      within "#entry_#{@contest.entries.first.id}" do
        choose '4'
      end

      click_button 'Vote'

      within "#entry_#{@contest.entries.first.id}" do
        page.should have_content 'You voted 4/5'
      end

    end

    scenario 'do not see the entry gist urls' do
      page.should have_no_link 'Gist'
      body.should_not include 'href="https://gist.github.com/866948"'
    end

    context 'after voting for every entry' do

      before do
        within("#entry_#{@contest.entries.first.id}"){ choose '4' }
        click_button 'Vote'
      end

      scenario 'do not see the voting controls anymore' do
        (1..5).to_a.each { |i| page.should have_no_field i.to_s }
        page.should have_no_button 'Vote'
      end

      scenario 'see the contestant names' do
        page.should have_content 'bob'
      end

      scenario 'see the entry gist urls' do
        page.should have_link 'Gist'
        body.should include 'href="https://gist.github.com/866948"'
      end

    end

  end

end
