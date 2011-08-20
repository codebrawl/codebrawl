require 'acceptance/acceptance_helper'

feature 'Suggestions' do

  context 'on the index page' do

    background do
      ['Terminal admin', 'RSpec formatters'].each do |name|
        Fabricate(:suggestion, :name => name)
      end

      visit 'suggestions'
    end

    scenario 'see the list of suggestions' do

      page.should have_content 'Terminal admin'
      page.should have_content 'RSpec formatters'

    end

  end

end
