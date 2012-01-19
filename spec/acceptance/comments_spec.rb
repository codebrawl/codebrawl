require 'acceptance/acceptance_helper'

shared_examples_for 'an entry with a voting box' do
  scenario 'add a comment from the entry list' do
    Gist.expects(:comment).with('866948', 't0k3n', 'Another comment!')
    fill_in 'Comment', :with => 'Another comment!'
    click_button 'Comment'
  end
end

feature 'Comments' do

  context 'when on a contest page which is in the voting period' do

    background do
      # TODO: stub `Contest#state` instead setting the voting date
      @contest = Fabricate(
        :contest,
        :entries => [Fabricate.build(:entry_with_files)],
        :voting_on => Date.yesterday.to_time
      )

      visit "/contests/#{@contest.slug}"
      login_via_github
    end

    scenario 'add a comment via the voting box' do
      Gist.expects(:comment).with('866948', 't0k3n', 'Comment!')
      fill_in 'Comment', :with => 'Comment!'
      click_button 'Vote'
    end

    scenario 'do not post a comment when the message is empty' do
      Gist.expects(:comment).never
      click_button 'Vote'
    end

    context 'after voting' do
      background do
        within("#entry_#{@contest.entries.first.id}"){ choose '3' }
        click_button 'Vote'
      end

      it_should_behave_like 'an entry with a voting box'

    end

  end

  context 'when on a finished contest page' do

    background do
      # TODO: stub `Contest#state` instead setting the voting date
      @contest = Fabricate(
        :contest,
        :entries => [Fabricate.build(:entry_with_files)],
        :closing_on => Date.yesterday.to_time
      )

      visit "/contests/#{@contest.slug}"
      login_via_github
    end

    it_should_behave_like 'an entry with a voting box'

  end

end
