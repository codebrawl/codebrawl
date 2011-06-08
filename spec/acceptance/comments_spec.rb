require 'acceptance/acceptance_helper'

feature 'Comments' do

  background(:all) do

    @contest = Contest.make(
      :entries => [
        Entry.make(:with_files,
          :comments => [
            Comment.make(:content => 'Amazing work!'),
            Comment.make(:content => 'Looks good, but how do I get it to run?')
          ]
        )
      ]
    )

    visit "contests/#{@contest.slug}"
  end

  scenario 'do not see the comments' do
    page.should have_no_content 'Amazing work!'
    page.should have_no_content 'Looks good, but how do I get it to run?'
  end

  context 'when logged in' do

    background { login_via_github }

    scenario 'do not see the comments' do
      page.should have_no_content 'Amazing work!'
      page.should have_no_content 'Looks good, but how do I get it to run?'
    end

    context 'after voting for this entry' do

      background(:all) do
        # TODO: Mock the votes method instead of updating the document
        @contest.entries.first.update_attributes(
          :votes => [Vote.make(:user => User.last)]
        )

        visit "contests/#{@contest.slug}"
      end

      pending 'see the comments' do
        page.should have_content 'Amazing work!'
        page.should have_content 'Looks good, but how do I get it to run?'
      end

    end

  end

end
