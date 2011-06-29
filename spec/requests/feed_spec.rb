require 'spec_helper'

describe 'Feed' do
  
  context 'when having a single contest' do
    before do
      Fabricate(:contest, :name => 'RSpec formatters', :description => 'Write your own RSpec formatter...')
      Fabricate(:contest)
      get 'contests.atom'
      @contests = Hash.from_xml(response.body)['feed']['entry']
    end
        
    it 'should have both contests' do
      @contests.should have(2).items
    end
        
    it 'should have the contest title' do
      @contests.first['title'].should == 'RSpec formatters'
    end
    
    it 'should have the contest description' do
      @contests.first['content'].should == 'Write your own RSpec formatter...'
    end
    
    it 'should have the author' do
      @contests.first['author'].should == {"name"=>"Charlie Chaplin"}
    end
    
    it 'should have a link to the contest' do
      @contests.first['link'].should == {"rel"=>"alternate", "type"=>"text/html", "href"=>"http://www.example.com/contests/rspec-formatters"}
    end
    
  end
  
end
