require 'spec_helper'

describe User do

  let(:entry) { Fabricate.build(:entry) }
  let(:contest) { entry.contest }
  let(:user) { Fabricate.build(:user, :login => 'charlie') }

  describe '#best_name' do

    subject { user.best_name }

    it { should == 'charlie' }

    context 'when having a full name' do
      before { user.stubs(:name).returns('Charlie Chaplin') }

      it { should == 'Charlie Chaplin' }

    end

  end

  describe '#voted_entries' do

    before { entry.stubs(:votes_from?).with(user).returns(true) }

    it 'returns entries the user has voted on' do
       user.voted_entries(contest).should include(entry)
    end

  end

end
