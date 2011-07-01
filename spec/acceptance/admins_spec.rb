require 'acceptance/acceptance_helper'

feature 'Admins' do
  background(:all) do
    @admin = Fabricate(:user, :login => 'allmightyjeff', :admin => true)
    @user = Fabricate(:user)
    @contest = Fabricate(
      :contest,
      :name => 'Fun with ChunkyPNG',
      :starting_on => Date.yesterday.to_time
    )
    @open_contest = Fabricate(
      :contest,
      :name => 'Ruby metaprogramming',
      :starting_on => Date.yesterday.to_time,
      :user => @user
    )
  end

  background { login_via_github @admin }

  scenario 'edit a contest' do
    visit "/contests/#{@contest.to_param}"
    click_link "edit"
    
    fill_in 'Name', :with => "Even more fun with ChunkyPNG"
    click_button "Submit your contest"
    
    visit "/"
    page.should have_content("Even more fun with ChunkyPNG")
  end

  scenario 'edit a contest from another user' do
    visit "/contests/#{@open_contest.to_param}"
    click_link "edit"
    
    fill_in 'Tagline', :with => 'Ruby metaprogramming, who creates the best snail ghost method?'
    click_button "Submit your contest"
    
    visit "/"
    page.should have_content("Ruby metaprogramming, who creates the best snail ghost method?")
  end
end