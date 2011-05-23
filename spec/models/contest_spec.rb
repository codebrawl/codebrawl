require 'spec_helper'

describe 'Contest' do

  context '.make' do

    it 'creates a valid Contest' do
      Contest.make.valid?.should be_true
    end

  end

  context '.save!' do

    it 'should have a name' do
      Contest.create.errors[:name].should_not be_empty
    end

  end

end
