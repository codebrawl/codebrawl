require 'acceptance/acceptance_helper'

feature 'Menu' do

  background { visit '/rules' }

  scenario 'return to the homepage after clicking the header' do
    click_link 'Codebrawl'
    current_path.should == '/'
  end

  scenario 'go to the contest archive after clicking the "Contests" menu item' do
    click_link 'Contests'
    current_path.should == '/contests'
  end

  scenario 'visit the submissions page' do
    click_link 'Submit a contest idea'
    current_path.should == '/submissions/new'
  end

  scenario 'visit the hall of fame' do
    click_link 'Hall of Fame'
    current_path.should == '/users'
  end

end
