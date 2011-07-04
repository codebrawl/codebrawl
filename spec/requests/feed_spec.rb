require 'spec_helper'

describe 'Feed' do
  
  context 'when having a single contest' do
    before(:all) do
      Fabricate(:contest, :name => 'RSpec formatters', :description => 'Write your own _RSpec_ formatter.')
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
    
    it 'should have the contest description, parsed with markdown' do
      @contests.first['content'].should == "<p>Write your own <em>RSpec</em> formatter.</p>\n"
    end
    
    it 'should have the author' do
      @contests.first['author'].should == {"name"=>"Charlie Chaplin"}
    end
    
    it 'should have a link to the contest' do
      @contests.first['link'].should == {"rel"=>"alternate", "type"=>"text/html", "href"=>"http://www.example.com/contests/rspec-formatters"}
    end
    
  end
  
end
