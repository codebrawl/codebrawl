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
        )
      ]
    )

    visit "contests/#{@contest.slug}/entries/#{@contest.entries.first.id}"
  end

  scenario 'see entry files' do
    page.should have_content 'This is the README file'
    page.should have_content 'def foo; bar + baz; end'
  end

  scenario 'see entry filenames' do
    within('ul#files') { page.should have_content 'README.markdown' }
  end

  scenario 'parse the entry files using Gust' do
    body.should include '<em>README</em>'
  end

end