require 'acceptance/acceptance_helper'

feature 'Articles', %q{
  In order to be introduced to Codebrawl
  As a visitor
  I want to see what it's all about
} do

  scenario 'visit the homepage' do
    visit '/'
    page.should have_content 'Codebrawl'
  end

end