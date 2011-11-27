require 'acceptance/acceptance_helper'

feature 'Homepage' do

  context "on the homepage" do

    background :all do
      @voting = Fabricate(
        :contest,
        :name => 'Fun with ChunkyPNG',
        :tagline => 'Having a bit of with image manipulation in ChunkyPNG',
        :voting_on => Date.yesterday.to_time
      )
      VCR.use_cassette('existing_gist') do
        @finished = Fabricate(
          :contest,
          :name => 'Improving Ruby',
          :tagline => 'Build verything you ever wanted, monkey-patched into Ruby',
          :entries => [Fabricate.build(:entry_with_files, :user => Fabricate(:user, :login => 'bob'))] * 3,
          :closing_on => Date.yesterday.to_time
        )
      end
      @pending = Fabricate(
        :contest,
        :name => 'RSpec extensions',
        :tagline => 'Giving back to RSpec by building the funniest or most useful RSpec formatter',
        :starting_on => Date.tomorrow.to_time
      )

      visit '/'
    end

    scenario 'see the "no open contests"-message' do
      within('.tip') do
        # page.should have_content "Get ready for next week's contest"
        # page.should have_content 'Our next contest will start next Monday at 14:00 (UTC)'
        page.should have_link 'contests feed'
        body.should include 'href="http://feeds.feedburner.com/codebrawl"'
        # page.should have_link "last week's contest"
        # body.should include 'href="/contests/fun-with-chunkypng"'
      end
    end

    context 'when having an open contest' do

      background :all do
        @user = Fabricate(:user)
        VCR.use_cassette('existing_gist') do
          @open = Fabricate(
            :contest,
            :name => 'Euler #74',
            :tagline => 'Get your Euler on and build the fastest solution to problem #123',
            :starting_on => Date.yesterday.to_time,
            :entries => [Fabricate.build(:entry_with_files, :user => Fabricate(:user, :login => 'bob'))]
          )
        end
      end

      before { visit '/' }

      scenario 'do not see the "no open contests"-message' do
        page.should have_no_content "Get ready for next week's contest"
      end

      scenario 'see a list of contest names' do
        ['Euler #74', 'Fun with ChunkyPNG'].each do |name|
          page.should have_link name
        end

        page.should have_no_content 'RSpec extensions'
      end

      scenario 'only show two contests at once' do
        page.should have_no_content 'Improving Ruby'
      end

      scenario 'see entry counts in the contests list' do
        page.should have_content "1 entry already"
      end

      scenario 'see the contest taglines' do
        ['Get your Euler on and build the fastest solution to problem #123', 'Having a bit of with image manipulation in ChunkyPNG'].each do |tagline|
          page.should have_content tagline
        end
      end

      scenario 'visit the contest archive' do
        click_link 'Contest archive'
        page.should have_content 'Improving Ruby'
      end

      context 'after logging in' do

        background { login_via_github }

        scenario 'visit my profile page' do
          click_link 'charlie'
          page.should have_content 'Total points'
        end

      end

    end

  end

end
