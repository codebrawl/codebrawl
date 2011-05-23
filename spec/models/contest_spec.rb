require 'spec_helper'

describe 'Contest' do

  context ".make" do

    it 'creates a valid Contest' do
      Contest.make.valid?.should be_true
    end

  end

end
