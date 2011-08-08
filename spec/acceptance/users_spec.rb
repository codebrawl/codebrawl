require 'acceptance/acceptance_helper'

feature 'Users' do

  background(:all) do

    %w{ alice bob hans david }.each_with_index do |login, index|
      Fabricate(
        :user,
        :login => login,
        :points => index * 100,
        :average_score => 2.456
      )
    end

    Fabricate(:user, :login => 'frank')
    Fabricate(
      :user,
      :login => 'gary',
      :points => 200,
      :participations => [
        {:score => 1, :position => 3}, {:score => 2, :position => 2}
      ],
      :average_score => 3.5
    )

  end

  context 'on the user index' do

    background { visit '/users' }

    scenario 'see the user logins, as links' do
      %w{ bob hans david }.each { |login| page.should have_link login }
    end

    scenario 'see the users, ordered by points' do

      within(:xpath, '//tr[1]') do
        page.should have_content '#1'
        page.should have_link 'david'
        body.should include 'href="/users/david"'
        page.should have_content '2.5'
        page.should have_content '300'
      end

      within(:xpath, '//tr[2]') do
        page.should have_content '#2'
        page.should have_link 'gary'
        body.should include 'href="/users/gary"'
        page.should have_content '3.5'
        page.should have_content '200'
        within(:xpath, '//tr[2]/td[6]') do
          page.should have_content '2'
        end
        page.should have_content '2.5'
      end

      within(:xpath, '//tr[3]') do
        page.should have_content '#3'
        page.should have_link 'hans'
        body.should include 'href="/users/hans"'
        page.should have_content '200'
      end

      within(:xpath, '//tr[4]') do
        page.should have_content '#4'
        page.should have_link 'bob'
        body.should include 'href="/users/bob"'
        page.should have_content '100'
      end

    end

    scenario 'do not see users without any points' do
      page.should have_no_content 'alice'
    end

  end

  context 'on a user profile' do

    background(:all) do
      # TODO: stub `Contest#state` instead of setting the voting and closing
      # dates.
      user = Fabricate(
        :user,
        :login => 'eric',
        :urls => {
          "GitHub" => "https://github.com/eric",
          "Blog" => "http://ericsblog.com",
          "Blog2" => nil
        },
        :participations => [
          {:score => 1, :position => 5}, {:score => 2, :position => 2}, {:score => 4, :position => 1}
        ],
        :average_score => 2.2678
      )

      VCR.use_cassette('existing_gist') do
        Fabricate(
          :contest,
          :name => 'RSpec extensions',
          :closing_on => Date.yesterday.to_time,
          :entries => [ Fabricate.build(:entry, :user => user) ]
        )

        Fabricate(
          :contest,
          :name => 'Fun with ChunkyPNG',
          :starting_on => Date.yesterday.to_time,
          :entries => [ Fabricate.build(:entry, :user => user) ]
        )

        Fabricate(
          :contest,
          :name => 'Terminal Twitter clients',
          :voting_on => Date.yesterday.to_time,
          :entries => [ Fabricate.build(:entry, :user => user) ]
        )

        Fabricate(
          :contest,
          :name => 'Ruby metaprogramming',
          :starting_on => Date.yesterday.to_time,
          :user => user
        )

      end

      visit '/users/eric'

    end

    scenario 'view a user profile' do
      page.should have_content 'eric'
    end

    scenario 'see the user gravatar' do
      body.should include 'http://gravatar.com/avatar/1dae832a3c5ae2702f34ed50a40010e8.png'
    end

    scenario 'see the link to the user github profile' do
      page.should have_link 'eric on Github'
      body.should include 'href="https://github.com/eric"'
    end

    scenario 'see the links to the user website' do
      page.should have_link 'http://ericsblog.com'
      body.should include 'href="http://ericsblog.com"'
    end

    scenario 'do not show nil links' do
      page.should have_no_link '/users/eric'
    end

    scenario 'see the average score' do
      page.should have_content 'Average score: 2.3/5'
    end

    scenario 'see the average position' do
      page.should have_content 'Average position: 2.7'
    end

    scenario 'see the list of entered contests' do
      page.should have_content 'RSpec extensions'
    end

    scenario 'do not see any entered contests that are still open' do
      page.should have_no_content 'Fun with ChunkyPNG'
      page.should have_no_content 'Terminal Twitter clients'
    end

    scenario 'see the list of submitted contests' do
      page.should have_content 'Ruby metaprogramming'
    end

  end

  context 'on user profiles' do

    scenario 'show the user position' do

      {
        'david' => {:position => 1, :points => 300},
        'hans' => {:position => 2, :points => 200},
        'gary' => {:position => 3, :points => 200},
        'bob' => {:position => 4, :points => 100}
      }.each do |login, data|
        visit "/users/#{login}"
        page.should have_content "##{data[:position]}"
        page.should have_content data[:points]
      end


    end

  end
  
  context 'when trying to visit a user profile that does not exist' do

    scenario 'see the "not found"-page' do
      lambda{
        visit '/users/zach'
      }.should raise_error ActionController::RoutingError
    end

  end

end
