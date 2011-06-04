require 'acceptance/acceptance_helper'

feature 'Homepage' do

  context "on the homepage" do

    background :all do
      Contest.make(:name => 'Euler #74', :tagline => 'Get your Euler on')
      Contest.make(:name => 'Fun with ChunkyPNG', :tagline => 'Image manipulation! Woo!')
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
      ['Euler #74', 'Fun with ChunkyPNG'].each do |name|
        page.should have_link name
      end

      page.should have_no_content 'RSpec extensions'
    end

    scenario 'see the contest taglines' do
      ['Get your Euler on', 'Image manipulation! Woo!'].each do |tagline|
        page.should have_content tagline
      end
    end

    context 'after logging in' do

      background { login_via_github }

      scenario 'visit my profile page' do
        click_link 'alice'
        page.should have_content 'Alice'
      end

    end

  end

end
