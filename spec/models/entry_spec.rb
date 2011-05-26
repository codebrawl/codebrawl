require 'spec_helper'

describe Entry do

  context '.make' do

    it { Entry.make.should be_valid }

  end

  context '#contest' do

    it 'should have a contest' do
      contest = Contest.make
      Entry.make(:contest => contest).contest.should == contest
    end

  end
end
