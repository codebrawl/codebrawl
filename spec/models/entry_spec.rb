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

  context '#votes' do

    it 'should have a list of votes' do
      votes = [Vote.make]
      Entry.make(:votes => votes).votes.should == votes
    end

  end

  context '#comments' do

    it 'should have a list of comments' do
      comments = [Comment.make]
      Entry.make(:comments => comments).comments.should == comments
    end

  end

  context '.save!' do

    context 'when keeping all fields empty' do

      it { should have_a_presence_error_on(:user) }

    end

  end

  context '#score' do

    context 'when the score attribute is set' do

      subject { Entry.make(:score => 4.3).score }

      it { should == 4.3 }

    end

    context 'when not having a score attribute' do

      subject do
        @entry = Entry.make
        @entry.score
      end

      it { should == 0.0 }

      it { should == @entry.read_attribute(:score) }

      context 'when having some votes' do
        subject do
          @entry = Entry.make(
            :votes => [
              Vote.make(:score => 2),
              Vote.make(:score => 4),
              Vote.make(:score => 1)
            ]
          )
          @entry.score
        end

        it { should == 2.3333333333333335 }

        it { should == @entry.read_attribute(:score) }

      end

    end

  end

end
