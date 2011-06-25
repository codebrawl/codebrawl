require 'spec_helper'

describe User do

  context 'fabrication' do

    it { Fabricate(:user).should be_valid }

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

end
