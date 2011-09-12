require 'spec_helper'

describe User do

  let(:entry) { Fabricate.build(:entry) }
  let(:contest) { entry.contest }
  let(:user) { Fabricate.build(:user, :login => 'charlie') }

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

    it { should == 'charlie' }

    context 'when having a full name' do
      before { user.stubs(:name).returns('Charlie Chaplin') }

      it { should == 'Charlie Chaplin' }

    end

  end

  describe '#points' do

    subject { user.points }
    it { should == 0 }

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

  describe '#voted_entries' do

    before { entry.stubs(:votes_from?).with(user).returns(true) }

    it 'returns entries the user has voted on' do
       user.voted_entries(contest).should include(entry)
    end

  end

end
