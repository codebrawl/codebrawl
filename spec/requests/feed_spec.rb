require 'spec_helper'

describe 'Feed' do
  
  context 'when having a single contest' do
    before(:all) do
      Fabricate(:contest, :name => 'RSpec formatters', :description => 'Write your own _RSpec_ formatter.')
      get 'contests.atom'
      @contest = Hash.from_xml(response.body)['feed']['entry']
    end
    
    it 'should have the contest title' do
      @contest['title'].should == 'RSpec formatters'
    end
    
    it 'should have the contest description, parsed with markdown' do
      @contest['content'].should == "<p>Write your own <em>RSpec</em> formatter.</p>\n"
    end
    
    it 'should have the author' do
      @contest['author'].should == {"name"=>"Charlie Chaplin"}
    end
    
    it 'should have a link to the contest' do
      @contest['link'].should == {"rel"=>"alternate", "type"=>"text/html", "href"=>"http://www.example.com/contests/rspec-formatters"}
    end
    
  end
  
  context 'when having multiple contests' do
    before(:all) do
      Fabricate(:contest)
      get 'contests.atom'
      @contests = Hash.from_xml(response.body)['feed']['entry']
    end
    
    it 'should have both contests' do
      @contests.should have(2).items
    end
  end
  
end
