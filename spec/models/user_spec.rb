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

  describe '#calculate_points' do

    subject do
      Fabricate(
        :user,
        :participations => [
          {'points' => 10}, {'points' => 20}, {'points' => 30}
        ]
      ).calculate_points
    end

    it 'should add the participation points together' do
      should == 60
    end

  end

  describe '#calculate_points!' do

    subject do
      @user = Fabricate(:user)
      @user.stubs(:calculate_points).returns(60)
      @user.calculate_points!
      @user.reload.points
    end

    it 'should save the points' do
      should == 60
    end

  end

end
