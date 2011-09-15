require 'spec_config'
require 'vcr_config'
require File.expand_path('lib/gist')

describe Gist do

  context 'after initializing with valid data' do

    before { @gist = Gist.new("200", '{"foo": "bar"}') }

    describe '#code' do

      subject { @gist.code }

      it { should == 200 }

    end

    describe '#body' do

      subject { @gist.body }

      it { should == '{"foo": "bar"}' }

    end

    describe '#["foo"]' do

      subject { @gist['foo'] }

      it { should == "bar" }

    end

  end

  describe '.fetch' do

    subject{ VCR.use_cassette('random_gist') { Gist.fetch('12345') } }

    it { should be_an_instance_of Gist }

    context 'the response code' do

      subject{ VCR.use_cassette('random_gist') { Gist.fetch('12345').code } }

      it { should == 200 }

    end

    context 'body' do

      subject{ VCR.use_cassette('random_gist') { Gist.fetch('12345').body } }

      it 'should contain the raw response body' do
        should == "{\"git_pull_url\":\"git://gist.github.com/12345.git\",\"url\":\"https://api.github.com/gists/12345\",\"forks\":[],\"git_push_url\":\"git@gist.github.com:12345.git\",\"files\":{\"gistfile1.txt\":{\"filename\":\"gistfile1.txt\",\"content\":\"~/testbed/dm_test $ rake dm:db:database_yaml\\r\\n(in /Users/jdempsey/testbed/dm_test)\\r\\n/Users/jdempsey/testbed/dm_test/config/init.rb:1: warning: already initialized constant KCODE\\r\\n ~ Loaded DEVELOPMENT Environment...\\r\\n ~ loading gem 'merb_datamapper' ...\\r\\n ~ loading gem 'dm-core' ...\\r\\n ~ loading gem 'merb_datamapper' ...\\r\\n ~ Merb::Orms::DataMapper::Connect block.\\r\\n ~ No database.yml file found in /Users/jdempsey/testbed/dm_test/config, assuming database connection(s) established in the environment file in /Users/jdempsey/testbed/dm_test/config/environments\\r\\n ~ Checking if we need to use DataMapper sessions\\r\\n ~ Merb::Orms::DataMapper::Connect complete\\r\\n ~ Compiling routes...\\r\\n ~ Starting Merb server listening at 0.0.0.0:4000\\r\\n\",\"size\":734,\"raw_url\":\"https://gist.github.com/raw/12345/1380168c2b5ea8616f09eeb50e8c3417e24453a8/gistfile1.txt\"}},\"html_url\":\"https://gist.github.com/12345\",\"user\":{\"url\":\"https://api.github.com/users/jackdempsey\",\"avatar_url\":\"https://secure.gravatar.com/avatar/1ccb5123d1af92e24b32cec62abcf9a8?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png\",\"login\":\"jackdempsey\",\"id\":479},\"public\":true,\"comments\":0,\"description\":null,\"history\":[{\"version\":\"a714a381787af0f56e86d12be63e0336bf0eea19\",\"url\":\"https://api.github.com/gists/12345/a714a381787af0f56e86d12be63e0336bf0eea19\",\"user\":null,\"change_status\":{\"deletions\":0,\"additions\":13,\"total\":13},\"committed_at\":\"2008-09-23T17:13:04Z\"}],\"id\":\"12345\",\"updated_at\":\"2009-10-14T11:53:04Z\",\"created_at\":\"2008-09-23T17:13:04Z\"}"
      end

    end

  end

  describe '.comment' do

    subject do
      VCR.use_cassette('gist_comment') do
        Gist.comment('12345', '54321', 'Comment!').body
      end
    end

    it 'should post a comment' do
      should == '{"url":"https://api.github.com/gists/comments/12345","user":{"url":"https://api.github.com/users/alice","login":"alice","avatar_url":"https://secure.gravatar.com/avatar/f03f4ce7b507aede386263d218228b6a?d=https://gs1.wac.edgecastcdn.net/80460E/assets%2Fimages%2Fgravatars%2Fgravatar-140.png","id":43621},"updated_at":"2011-07-13T16:59:06Z","created_at":"2011-07-13T16:59:06Z","body":"Comment!","id":40155}'
    end

  end

  describe '#files' do

    let(:gist) do
      Gist.new('200', '{}')
    end

    subject { gist.files }

    before do
      gist.stubs(:[]).with('files').returns({
        'README' => { 'content' => 'foo' }
      })
    end

    it { should == {'README' => {'content' => 'foo'}} }

    context 'when having a file with an extension' do

      before do
        gist.stubs(:[]).with('files').returns({
          'foo.bar' => { 'content' => 'foo' }
        })
      end

      it { should == {'foo*bar' => {'content' => 'foo'}} }

    end

    context 'when having a PNG file' do

      before do
        gist.stubs(:[]).with('files').returns({
          'foo.png' => { 'content' => 'foo' }
        })
      end

      it { should == {'foo*png' => {'content' => nil}} }

    end

  end

end
