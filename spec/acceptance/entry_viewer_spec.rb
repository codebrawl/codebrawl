require 'acceptance/acceptance_helper'

feature 'Entry viewer' do

  background do
    @contest = Fabricate(
      :contest,
      :entries => [
        Fabricate.build(
          :entry,
          :files => {
            'README*markdown' => {'content' => 'This is the _README_ file'},
            'implementation*rb' => { 'content' => 'def foo; bar + baz; end'}
          }
        ),
        Fabricate.build(
          :entry,
          :files => {
            'README*markdown' => {'content' => 'This is the second _README_ file'},
            'implementation*rb' => { 'content' => 'def baz; bar + foo; end'}
          }
        )
      ]
    )

    visit "contests/#{@contest.slug}/entries/#{@contest.entries.first.id}"
  end

  scenario 'see entry files' do
    page.should have_content 'This is the README file'
    page.should have_content 'def foo; bar + baz; end'
  end

  scenario 'parse the entry files using Gust' do
    body.should include '<em>README</em>'
  end

  scenario 'see entry filenames' do
    within('ul#files') { page.should have_content 'README.markdown' }
  end

  scenario 'do not see the "previous" link' do
    page.should have_no_content 'previous'
  end

  scenario 'navigate to the next entry' do
    click_link 'next'
    page.should have_content 'This is the second README file'
    page.should have_content 'def baz; bar + foo; end'
  end

  context 'when on the second entry page' do
    background do
      visit "contests/#{@contest.slug}/entries/#{@contest.entries.last.id}"
    end

    scenario 'do not see the "next" link' do
      page.should have_no_content 'next'
    end

    scenario 'navigate to the previous entry' do
      click_link 'previous'
      page.should have_content 'This is the README file'
    end
  end

end