require 'acceptance/acceptance_helper'

feature 'Articles', %q{
  In order to be introduced to Codebrawl
  As a visitor
  I want to see what it's all about
} do

  context "on the homepage" do

    background :all do
      ['Euler #74', 'Fun with ChunkyPNG'].each { |name| Contest.make(:name => name) }
      Contest.make(:name => 'RSpec extensions', :starting_on => 1.week.from_now.utc)
    end

    before { visit '/' }

    scenario 'see the Codebrawl header' do
      page.should have_content 'Codebrawl'
    end

    scenario 'see a list of contest names' do
      ['Euler #74', 'Fun with ChunkyPNG'].each do |name|
        page.should have_content name
      end

      page.should have_no_content 'RSpec extensions'
    end

  end

end
