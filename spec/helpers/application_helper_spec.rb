require 'spec_helper'

describe ApplicationHelper do
  describe "link_to_profile" do
    before :each do
      @user = stub(
        :name => 'Charlie',
        :to_param => 'charlie',
        :gravatar_url => 'http://gravatar.org/profile.png'
      )
    end

    let(:output) { helper.link_to_profile(@user) }

    it "should include the gravatar image" do
      output.should include('<img')
      output.should include('src="http://gravatar.org/profile.png"')
    end

    it "should include the username" do
      output.should include("Charlie")
    end

    it "should html escape the username" do
      @user.stubs(:login => '<script>alert("xss")</script>')
      output.should_not include('<script>')
    end

    it "should link to the users profile" do
      output.should include('href="/users/charlie"')
    end
  end
end
