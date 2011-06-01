require 'spec_helper'

describe Entry do

  context '.make' do

    it { Entry.make.should be_valid }

  end

  context '#save!' do

    context 'when keeping all fields empty' do

      it { should have_a_presence_error_on(:description) }

    end

  end

  context '#contest' do

    it 'should have a contest' do
      contest = Contest.make
      Entry.make(:contest => contest).contest.should == contest
    end

  end

  context '#user' do

    it 'should have a user' do
      user = User.make
      Entry.make(:user => user).user.should == user
    end

  end

  context '.save!' do

    context 'when keeping all fields empty' do

      it { should have_a_presence_error_on(:user) }

    end

  end

end
