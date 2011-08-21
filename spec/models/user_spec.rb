require 'spec_helper'

describe User do

  let(:entry) { Fabricate.build(:entry) }
  let(:contest) { entry.contest }
  let(:user) { Fabricate.build(:user, :login => 'charlie') }

  context 'fabrication' do

    it { Fabricate(:user).should be_valid }

  end

  context '#save!' do

    context 'when keeping all fields empty' do

      it { should have(1).error_on(:login) }

    end

  end

  describe "#to_param" do

    subject { user.to_param }

    it "should use the login field" do
      should eql('charlie')
    end

  end

  describe '#best_name' do

    subject { user.best_name }

    it { should == 'Charlie Chaplin' }

    context 'when not having a name' do
      before { user.stubs(:name).returns(nil) }

      it { should == 'charlie' }

    end

  end

  describe '#calculate_points' do

    before do
      user.stubs(:participations).returns([
        {'points' => 10},
        {'points' => 20},
        {'points' => 30}
      ])
    end

    subject { user.calculate_points }

    it 'should add the participation points together' do
      should == 60
    end

  end

  describe '#calculate_points!' do

    subject do
      user.stubs(:calculate_points).returns(60)
      user.calculate_points!
      user.reload.points
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
      user.stubs(:calculate_average_score).returns(4.3)
      user.calculate_average_score!
      user.reload.average_score
    end

    it 'should save the average score' do
      should == 4.3
    end

  end

  describe '#calculate_average_position' do

    context 'without participations' do

      subject { Fabricate(:user).calculate_average_position }

      it { should == 0.0 }

    end

    context 'with a participation without a position' do

      subject do
        Fabricate(
          :user,
          :participations => [ {}, {'position' => 2}, {'position' => 5} ]
        ).calculate_average_position
      end

      it { should == 3.5 }

    end

    context 'with a participations without a positions' do

      subject do
        Fabricate(
          :user,
          :participations => [ {}, {}, {} ]
        ).calculate_average_position
      end

      it { should == 0.0 }

    end


    context 'with participations' do

      subject do
        Fabricate(
          :user,
          :participations => [
            {'position' => 1}, {'position' => 2}, {'position' => 5}
          ]
        ).calculate_average_position
      end

      it { should == 2.6666666666666667 }

    end

  end

  describe '#calculate_average_points' do

    subject { user.calculate_average_points }

    it { should == 0.0 }

    context 'when having participations with scores' do

      subject do
        user.stubs(:calculate_points).returns(80)
        user.stubs(:participations).returns([{},{},{}])
        user.calculate_average_points
      end

      it { should == 26.666666666666668 }

    end

  end

  describe '#voted_entries' do

    before { entry.stubs(:votes_from?).with(user).returns(true) }

    it 'returns entries the user has voted on' do
       user.voted_entries(contest).should include(entry)
    end

  end

  describe '#participation_for?' do

    subject { user.participation_for?(contest) }

    context 'when the user has participated' do

      before do
        user.stubs(:participations).returns([{'contest_id' => contest.id}])
      end

      it { should be_true }

    end

    context 'when the user has not participated' do

      it { should be_false }

    end

  end

end
