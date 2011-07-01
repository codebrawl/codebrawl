require 'spec_helper'

describe User do

  context 'fabrication' do

    it { Fabricate(:user).should be_valid }

  end

  context 'as admin' do
    it "should not be admin by default" do
      Fabricate(:user).should_not be_admin
    end
    
    it "should not allow mass assignement of the admin flag" do
      user = Fabricate(:user)
      user.update_attributes(:admin => true)
      user.reload.should_not be_admin
    end
  end

  context '#save!' do

    context 'when keeping all fields empty' do

      it { should have(1).error_on(:login) }

    end

  end

  describe "#to_param" do
    it "should use the login field" do
      User.new(:login => 'pete').to_param.should eql('pete')
    end
  end

  describe "#created?" do
    it "should tell if the object belongs to this user" do
      user = Fabricate(:user)
      contest = user.contests.create
      user.created?(contest).should be_true
    end

    it "should be false if the object does not belong to this user" do
      user = Fabricate(:user)
      other = Fabricate(:user)
      contest = user.contests.create
      other.created?(contest).should be_false
    end
  end
end
