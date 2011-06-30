require 'acceptance/acceptance_helper'

feature 'Homepage' do

  scenario 'be redirected to the homepage when accessing /contests' do
    # TODO: Move this one to a controller spec
    visit '/contests'
    URI.parse(current_url).path.should == '/'
  end

  context "on the homepage" do

    background :all do
      @open = Fabricate(
        :contest,
        :name => 'Euler #74',
        :tagline => 'Get your Euler on',
        :starting_on => Date.yesterday.to_time
      )
      @voting = Fabricate(
        :contest,
        :name => 'Fun with ChunkyPNG',
        :tagline => 'Image manipulation! Woo!',
        :voting_on => Date.yesterday.to_time
      )
      @finished = Fabricate(
        :contest,
        :name => 'Improving Ruby',
        :tagline => 'Everything you ever wanted',
        :closing_on => Date.yesterday.to_time
      )
      @pending = Fabricate(
        :contest,
        :name => 'RSpec extensions',
        :tagline => 'Giving back to RSpec',
        :starting_on => Date.tomorrow.to_time
      )
    end

    before { visit '/' }

    scenario 'see the Codebrawl header' do
      page.should have_content 'Codebrawl'
    end

    scenario 'return to the homepage after clicking the header' do
      click_link 'Fun with ChunkyPNG'
      click_link 'Codebrawl'
      ['Euler #74', 'Fun with ChunkyPNG'].each do |name|
        page.should have_link name
      end
    end

    scenario 'see a list of contest names' do
      ['Euler #74', 'Fun with ChunkyPNG', 'Improving Ruby'].each do |name|
        page.should have_link name
      end

      page.should have_no_content 'RSpec extensions'
    end

    scenario 'see the contest taglines' do
      ['Get your Euler on', 'Image manipulation! Woo!', 'Everything you ever wanted'].each do |tagline|
        page.should have_content tagline
      end
    end

    scenario 'see the contest states' do
      within "li#contest_#{@open.id}" do
        page.should have_content 'Open'
      end

      within "li#contest_#{@voting.id}" do
        page.should have_content 'Voting'
      end

      within "li#contest_#{@finished.id}" do
        page.should have_content 'Finished'
      end
    end

    scenario 'visit the submissions page' do
      login_via_github
      click_link 'Submit a contest idea'
      page.should have_content 'Submit your contest idea'
      page.should have_content 'charlie'
    end

    context 'after logging in' do

      background { login_via_github }

      scenario 'visit my profile page' do
        click_link 'charlie'
        page.should have_content 'Charlie Chaplin'
      end

    end

  end

end
