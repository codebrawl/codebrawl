require 'acceptance/acceptance_helper'

feature 'Contest index' do

  background(:all) do
    VCR.use_cassette('existing_gist') do
      Fabricate(
        :contest,
        :name => 'Fun with ChunkyPNG',
        :tagline => 'Having a bit of fun with image manipulation in ChunkyPNG',
        :closing_on => Date.yesterday.to_time,
        :entries => [
          Fabricate.build(
            :entry_with_files,
            :user => Fabricate(:user, :login => 'bob')
          )
        ]
      )
    end
  end

  background { visit '/contests' }

  scenario 'see links to the contests' do
    page.should have_link 'Fun with ChunkyPNG'
  end

  scenario 'see the contest taglines' do
    page.should have_content 'Having a bit of fun with image manipulation in ChunkyPNG'
  end

  scenario 'see the contest states' do
    page.should have_content 'Finished'
  end

  scenario 'see the contest winners' do
    page.should have_css('ol.winners li a img.gravatar')
  end

  scenario 'click a contest winner avatar' do
    find('ol.winners li a').click
    page.should have_content 'This contest is finished'
  end



end
