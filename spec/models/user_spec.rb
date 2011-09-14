require 'spec_helper'

describe User do

  let(:entry) { Fabricate.build(:entry) }
  let(:contest) { entry.contest }
  let(:user) { Fabricate.build(:user, :login => 'charlie') }

  describe '#voted_entries' do

    before { entry.stubs(:votes_from?).with(user).returns(true) }

    it 'returns entries the user has voted on' do
       user.voted_entries(contest).should include(entry)
    end

  end

end
