require 'spec_helper'

describe Contest do

  context '.make' do

    it { Contest.make.should be_valid }

  end

  context '.save!' do

    context 'when keeping all fields empty' do

      it { should have_a_presence_error_on(:name) }

      it { should have_a_presence_error_on(:starts_at) }

    end

    context 'when creating a valid contest' do

      it 'should set the state to \'open\' by default' do
        Contest.make.state.should == 'open'
      end

    end

  end

end
