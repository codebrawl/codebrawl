require 'acceptance/acceptance_helper'

feature 'Articles', %q{
  In order to be introduced to Codebrawl
  As a visitor
  I want to see what it's all about
} do

  context "on the homepage" do

    background do
      ['Euler #74', 'Fun with ChunkyPNG'].each { |name| Contest.make(:name => name) }

       visit '/'
     end

    scenario 'see the Codebrawl header' do
      page.should have_content 'Codebrawl'
    end

    scenario 'see a list of contest names' do
      ['Euler #74', 'Fun with ChunkyPNG'].each do |name|
        page.should have_content name
      end
    end

  end

end