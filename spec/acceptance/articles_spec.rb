require 'acceptance/acceptance_helper'

feature 'Article' do
  # TODO: find a better way to do this ;)
  around do |example|
    articles = "#{Rails.root}/app/blog/articles"
    article = "#{articles}/acceptance-testing-articles.html"
    
    `mkdir -p #{articles}`
    `ln -s #{Rails.root}/spec/fixtures/article.html #{article}`
    example.run
    `rm #{article}`
  end
  
  scenario 'show the full article' do
    visit '/articles/acceptance-testing-articles'
    page.should have_content 'Acceptance testing articles'
  end
  
end