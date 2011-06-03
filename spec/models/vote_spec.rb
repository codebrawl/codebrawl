require 'spec_helper'

describe Vote do

  context '.make' do

    it { Vote.make.should be_valid }

  end

end
