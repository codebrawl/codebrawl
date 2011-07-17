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

  describe '#voted_entries' do

    let(:contest) { Fabricate(:contest) }
    let(:user) { Fabricate(:user) }
    let(:entry) { contest.entries.create }

    before { entry.stubs(:votes_from?).with(user).returns(true) }

    it 'returns entries the user has voted on' do
      user.voted_entries(contest).should include(entry)
    end

  end

  describe '#average_score' do
    subject do
      Fabricate(
        :user
      ).average_score
    end

    it 'should return 0.0' do
      should == 0.0
    end
    
    context 'for a user that has participations' do

      subject do
        Fabricate(
          :user,
          :participations => [{'score' => 1}, {'score' => 3}, {'score' => 4}]
        ).average_score
      end

      it 'should calculate the average score' do
        should == 2.6666666666666665
      end

    end

  end

end
