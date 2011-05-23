require 'spec_helper'

describe 'Contest' do

  context '.make' do

    it 'creates a valid Contest' do
      Contest.make.valid?.should be_true
    end

  end

  context '.save!' do

    context 'when keeping all fields empty' do

      it 'should have name' do
        Contest.create.errors[:name].should include 'can\'t be blank'
      end

      it 'should have a start date' do
        Contest.create.errors[:starts_at].should include 'can\'t be blank'
      end

    end

    context 'when creating a valid contest' do

      it 'sets the state to open by default' do
        Contest.make.state.should == 'open'
      end

    end

  end

end
