require 'acceptance/acceptance_helper'

feature 'Submissions' do
  background { visit '/submissions/new' }

  scenario 'successfully submit a submission' do
    VCR.use_cassette(:wufoo) do
      fill_in 'idea', :with => 'Building an RSpec formatter'
      click_button 'Submit your idea'
    end

    page.should have_content 'Thanks for your submission! We\'ll check it out and let you know if we decide to use it.'
  end

  context 'when Wufoo is acting up' do
    before do
      Wufoo::Submission::Response.any_instance.stubs(:success?).returns(false)
    end

    scenario 'fail to add a submission' do
      VCR.use_cassette(:wufoo) do
        fill_in 'idea', :with => 'Building an RSpec formatter'
        click_button 'Submit your idea'
      end

      page.should have_content 'Something went wrong while sending your submission.'
    end

  end

end
