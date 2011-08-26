require 'spec_config'
require File.expand_path('lib/state')

class ObjectWithState
  include State
end

describe State do

  let(:object) do
    object = ObjectWithState.new
    object.stubs(:closing_at).returns(Time.now + 3600)
    object.stubs(:voting_at).returns(Time.now + 3600)
    object.stubs(:starting_at).returns(Time.now + 3600)
    object
  end

  describe '#state' do

    subject { object.state }

    it { should == 'pending' }

    context 'when the closing_at date has passed' do

      before { object.stubs(:closing_at).returns(Time.now) }

      it { should == 'finished' }

    end

    context 'when the voting_at date has passed' do

      before { object.stubs(:voting_at).returns(Time.now) }

      it { should == 'voting' }

    end

    context 'when the starting_at date has passed' do

      before { object.stubs(:starting_at).returns(Time.now) }

      it { should == 'open' }

    end

  end

  context '#pending?' do

    subject { object.pending? }

    context 'when the object state is "pending"' do

      before { object.stubs(:state).returns('pending') }

      it { should be_true }

    end

    context 'when the object state is not "pending"' do

      before { object.stubs(:state).returns('notpending') }

      it { should be_false }

    end

  end

  context '#open?' do

    subject { object.open? }

    context 'when the object state is "open"' do

      before { object.stubs(:state).returns('open') }

      it { should be_true }

    end

    context 'when the object state is not "open"' do

      before { object.stubs(:state).returns('notopen') }
      it { should be_false }

    end

  end

  context '#voting?' do

    subject { object.voting? }

    context 'when the object state is "voting"' do

      before { object.stubs(:state).returns('voting') }

      it { should be_true }

    end

    context 'when the object state is not "voting"' do

      before { object.stubs(:state).returns('notvoting') }

      it { should be_false }

    end

  end

  context '#finished?' do

    subject { object.finished? }

    context 'when the object state is "finished"' do

      before { object.stubs(:state).returns('finished') }

      it { should be_true }

    end

    context 'when the object state is not "finished"' do

      before { object.stubs(:state).returns('notfinished') }

      it { should be_false }

    end

  end

end

