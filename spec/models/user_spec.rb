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

  describe '#calculate_average_score' do

    subject do
      Fabricate(
        :user,
        :participations => [
          {'score' => 1.0}, {'score' => 2.0}, {'score' => 5.0}
        ]
      ).calculate_average_score
    end

    it 'should calculate the average score' do
      should == 2.6666666666666667
    end

  end

  describe '#calculate_average_score!' do

    subject do
      @user = Fabricate(:user)
      @user.stubs(:calculate_average_score).returns(4.3)
      @user.calculate_average_score!
      @user.reload.average_score
    end

    it 'should save the average score' do
      should == 4.3
    end

  end

  describe '#calculate_average_position' do

    subject do
      Fabricate(
        :user,
        :participations => [
          {'position' => 1}, {'position' => 2}, {'position' => 5}
        ]
      ).calculate_average_position
    end

    it 'should calculate the average position' do
      should == 2.6666666666666667
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

  describe '#participation_for?' do

    before do
      @contest = Fabricate(:contest)
      @user = Fabricate(:user)
    end

    subject { @user.participation_for?(@contest) }

    context 'when the user has participated' do

      before do
        @user.stubs(:participations).returns([{'contest_id' => @contest.id}])
      end

      it { should be_true }

    end

    context 'when the user has not participated' do

      it { should be_false }

    end

  end

end
