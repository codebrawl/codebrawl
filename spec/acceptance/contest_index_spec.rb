require 'acceptance/acceptance_helper'

feature 'Homepage' do

  scenario 'be redirected to the homepage when accessing /contests' do
    # TODO: Move this one to a controller spec
    visit '/contests'
    URI.parse(current_url).path.should == '/'
  end

  context "on the homepage" do

    background :all do
      @voting = Fabricate(
        :contest,
        :name => 'Fun with ChunkyPNG',
        :tagline => 'Having a bit of with image manipulation in ChunkyPNG',
        :voting_on => Date.yesterday.to_time
      )
      @finished = Fabricate(
        :contest,
        :name => 'Improving Ruby',
        :tagline => 'Build verything you ever wanted, monkey-patched into Ruby',
        :closing_on => Date.yesterday.to_time
      )
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
        page.should have_content "Get ready for next week's contest"
        page.should have_content 'Our next contest will start next Monday at 14:00 (UTC)'
        page.should have_link 'contests feed'
        body.should include 'href="http://feeds.feedburner.com/codebrawl"'
        page.should have_link "last week's contest"
        body.should include 'href="/contests/fun-with-chunkypng"'
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

      scenario 'see the Codebrawl header' do
        page.should have_content 'Codebrawl'
      end

      scenario 'do not see the "no open contests"-message' do
        page.should have_no_content "Get ready for next week's contest"
      end

      scenario 'return to the homepage after clicking the header' do
        click_link 'Fun with ChunkyPNG'
        click_link 'Codebrawl'
        ['Euler #74', 'Fun with ChunkyPNG'].each do |name|
          page.should have_link name
        end
      end

      scenario 'return to the homepage after clicking the "Contests" menu item' do
        click_link 'Fun with ChunkyPNG'
        click_link 'Contests'
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

      scenario 'see entry counts in the contests list' do
        p @open.open?
        p @open.entries
        save_and_open_page
        page.should have_content "This contest has 1 entry already"
      end

      scenario 'see the contest taglines' do
        ['Get your Euler on and build the fastest solution to problem #123', 'Having a bit of with image manipulation in ChunkyPNG', 'Build verything you ever wanted, monkey-patched into Ruby'].each do |tagline|
          page.should have_content tagline
        end
      end

      scenario 'see the contest states' do
        within "#contest_#{@open.id}" do
          page.should have_content 'Open'
        end

        within "#contest_#{@voting.id}" do
          page.should have_content 'Voting'
        end

        within "#contest_#{@finished.id}" do
          page.should have_content 'Finished'
        end
      end

      scenario 'visit the submissions page' do
        click_link 'Submit a contest idea'
        page.should have_content 'Submit your contest idea'
      end

      scenario 'visit the hall of fame' do
        click_link 'Hall of Fame'
        within('#main') { page.should have_content 'Hall of Fame' }
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
